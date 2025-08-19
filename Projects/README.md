# CloudOps Dashboard  
- A **full-stack monitoring dashboard** that visualizes server health, alerts, and key infrastructure metrics.  
- Built with **React, Node.js, Express, and Tailwind CSS**.  
---
## Features  
- Real-time **server status** (Running / Stopped)  
- **Critical & High severity alerts**  
- Interactive **CPU, Memory, and Disk usage charts** using Recharts  
- Clean, modern, and **responsive UI** for cloud ops teams  
---
## Tech Stack  
| Layer      | Tech                         |
|------------|------------------------------|
| Frontend   | React + TailwindCSS          |
| Backend    | FastAPI or Node.js           |
| Monitoring | Prometheus + Grafana         |
| Cost Data  | AWS Cost Explorer + Azure API|
| Infra      | Terraform + GitHub Actions   |
| Auth (Bonus) | SSO (Google/Entra)         |
---
## CloudOps Dashboard
<p align="center"><img width="825" height="1247" alt="image" src="https://github.com/user-attachments/assets/b92d6064-81b9-4c14-8eec-dd95f1792047" /></p>

## Setup & Installation
```bash

1. Clone the repository
git clone https://github.com/jsmith505/Portfolio.git  
cd Portfolio/Projects/CloudOps-Dashboard
2. Backend Setup
cd backend  
npm install  
npm start  
Starts the API at http://localhost:4000
3. Frontend Setup
cd frontend  
npm install  
npm run dev  
Runs the React app at http://localhost:5173  
Fetches data automatically from the backend   
```
---
## Future Enhancements
- Authentication & role-based access control (RBAC)  
- Live integration with Prometheus / Grafana / CloudWatch  
- Containerization with Docker & Kubernetes  
- Deployment pipeline using GitHub Actions → AWS (ECS / EKS / Amplify)  
---
**Endpoints:**
- /api/servers → List of servers & statuses  
- /api/alerts → Active alerts with severity  
- /api/metrics → CPU, Memory, Disk metrics
---
## Project Sturcture
metrics-dashboard/
│── docker-compose.yml 
│
│── backend/ 
│   ├── Dockerfile
│   ├── package.json
│   ├── server.js
│   ├── routes/
│   └── data/
│
│── frontend/
│   ├── Dockerfile
│   ├── package.json
│   ├── vite.config.js
│   └── src/
│       ├── App.tsx
│       ├── components/
│       └── pages/
│
│── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
│── README.md 
