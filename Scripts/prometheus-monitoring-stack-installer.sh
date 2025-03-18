#!/bin/bash

set -e

# Create Prometheus user
sudo useradd --system --no-create-home --shell /bin/false prometheus

# Download and install Prometheus
PROMETHEUS_VERSION="2.32.1"
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar -xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
sudo mkdir -p /etc/prometheus /data
cd prometheus-${PROMETHEUS_VERSION}.linux-amd64
sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles/ console_libraries/ /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus /data
cd ..
rm -rf prometheus*

# Create Prometheus service
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/data --web.listen-address=0.0.0.0:9090

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable --now prometheus

# Install Node Exporter
NODE_EXPORTER_VERSION="1.3.1"
sudo useradd --system --no-create-home --shell /bin/false node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
sudo mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter*

# Create Node Exporter service
cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable --now node_exporter

# Install Grafana
sudo apt-get install -y apt-transport-https software-properties-common
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update && sudo apt-get install -y grafana
sudo systemctl enable --now grafana-server

# Install and configure Pushgateway
PUSHGATEWAY_VERSION="1.4.2"
sudo useradd --system --no-create-home --shell /bin/false pushgateway
wget https://github.com/prometheus/pushgateway/releases/download/v${PUSHGATEWAY_VERSION}/pushgateway-${PUSHGATEWAY_VERSION}.linux-amd64.tar.gz
tar -xvf pushgateway-${PUSHGATEWAY_VERSION}.linux-amd64.tar.gz
sudo mv pushgateway-${PUSHGATEWAY_VERSION}.linux-amd64/pushgateway /usr/local/bin/
rm -rf pushgateway*

cat <<EOF | sudo tee /etc/systemd/system/pushgateway.service
[Unit]
Description=Pushgateway
Wants=network-online.target
After=network-online.target

[Service]
User=pushgateway
Group=pushgateway
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/pushgateway

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable --now pushgateway

# Install and configure Alertmanager
ALERTMANAGER_VERSION="0.23.0"
sudo useradd --system --no-create-home --shell /bin/false alertmanager
wget https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
tar -xvf alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
sudo mv alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/alertmanager /usr/local/bin/
rm -rf alertmanager*

cat <<EOF | sudo tee /etc/systemd/system/alertmanager.service
[Unit]
Description=Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/alertmanager --storage.path=/alertmanager-data --config.file=/etc/alertmanager/alertmanager.yml

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable --now alertmanager

# Display installed versions
prometheus --version
node_exporter --version
pushgateway --version
alertmanager --version
grafana-cli -v

# Setup complete
echo "Prometheus, Node Exporter, Grafana, Pushgateway, and Alertmanager have been installed and started successfully."
