import Link from "next/link";

export default function Home() {
  return (
    <main style={{ padding: "2rem", fontFamily: "sans-serif" }}>
      <div style={{ maxWidth: "800px", margin: "0 auto" }}>
        <h1>Welcome to LearnLynk</h1>
        <p>A task management system for leads and applications.</p>

        <section style={{ marginTop: "2rem" }}>
          <h2>Available Pages:</h2>
          <ul style={{ fontSize: "1.1rem", lineHeight: "1.8" }}>
            <li>
              <Link href="/dashboard/today" style={{ color: "#0070f3", textDecoration: "none" }}>
                📋 Today's Tasks Dashboard
              </Link>
              <p style={{ fontSize: "0.9rem", color: "#666", marginTop: "0.5rem" }}>
                View and manage tasks due today
              </p>
            </li>
          </ul>
        </section>

        <section style={{ marginTop: "3rem", padding: "1.5rem", backgroundColor: "#f5f5f5", borderRadius: "8px" }}>
          <h2>Getting Started:</h2>
          <ol style={{ lineHeight: "1.8" }}>
            <li>Configure your Supabase project credentials in <code>.env.local</code></li>
            <li>Navigate to the Dashboard to view and manage tasks</li>
            <li>Use the "Mark Complete" button to update task status</li>
          </ol>
        </section>

        <section style={{ marginTop: "3rem", padding: "1.5rem", backgroundColor: "#e3f2fd", borderRadius: "8px" }}>
          <h2>API Endpoints:</h2>
          <ul style={{ lineHeight: "1.8" }}>
            <li>
              <strong>Create Task:</strong> <code>POST /functions/v1/create-task</code>
            </li>
            <li style={{ marginTop: "0.5rem" }}>
              Expected payload:
              <pre style={{ backgroundColor: "#fff", padding: "1rem", borderRadius: "4px", overflow: "auto" }}>
{`{
  "application_id": "uuid",
  "task_type": "call|email|review",
  "due_at": "2025-12-20T12:00:00Z"
}`}
              </pre>
            </li>
          </ul>
        </section>

        <section style={{ marginTop: "3rem", color: "#666" }}>
          <p>
            <strong>Project:</strong> LearnLynk Tech Test
          </p>
          <p>
            <strong>Stack:</strong> Next.js + TypeScript + Supabase
          </p>
        </section>
      </div>
    </main>
  );
}
