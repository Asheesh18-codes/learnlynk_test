-- LearnLynk Tech Test - Task 2: RLS Policies on leads

alter table public.leads enable row level security;

-- Helper function to extract JWT claims
-- JWT contains: user_id, role, tenant_id

-- SELECT policy: counselors see leads they own or leads assigned to their teams; admins see all leads in their tenant
create policy "leads_select_policy"
on public.leads
for select
using (
  -- Extract JWT claims: tenant_id, user_id, role
  (current_setting('request.jwt.claims', true)::jsonb->>'tenant_id')::uuid = tenant_id
  and
  (
    -- Admin can see all leads in their tenant
    (current_setting('request.jwt.claims', true)::jsonb->>'role') = 'admin'
    or
    -- Counselor can see leads they own OR leads assigned to their teams
    (
      (current_setting('request.jwt.claims', true)::jsonb->>'role') = 'counselor'
      and
      (
        -- Owns the lead
        owner_id = (current_setting('request.jwt.claims', true)::jsonb->>'user_id')::uuid
        or
        -- Lead is assigned to a user in one of their teams
        exists (
          select 1
          from public.user_teams ut
          where ut.user_id = (current_setting('request.jwt.claims', true)::jsonb->>'user_id')::uuid
          and leads.owner_id in (
            select another_user.user_id
            from public.user_teams another_user
            where another_user.team_id = ut.team_id
          )
        )
      )
    )
  )
);

-- INSERT policy: allows counselors and admins to insert leads for their tenant
create policy "leads_insert_policy"
on public.leads
for insert
with check (
  -- Ensure the user is from the same tenant
  (current_setting('request.jwt.claims', true)::jsonb->>'tenant_id')::uuid = tenant_id
  and
  -- Ensure user is either admin or counselor
  (
    (current_setting('request.jwt.claims', true)::jsonb->>'role') in ('admin', 'counselor')
  )
);
