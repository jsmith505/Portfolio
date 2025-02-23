# AWS Elastic Load Balancing (ELB) 

## Overview
AWS Elastic Load Balancing (ELB) automatically distributes incoming application traffic across multiple targets, such as EC2 instances, containers, and IP addresses. ELB improves fault tolerance, scalability, and availability.

## Types of Load Balancers

### 1. **Application Load Balancer (ALB)**
   - **Best for:** HTTP/HTTPS traffic (Layer 7)
   - **Features:**
     - Supports host-based, path-based, and query parameter-based routing
     - Can route requests to multiple target groups
     - Supports WebSockets and HTTP/2
     - Integrated with AWS WAF for security
   - **Use Cases:**
     - Microservices-based architectures
     - Web applications needing advanced routing
     - Host/path-based routing for multi-tenant applications

### 2. **Network Load Balancer (NLB)**
   - **Best for:** TCP, UDP, and TLS traffic (Layer 4)
   - **Features:**
     - Ultra-low latency
     - Scales to handle millions of requests per second
     - Provides static IP and Elastic IP support
     - Supports TLS termination
   - **Use Cases:**
     - Real-time applications (e.g., gaming, financial apps)
     - Load balancing to on-premises via AWS Direct Connect
     - Applications needing static IP addresses

### 3. **Gateway Load Balancer (GWLB)**
   - **Best for:** Deploying, scaling, and managing third-party virtual appliances (Layer 3)
   - **Features:**
     - Operates at the network layer (Layer 3)
     - Ensures high availability of appliances
     - Simplifies integration with security and monitoring tools
   - **Use Cases:**
     - Deploying network firewalls, IDS/IPS, and packet inspection
     - Centralized security solutions in AWS environments

### 4. **Classic Load Balancer (CLB) [Legacy]**
   - **Best for:** Basic load balancing (Layer 4 and Layer 7) in older architectures
   - **Features:**
     - Simple round-robin or least connections routing
     - Supports both HTTP/HTTPS and TCP traffic
     - SSL termination support
   - **Use Cases:**
     - Legacy applications
     - Basic load balancing needs without advanced routing

## Choosing the Right Load Balancer
| Feature | ALB | NLB | GWLB | CLB (Legacy) |
|---------|-----|-----|------|-------------|
| Layer | 7 (Application) | 4 (Network) | 3 (Gateway) | 4 & 7 (Basic) |
| Protocols | HTTP, HTTPS | TCP, UDP, TLS | IP | HTTP, HTTPS, TCP |
| Advanced Routing | Yes | No | No | No |
| WebSockets Support | Yes | No | No | No |
| Static IP Support | No | Yes | No | No |
| AWS WAF Integration | Yes | No | No | No |

## Additional Considerations
- **Health Checks:** All ELBs support health checks to ensure traffic is routed only to healthy targets.
- **SSL/TLS Termination:** ALB, NLB, and CLB support SSL/TLS termination to offload encryption processing from backend servers.
- **Autoscaling Integration:** ELB integrates seamlessly with AWS Auto Scaling for dynamic scaling.
- **Cross-Zone Load Balancing:**
  - Enabled by default on ALB and CLB
  - Optional for NLB (must be manually enabled)

## Summary
AWS ELB provides different types of load balancers to suit various needs. Choose ALB for application-level routing, NLB for high-performance network traffic, GWLB for managing security appliances, and CLB for basic legacy applications.
