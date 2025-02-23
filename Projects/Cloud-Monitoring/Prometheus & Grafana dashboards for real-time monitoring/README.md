# Prometheus & Grafana Dashboards for Real-Time Monitoring

## Overview

Prometheus and Grafana are widely used for real-time monitoring and alerting. Prometheus is a powerful open-source monitoring system that collects metrics from configured targets at specified intervals, while Grafana is a visualization tool that creates interactive dashboards to display the data collected by Prometheus.

This guide will walk you through setting up Prometheus and Grafana to monitor your infrastructure and applications in real time, providing insights into system performance, health, and usage metrics.

## Features

- **Real-time Monitoring**: Collect and visualize real-time metrics for your infrastructure and applications.
- **Prometheus Metrics Collection**: Scrape and store time-series metrics from various sources (e.g., EC2, Kubernetes, custom applications).
- **Grafana Dashboards**: Visualize metrics using Grafana dashboards with customizable visual elements like graphs, gauges, and tables.
- **Alerting**: Set up alerts in Grafana or Prometheus to notify you when metrics exceed thresholds.
- **Integration**: Easily integrate with other systems like AWS, Kubernetes, Docker, and more.

## Prerequisites

- Prometheus installed and configured to scrape metrics
- Grafana installed and configured for visualization
- Metrics exporters set up for the services you want to monitor (e.g., Node Exporter, cAdvisor, etc.)
- Access to a Grafana instance for dashboard creation

## Step 1: Setting Up Prometheus

### 1.1 Install Prometheus

Prometheus can be installed by following the [official installation guide](https://prometheus.io/docs/prometheus/latest/installation/).

For Linux systems:

```bash
# Download Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.40.0/prometheus-2.40.0.linux-amd64.tar.gz

# Extract the tarball
tar -xvzf prometheus-2.40.0.linux-amd64.tar.gz

# Move Prometheus binary to /usr/local/bin
sudo mv prometheus-2.40.0.linux-amd64/prometheus /usr/local/bin/

# Move Prometheus configuration and data
sudo mv prometheus-2.40.0.linux-amd64/promtool /usr/local/bin/
sudo mv prometheus-2.40.0.linux-amd64/consoles /etc/prometheus
sudo mv prometheus-2.40.0.linux-amd64/console_libraries /etc/prometheus

# Create a Prometheus configuration file
sudo nano /etc/prometheus/prometheus.yml
