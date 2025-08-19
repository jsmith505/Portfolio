# CloudOps Dashboard  

A **full-stack monitoring dashboard** that visualizes server health, alerts, and key infrastructure metrics.  
Built with **React, Node.js, Express, and Tailwind CSS**.  

---

## Features  
- Real-time **server status** (Running / Stopped)  
- **Critical & High severity alerts**  
- Interactive **CPU, Memory, and Disk usage charts** using Recharts  
- Clean, modern, and **responsive UI** for cloud ops teams  

---

## Tech Stack  
- **Frontend:** React, Tailwind CSS, Recharts  
- **Backend:** Node.js, Express  
- **Data Source:** Mock REST API (easily replaceable with Prometheus, CloudWatch, or other sources)  

---

## Setup & Installation  

### 1. Clone the repository  
```bash
git clone https://github.com/jsmith505/Portfolio.git
cd Portfolio/Projects/CloudOps-Dashboard
2. Backend Setup
cd backend
npm install
npm start
Starts the API at http://localhost:4000

Endpoints:

/api/servers → List of servers & statuses

/api/alerts → Active alerts with severity

/api/metrics → CPU, Memory, Disk metrics

3. Frontend Setup
cd frontend
npm install
npm run dev
Runs the React app at http://localhost:5173

Fetches data automatically from the backend

Screenshots
<img width="2234" height="1248" alt="image" src="https://github.com/user-attachments/assets/1a88c195-2cd9-4ff7-8945-b3c61e2a6a6b" />


Future Enhancements
Authentication & role-based access control (RBAC)

Live integration with Prometheus / Grafana / CloudWatch

Containerization with Docker & Kubernetes

Deployment pipeline using GitHub Actions → AWS (ECS / EKS / Amplify)

Project Structure
csharp
Copy
Edit
CloudOps-Dashboard/
│── backend/            # Node.js + Express mock API
│   ├── server.js
│   ├── routes/
│   └── data/
│
│── frontend/           # React + Tailwind UI
│   ├── src/
│   │   ├── App.tsx
│   │   ├── components/
│   │   └── pages/
│   └── public/
│
│── README.md           # Project documentation

