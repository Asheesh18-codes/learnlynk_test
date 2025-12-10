-- LearnLynk Tech Test - Task 1: Schema
-- Fill in the definitions for leads, applications, tasks as per README.

create extension if not exists "pgcrypto";

-- Leads table
create table if not exists public.leads (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null,
  owner_id uuid not null,
  email text,
  phone text,
  full_name text,
  stage text not null default 'new',
  source text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Indexes for leads table
create index if not exists idx_leads_tenant_id on public.leads(tenant_id);
create index if not exists idx_leads_owner_id on public.leads(owner_id);
create index if not exists idx_leads_stage on public.leads(stage);
create index if not exists idx_leads_created_at on public.leads(created_at);
create index if not exists idx_leads_tenant_owner on public.leads(tenant_id, owner_id);


-- Applications table
create table if not exists public.applications (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null,
  lead_id uuid not null references public.leads(id) on delete cascade,
  program_id uuid,
  intake_id uuid,
  stage text not null default 'inquiry',
  status text not null default 'open',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Indexes for applications table
create index if not exists idx_applications_tenant_id on public.applications(tenant_id);
create index if not exists idx_applications_lead_id on public.applications(lead_id);
create index if not exists idx_applications_stage on public.applications(stage);
create index if not exists idx_applications_tenant_lead on public.applications(tenant_id, lead_id);


-- Tasks table
create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null,
  application_id uuid not null references public.applications(id) on delete cascade,
  title text,
  type text not null,
  status text not null default 'open',
  due_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  
  -- Check constraint for task type
  constraint tasks_type_check check (type in ('call', 'email', 'review')),
  
  -- Check constraint for due_at >= created_at
  constraint tasks_due_at_check check (due_at >= created_at)
);

-- Indexes for tasks table (optimized for queries to fetch tasks due today)
create index if not exists idx_tasks_tenant_id on public.tasks(tenant_id);
create index if not exists idx_tasks_due_at on public.tasks(due_at);
create index if not exists idx_tasks_status on public.tasks(status);
create index if not exists idx_tasks_application_id on public.tasks(application_id);
create index if not exists idx_tasks_tenant_due_status on public.tasks(tenant_id, due_at, status);
create index if not exists idx_tasks_due_status on public.tasks(due_at, status);


-- Teams table
create table if not exists public.teams (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null,
  name text not null,
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Indexes for teams table
create index if not exists idx_teams_tenant_id on public.teams(tenant_id);


-- User Teams junction table (many-to-many relationship)
create table if not exists public.user_teams (
  user_id uuid not null,
  team_id uuid not null references public.teams(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, team_id)
);

-- Indexes for user_teams table
create index if not exists idx_user_teams_user_id on public.user_teams(user_id);
create index if not exists idx_user_teams_team_id on public.user_teams(team_id);
