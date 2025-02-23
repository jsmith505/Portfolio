# **Prometheus & Grafana for AWS**  

## **Overview**  
Prometheus and Grafana are powerful open-source monitoring tools widely used for cloud infrastructure, containerized applications, and microservices. Prometheus collects and stores metrics, while Grafana provides visualization and alerting.

---

## **1. Prometheus Overview**  

✅ **Time-series database** for collecting and storing metrics.  
✅ Uses a **pull-based model** to scrape data from configured targets.  
✅ Provides **PromQL** (Prometheus Query Language) for data analysis.  
✅ Supports **Alertmanager** for setting up alerts.  

### **Installing Prometheus on an EC2 Instance**  
```sh
# Download and extract Prometheus
wget https://github.com/prometheus/prometheus/releases/latest/download/prometheus-linux-amd64.tar.gz
tar -xvzf prometheus-linux-amd64.tar.gz
cd prometheus-*/

# Start Prometheus
./prometheus --config.file=prometheus.yml
```

### **Prometheus Configuration (`prometheus.yml`)**  
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'ec2'
    ec2_sd_configs:
      - region: us-east-1
        access_key: YOUR_AWS_ACCESS_KEY
        secret_key: YOUR_AWS_SECRET_KEY
    relabel_configs:
      - source_labels: [__meta_ec2_instance_id]
        target_label: instance
```

---

## **2. Grafana Overview**  

✅ **Dashboarding tool** for visualizing Prometheus data.  
✅ Supports **custom alerts** and notifications.  
✅ Integrates with AWS CloudWatch, Loki, and other data sources.  
✅ Allows **templating and custom queries** for flexible visualizations.  

### **Installing Grafana on an EC2 Instance**  
```sh
# Add the Grafana repository
sudo yum install -y https://dl.grafana.com/oss/release/grafana-9.0.0-1.x86_64.rpm

# Start and enable Grafana
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Check status
systemctl status grafana-server
```

### **Accessing Grafana**  
- Open a browser and navigate to `http://<EC2_PUBLIC_IP>:3000`  
- Default credentials:  
  - **Username:** `admin`  
  - **Password:** `admin` (prompted to change on first login)  

### **Adding Prometheus as a Data Source**  
1. Go to **Grafana UI** → **Configuration** → **Data Sources**  
2. Select **Prometheus**  
3. Enter the Prometheus server URL: `http://<EC2_INSTANCE_IP>:9090`  
4. Click **Save & Test**  

---

## **3. Deploying Prometheus & Grafana on AWS ECS (Fargate Mode)**  

### **Step 1: Define an ECS Task for Prometheus**
Create an **ECS Task Definition** (`prometheus-task.json`)  

```json
{
  "family": "prometheus",
  "containerDefinitions": [
    {
      "name": "prometheus",
      "image": "prom/prometheus:latest",
      "memory": 512,
      "cpu": 256,
      "portMappings": [
        {
          "containerPort": 9090,
          "hostPort": 9090
        }
      ]
    }
  ]
}
```

### **Step 2: Define an ECS Task for Grafana**  
Create an **ECS Task Definition** (`grafana-task.json`)  

```json
{
  "family": "grafana",
  "containerDefinitions": [
    {
      "name": "grafana",
      "image": "grafana/grafana:latest",
      "memory": 512,
      "cpu": 256,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ]
    }
  ]
}
```

### **Step 3: Run Prometheus & Grafana on ECS**  
```sh
aws ecs create-service --cluster my-cluster \
  --service-name prometheus-service \
  --task-definition prometheus \
  --desired-count 1 \
  --launch-type FARGATE

aws ecs create-service --cluster my-cluster \
  --service-name grafana-service \
  --task-definition grafana \
  --desired-count 1 \
  --launch-type FARGATE
```

---

## **4. Prometheus Query Language (PromQL) Cheat Sheet**  

### **Basic Queries**  
```promql
# Show CPU usage of all instances
node_cpu_seconds_total  

# Filter by instance
node_cpu_seconds_total{instance="i-1234567890"}  

# Calculate CPU usage per second
rate(node_cpu_seconds_total[5m])  
```

### **Memory & Disk Usage**  
```promql
# Memory usage percentage
(node_memory_Active_bytes / node_memory_MemTotal_bytes) * 100  

# Disk space used
node_filesystem_size_bytes - node_filesystem_free_bytes  
```

### **Network & Latency**  
```promql
# Incoming network traffic
rate(node_network_receive_bytes_total[5m])  

# Request latency (95th percentile)
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))  
```

---

## **5. Setting Up Prometheus Alerts**  

### **Install Alertmanager**  
```sh
wget https://github.com/prometheus/alertmanager/releases/latest/download/alertmanager-linux-amd64.tar.gz
tar -xvzf alertmanager-linux-amd64.tar.gz
cd alertmanager-*/
./alertmanager --config.file=alertmanager.yml
```

### **Example Alert Rule (`alerts.yml`)**  
```yaml
groups:
  - name: instance_down
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Instance {{ $labels.instance }} is down"
```

### **Configure Alertmanager (`alertmanager.yml`)**  
```yaml
global:
  resolve_timeout: 5m

route:
  group_by: ['instance']
  receiver: 'email-notifications'

receivers:
  - name: 'email-notifications'
    email_configs:
      - to: 'admin@example.com'
        from: 'alertmanager@example.com'
        smarthost: 'smtp.example.com:587'
        auth_username: 'admin'
        auth_password: 'password'
```

---

## **6. AWS Managed Prometheus & Grafana**  

AWS offers **Amazon Managed Service for Prometheus (AMP)** and **Amazon Managed Grafana**, which simplify deployment.

### **Amazon Managed Prometheus (AMP)**  
✅ Fully managed Prometheus-compatible monitoring.  
✅ Stores **time-series data** at scale.  
✅ Integrated with **AWS CloudWatch & AWS IAM**.  

**Example: Sending Metrics to AMP**  
```sh
aws amp create-workspace --alias my-prometheus
```

### **Amazon Managed Grafana**  
✅ Hosted Grafana dashboards with AWS integration.  
✅ Supports IAM authentication & CloudWatch data sources.  

**Example: Creating a Grafana Workspace**  
```sh
aws grafana create-workspace --name my-grafana --authentication-providers AWS_SSO
```

---

## **7. Best Practices**  

🔹 **Use AWS IAM roles** for authentication instead of static credentials.  
🔹 **Enable AWS Auto Scaling** for ECS tasks to handle metric spikes.  
🔹 **Use AWS CloudWatch** to monitor Prometheus/Grafana instances.  
🔹 **Secure Prometheus endpoints** with an ALB and AWS WAF.  
🔹 **Automate dashboards** using Grafana JSON models and Terraform.  

---

## **Conclusion**  

🚀 **Prometheus & Grafana provide robust monitoring** for AWS infrastructure.  
🔹 **Prometheus collects detailed time-series metrics**, while **Grafana visualizes them**.  
🔹 **Deploying on ECS/Fargate simplifies scalability** and integrates well with AWS.  
🔹 **AWS Managed Services for Prometheus & Grafana reduce operational overhead**.  
