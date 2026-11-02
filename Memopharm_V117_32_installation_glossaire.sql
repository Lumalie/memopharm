-- À exécuter une seule fois dans Supabase > SQL Editor.
-- Les définitions sont publiques en lecture, modifiables seulement par les admins Mémopharm.
create table if not exists public.memo_glossary (
 id uuid primary key default gen_random_uuid(),
 term text not null check (char_length(term) between 1 and 120),
 definition text not null check (char_length(definition) between 1 and 4000),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create index if not exists memo_glossary_term_idx on public.memo_glossary (term);
alter table public.memo_glossary enable row level security;
grant select on public.memo_glossary to anon, authenticated;
grant insert, update, delete on public.memo_glossary to authenticated;
drop policy if exists memo_glossary_read on public.memo_glossary;
create policy memo_glossary_read on public.memo_glossary for select to anon, authenticated using (true);
drop policy if exists memo_glossary_insert on public.memo_glossary;
create policy memo_glossary_insert on public.memo_glossary for insert to authenticated with check (
 exists (select 1 from public.memopharm_admins a where a.user_id = (select auth.uid()))
);
drop policy if exists memo_glossary_update on public.memo_glossary;
create policy memo_glossary_update on public.memo_glossary for update to authenticated using (
 exists (select 1 from public.memopharm_admins a where a.user_id = (select auth.uid()))
) with check (
 exists (select 1 from public.memopharm_admins a where a.user_id = (select auth.uid()))
);
drop policy if exists memo_glossary_delete on public.memo_glossary;
create policy memo_glossary_delete on public.memo_glossary for delete to authenticated using (
 exists (select 1 from public.memopharm_admins a where a.user_id = (select auth.uid()))
);
