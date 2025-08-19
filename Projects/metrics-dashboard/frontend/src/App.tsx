import { useEffect, useState } from "react";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

export default function App() {
  const [servers, setServers] = useState<any[]>([]);
  const [alerts, setAlerts] = useState<any[]>([]);
  const [metrics, setMetrics] = useState<any[]>([]);

  // Fetch data
  useEffect(() => {
    fetch("http://localhost:4000/api/servers")
      .then((res) => res.json())
      .then((data) => setServers(data));

    fetch("http://localhost:4000/api/alerts")
      .then((res) => res.json())
      .then((data) => setAlerts(data));

    fetch("http://localhost:4000/api/metrics")
      .then((res) => res.json())
      .then((data) => setMetrics(data));
  }, []);

  // Split metrics by type
  const cpuData = metrics.filter((m) => m.type === "cpu");
  const memoryData = metrics.filter((m) => m.type === "memory");
  const diskData = metrics.filter((m) => m.type === "disk");

  return (
    <div className="min-h-screen bg-gray-900 text-gray-100 p-6">
      <h1 className="text-3xl font-bold mb-8 text-center text-blue-400">
        CloudOps Dashboard
      </h1>

{/* Alerts */}
<section className="mb-16 text-center">
  <h2 className="text-2xl font-semibold mb-6">Alerts</h2>
  <ul className="space-y-4 max-w-2xl mx-auto text-left">
    {alerts.map((alert) => (
      <li
        key={alert.id}
        className={`p-4 rounded-xl shadow flex items-center justify-between ${
          alert.severity === "high"
            ? "bg-red-200 text-red-900"
            : "bg-yellow-200 text-yellow-900"
        }`}
      >
        <span className="font-bold text-sm whitespace-nowrap">
          {alert.severity === "high"
            ? "Critical Severity:"
            : "High Severity:"}     
        </span>
        <span className="ml-5">{alert.message}</span>
      </li>
    ))}
  </ul>
</section>


{/* Servers */}
<section className="mb-16 text-center">
  <h2 className="text-2xl font-semibold mb-6">Servers</h2>
  <div className="flex justify-center">
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      {servers.map((server) => (
        <div
          key={server.name}
          className="bg-gray-800 shadow rounded-xl px-6 py-4 text-lg font-medium w-72"
        >
          <div className="flex items-center justify-between">
            {/* Server name */}
            <span className="text-left">{server.name}</span>

            {/* Separator with 5 spaces */}
            <span className="mx-2">:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>

            {/* Status */}
            <span
              className={`px-3 py-1 rounded text-sm font-semibold ${
                server.status === "Running"
                  ? "bg-green-200 text-green-900"
                  : "bg-red-200 text-red-900"
              }`}
            >
              {server.status}
            </span>
          </div>
        </div>
      ))}
    </div>
  </div>
</section>




      {/* Metrics Section */}
      <section>
        <h2 className="text-2xl font-semibold mb-6 text-center">Metrics</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {/* CPU */}
          <div className="bg-gray-800 p-4 shadow rounded-xl">
            <h3 className="text-lg font-medium mb-2">CPU Usage</h3>
            <ResponsiveContainer width="100%" height={200}>
              <LineChart data={cpuData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="time" />
                <YAxis />
                <Tooltip />
                <Line type="monotone" dataKey="value" stroke="#2563eb" />
              </LineChart>
            </ResponsiveContainer>
          </div>

          {/* Memory */}
          <div className="bg-gray-800 p-4 shadow rounded-xl">
            <h3 className="text-lg font-medium mb-2">Memory Usage</h3>
            <ResponsiveContainer width="100%" height={200}>
              <LineChart data={memoryData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="time" />
                <YAxis />
                <Tooltip />
                <Line type="monotone" dataKey="value" stroke="#16a34a" />
              </LineChart>
            </ResponsiveContainer>
          </div>

          {/* Disk */}
          <div className="bg-gray-800 p-4 shadow rounded-xl">
            <h3 className="text-lg font-medium mb-2">Disk Usage</h3>
            <ResponsiveContainer width="100%" height={200}>
              <LineChart data={diskData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="time" />
                <YAxis />
                <Tooltip />
                <Line type="monotone" dataKey="value" stroke="#dc2626" />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>
      </section>
    </div>
  );
}
