-- Run in Supabase SQL Editor. Enable RLS on every exposed table.
create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
create table if not exists public.daily_updates (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  category text not null default 'Daily log',
  earned_amount numeric(12,2) not null default 0 check (earned_amount >= 0),
  views integer not null default 0 check (views >= 0),
  published boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.income_entries (
  id uuid primary key default gen_random_uuid(),
  source text not null,
  amount numeric(12,2) not null check (amount >= 0),
  status text not null check (status in ('pending','approved','received')),
  entry_date date not null default current_date,
  note text,
  created_at timestamptz not null default now()
);
alter table public.admins enable row level security;
alter table public.daily_updates enable row level security;
alter table public.income_entries enable row level security;
create policy "admins can read own admin row" on public.admins for select to authenticated using (user_id = (select auth.uid()));
create policy "public reads published updates" on public.daily_updates for select to anon, authenticated using (published = true);
create policy "admins manage updates" on public.daily_updates for all to authenticated
  using (exists(select 1 from public.admins a where a.user_id = (select auth.uid())))
  with check (exists(select 1 from public.admins a where a.user_id = (select auth.uid())));
create policy "admins manage income" on public.income_entries for all to authenticated
  using (exists(select 1 from public.admins a where a.user_id = (select auth.uid())))
  with check (exists(select 1 from public.admins a where a.user_id = (select auth.uid())));
grant select on public.daily_updates to anon, authenticated;
grant all on public.daily_updates to authenticated;
grant all on public.income_entries to authenticated;
grant select on public.admins to authenticated;
-- After creating your account via the app, run this once as project owner:
-- insert into public.admins(user_id) select id from auth.users where email = 'YOUR_LOGIN_EMAIL';
