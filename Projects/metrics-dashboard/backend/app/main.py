from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# CORS (adjust later if needed)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/")
def root():
    return {"message": "Backend is running!"}

@app.get("/servers")
def get_servers():
    return [
        {"id": 1, "name": "Server A", "status": "running"},
        {"id": 2, "name": "Server B", "status": "stopped"},
    ]

@app.get("/metrics")
def get_metrics():
    return {
        "cpu_usage": "42%",
        "memory_usage": "65%",
        "disk_usage": "73%"
    }

@app.get("/alerts")
def get_alerts():
    return [
        {"id": 1, "message": "High CPU usage on Server A", "level": "warning"},
        {"id": 2, "message": "Disk space low on Server B", "level": "critical"},
    ]
