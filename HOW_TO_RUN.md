# How to Start All Services

## Prerequisites
- Node.js 18+ installed
- Supabase account and project
- Supabase CLI installed (`npx supabase --version` works)

## 1) Environment Variables
Create `frontend/.env.local` with your Supabase project values (Supabase Dashboard → Settings → API):
```
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

## 2) Install Dependencies
From the project root:
```powershell
cd "c:\Users\Hp\Desktop\Web dev\Major Project\learnlynk\learnlynk-tech-test"
cd frontend
npm install
```

## 3) Run the Frontend (Next.js)
```powershell
cd "c:\Users\Hp\Desktop\Web dev\Major Project\learnlynk\learnlynk-tech-test\frontend"
npm run dev
```
- App will be at: http://localhost:3000
- Dashboard: http://localhost:3000/dashboard/today

## 4) Set Up Database (Supabase)
Run these SQL files in Supabase SQL editor (or `npx supabase db execute`):
1. `backend/schema.sql`
2. `backend/rls_policies.sql`

## 5) Edge Function: create-task
- Ensure you’re logged in and linked:
```powershell
cd "c:\Users\Hp\Desktop\Web dev\Major Project\learnlynk\learnlynk-tech-test"
npx supabase login
npx supabase link --project-ref YOUR_PROJECT_REF
```
- Deploy the function:
```powershell
npx supabase functions deploy create-task --project-ref YOUR_PROJECT_REF
```
- Set environment variables in Supabase Dashboard → Project Settings → Functions → Environment:
  - `SUPABASE_URL`
  - `SUPABASE_SERVICE_ROLE_KEY`

## 6) Test the Edge Function
```bash
curl -X POST https://YOUR_PROJECT_REF.supabase.co/functions/v1/create-task \
  -H "Authorization: Bearer YOUR_SERVICE_ROLE_KEY" \
  -H "Content-Type": "application/json" \
  -d '{
    "application_id": "550e8400-e29b-41d4-a716-446655440000",
    "task_type": "call",
    "due_at": "2025-12-20T12:00:00Z"
  }'
```

## 7) Common Issues
- **Port 3000 in use:** Stop existing process (Task Manager) or run `npm run dev -- -p 3001`.
- **Missing env vars:** Ensure `.env.local` exists and values are correct.
- **RLS blocking data:** Confirm you ran `rls_policies.sql` and your JWT/keys match tenant.

## 8) Stopping Services
- Frontend: Ctrl+C in the terminal running `npm run dev`.
- Edge Function: Serverless—no local process to stop.
