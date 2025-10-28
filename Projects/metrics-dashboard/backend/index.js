import express from "express";
import cors from "cors";

const app = express();
const PORT = 4000;

app.use(cors());
app.use(express.json());

// --- Mock Servers & Alerts ---
const servers = [
  { id: 1, name: "Server A", status: "Running" },
  { id: 2, name: "Server B", status: "Running" },
  { id: 3, name: "Server C", status: "Stopped" },
];

const alerts = [
  { id: 1, message: "High CPU usage on Server A", severity: "high" },
  { id: 2, message: "Memory nearing capacity on Server C", severity: "medium" },
];

// --- Metrics Store ---
let metrics = [];

// Helper to generate a random metric
function generateMetric(type) {
  return {
    time: new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
    type,
    value: Math.floor(Math.random() * 80) + 20, // range 20–100
  };
}

// Seed with initial data (10 past minutes for cpu, memory, disk)
function seedMetrics() {
  const now = new Date();
  for (let i = 0; i < 10; i++) {
    const timestamp = new Date(now.getTime() - (10 - i) * 60000);
    metrics.push({
      time: timestamp.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
      type: "cpu",
      value: Math.floor(Math.random() * 80) + 20,
    });
    metrics.push({
      time: timestamp.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
      type: "memory",
      value: Math.floor(Math.random() * 80) + 20,
    });
    metrics.push({
      time: timestamp.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
      type: "disk",
      value: Math.floor(Math.random() * 80) + 20,
    });
  }
}
seedMetrics();

// Add new metrics every 30s
setInterval(() => {
  metrics.push(generateMetric("cpu"));
  metrics.push(generateMetric("memory"));
  metrics.push(generateMetric("disk"));

  // Keep last 60 entries (20 per type)
  if (metrics.length > 60) {
    metrics = metrics.slice(-60);
  }
}, 30000);

// --- Routes ---
app.get("/api/servers", (req, res) => {
  res.json(servers);
});

app.get("/api/alerts", (req, res) => {
  res.json(alerts);
});

app.get("/api/metrics", (req, res) => {
  res.json(metrics);
});

// --- Start Server ---
app.listen(PORT, () => {
  console.log(`Backend running on http://localhost:${PORT}`);
});
