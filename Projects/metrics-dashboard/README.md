# CloudOps Dashboard

A web-based dashboard to monitor infrastructure, costs, and SSL health in real time.

## Features

-  Uptime Monitoring (Prometheus + Node Exporter or PRTG API)
-  Real-time Alerts (Microsoft Teams Webhook)
-  AWS/Azure Monthly Spend Summaries
-  SSL Certificate Expiration Alerts
-  VM Inventory (EC2 + Azure VM)
-  Cost Optimization Recommendations

## Tech Stack

| Layer      | Tech                         |
|------------|------------------------------|
| Frontend   | React + TailwindCSS          |
| Backend    | FastAPI or Node.js           |
| Monitoring | Prometheus + Grafana         |
| Cost Data  | AWS Cost Explorer + Azure API|
| Infra      | Terraform + GitHub Actions   |
| Auth (Bonus) | SSO (Google/Entra)         |

## Local Development

```bash
# Frontend
cd frontend
npm install
npm run dev

# Backend
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload
