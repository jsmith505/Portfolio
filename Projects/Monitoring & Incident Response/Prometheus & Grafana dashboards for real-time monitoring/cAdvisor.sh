# Run cAdvisor in a Docker container
docker run -d \
  --name=cadvisor \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  --volume=/sys:/sys \
  --volume=/var/lib/docker/:/var/lib/docker/ \
  --publish=8080:8080 \
  google/cadvisor:latest
