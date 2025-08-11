import { useState } from "react";

export default function App() {
  const [payload, setPayload] = useState('{"msg":"hello"}');
  const [taskId, setTaskId] = useState("");
  const [status, setStatus] = useState(null);
  const api = import.meta.env.VITE_API_URL || "http://localhost:8080";

  const enqueue = async () => {
    const r = await fetch(`${api}/webhook`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: payload,
    });
    const j = await r.json();
    setTaskId(j.task_id);
  };

  const check = async () => {
    if (!taskId) return;
    const r = await fetch(`${api}/status/${taskId}`);
    const j = await r.json();
    setStatus(j);
  };

  return (
    <div style={{ padding: 20, fontFamily: "sans-serif" }}>
      <h2>Webhook demo</h2>
      <textarea
        rows={6}
        cols={60}
        value={payload}
        onChange={(e) => setPayload(e.target.value)}
      />
      <div>
        <button onClick={enqueue}>Send webhook</button>
        <button onClick={check} disabled={!taskId}>
          Check status
        </button>
      </div>
      <div>taskId: {taskId}</div>
      <pre>{status ? JSON.stringify(status, null, 2) : ""}</pre>
    </div>
  );
}
