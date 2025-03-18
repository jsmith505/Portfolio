# Install Grafana
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt-get install grafana

# Start Grafana service
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
