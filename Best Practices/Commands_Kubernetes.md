# Kubernetes Commands Cheat Sheet

## Pod Commands
- **Get Pod Information**
  - `kubectl get pod`: Get a list of pods.
  - `kubectl get pod -o wide`: Get detailed pod information.
  - `kubectl get pod -w`: Watch pod changes in real-time.
  - `kubectl get pod -o yaml`: Get pod details in YAML format.
  
- **Pod Operations**
  - `kubectl describe pod <pod_name>`: Describe pod details.
  - `kubectl edit pod <pod_name>`: Edit pod configuration.
  - `kubectl delete pod <pod_name>`: Delete a pod.
  - `kubectl logs pod <pod_name>`: View pod logs.
  - `kubectl exec -it pod <pod_name> /bin/bash`: Execute a shell in the pod.

## Node Commands
- **Node Information**
  - `kubectl describe node <node_name>`: Describe a node.
  - `kubectl get node <node_name>`: Get details of a node.
  - `kubectl get node <node_name> -o yaml`: Get node details in YAML format.

- **Node Operations**
  - `kubectl drain node <node_name>`: Drain a node (evacuate all pods).
  - `kubectl cordon node <node_name>`: Mark a node as unschedulable.
  - `kubectl uncordon node <node_name>`: Mark a node as schedulable again.

## Creating Objects
- **Create Resources**
  - `kubectl apply -f <file_name>.yaml`: Create resources from a YAML file.
  - `kubectl apply -f ./<directory_name>`: Apply all files in a directory.
  - `kubectl apply -f https://<url>`: Create resources from a URL.

- **Create Pod**
  - `kubectl run <pod_name> --image=<image_name>`: Create a pod from an image.
  - `kubectl run <pod_name> --image=<image_name> --port=<port> --expose`: Create a pod and expose it as a service.

- **Create YAML Files**
  - `kubectl run <pod_name> --image=<image_name> --dry-run=client -o yaml > <file_name>.yaml`: Generate Pod YAML file.
  - `kubectl create deployment <deployment_name> --image=<image_name>`: Create a deployment from an image.
  - `kubectl create deployment <deployment_name> --image=<image_name> --dry-run=client -o yaml > <file_name>.yaml`: Generate Deployment YAML file.
  
- **Create Service**
  - `kubectl create service <service-type> <service_name> --tcp=<port:target_port>`: Create a service.
  - `kubectl create service <service-type> <service_name> --tcp=<port:target_port> --dry-run=client -o yaml > <file_name>.yaml`: Generate Service YAML file.

- **Create ConfigMap and Secrets**
  - `kubectl create configmap <configmap_name> --from-literal=<key>=<value>`: Create a ConfigMap from key-value pairs.
  - `kubectl create configmap <configmap_name> --from-file=<file_name>`: Create a ConfigMap from a file.
  - `kubectl create secret generic <secret_name> --from-literal=<key>=<value>`: Create a Secret from key-value pairs.
  - `kubectl create secret generic <secret_name> --from-file=<file_name>`: Create a Secret from a file.

## Monitoring Usage Commands
- **Node and Pod Usage**
  - `kubectl top node <node_name>`: Get CPU and memory usage of a node.
  - `kubectl top pods <pod_name>`: Get CPU and memory usage of a pod.

- **Deployment**
  - `kubectl get deployment <deployment_name>`: Get a deployment.
  - `kubectl get deployment -o yaml`: Get deployment details in YAML format.
  - `kubectl get deployment -o wide`: Get detailed deployment information.
  - `kubectl describe deployment <deployment_name>`: Describe a deployment.
  - `kubectl scale deployment <deployment_name> --replicas=<replicas>`: Scale a deployment with specified replicas.

## Service Commands
- **Get and Manage Services**
  - `kubectl get service <service_name>`: Get details of a service.
  - `kubectl get service <service_name> -o yaml`: Get service details in YAML format.
  - `kubectl get service <service_name> -o wide`: Get detailed service information.
  - `kubectl describe service <service_name>`: Describe a service.
  - `kubectl edit service <service_name>`: Edit a service configuration.
  - `kubectl delete service <service_name>`: Delete a service.

## Ingress Commands
- **Get and Manage Ingress**
  - `kubectl get ingress`: Get ingress details.
  - `kubectl get ingress -o yaml`: Get ingress in YAML format.
  - `kubectl get ingress -o wide`: Get detailed ingress information.
  - `kubectl describe ingress <ingress_name>`: Describe an ingress.
  - `kubectl edit ingress <ingress_name>`: Edit an ingress.
  - `kubectl delete ingress <ingress_name>`: Delete an ingress.

## DaemonSet Commands
- **DaemonSet Management**
  - `kubectl get daemonset <daemonset_name>`: Get DaemonSet details.
  - `kubectl get daemonset <daemonset_name> -o yaml`: Get DaemonSet in YAML format.
  - `kubectl describe daemonset <daemonset_name>`: Describe a DaemonSet.
  - `kubectl edit daemonset <daemonset_name>`: Edit a DaemonSet.
  - `kubectl delete daemonset <daemonset_name>`: Delete a DaemonSet.

## Job Commands
- **Job Management**
  - `kubectl get job <job_name>`: Get job details.
  - `kubectl get job <job_name> -o yaml`: Get job in YAML format.
  - `kubectl describe job <job_name>`: Describe a job.
  - `kubectl edit job <job_name>`: Edit a job.
  - `kubectl delete job <job_name>`: Delete a job.

## Rollout Commands
- **Rollout Management**
  - `kubectl rollout restart deployment <deployment_name>`: Restart a deployment.
  - `kubectl rollout undo deployment <deployment_name>`: Undo the latest deployment revision.
  - `kubectl rollout undo deployment <deployment_name> --to-revision=<revision_number>`: Undo to a specified revision.
  - `kubectl rollout history deployment <deployment_name>`: View all revisions of a deployment.
  - `kubectl rollout history deployment <deployment_name> --revision=<revision_number>`: View a specific revision.

## Secret Commands
- **Secret Management**
  - `kubectl get secret <secret_name>`: Get secret details.
  - `kubectl describe secret <secret_name>`: Describe a secret.
  - `kubectl delete secret <secret_name>`: Delete a secret.
  - `kubectl edit secret <secret_name>`: Edit a secret.

---