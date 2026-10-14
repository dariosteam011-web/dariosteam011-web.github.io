-- Ejecuta este archivo entero en Supabase: SQL Editor → New query → Run

-- 1) Tabla de perfiles (un perfil por cuenta)
create table if not exists public.profiles (
  id           uuid primary key references auth.users(id) on delete cascade,
  username     text unique not null check (username ~ '^[a-z0-9_]{3,24}$'),
  display_name text not null default '',
  bio          text not null default '' check (char_length(bio) <= 160),
  avatar_url   text,
  theme        jsonb not null default '{}'::jsonb,
  links        jsonb not null default '[]'::jsonb,
  gallery      jsonb not null default '[]'::jsonb,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- Cualquiera puede ver los perfiles (son páginas públicas)
create policy "Perfiles visibles para todos"
  on public.profiles for select using (true);

-- Cada persona solo crea, edita y borra el suyo
create policy "Crear mi perfil"
  on public.profiles for insert to authenticated
  with check (auth.uid() = id);

create policy "Editar mi perfil"
  on public.profiles for update to authenticated
  using (auth.uid() = id) with check (auth.uid() = id);

create policy "Borrar mi perfil"
  on public.profiles for delete to authenticated
  using (auth.uid() = id);

-- 2) Almacenamiento de fotos (bucket público: las URLs se pueden ver sin iniciar sesión)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('media', 'media', true, 5242880, array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do nothing;

-- Cada persona solo sube, lista y borra dentro de su carpeta (<id-de-usuario>/...)
create policy "Ver mis archivos"
  on storage.objects for select to authenticated
  using (bucket_id = 'media' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "Subir a mi carpeta"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'media' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "Borrar de mi carpeta"
  on storage.objects for delete to authenticated
  using (bucket_id = 'media' and (storage.foldername(name))[1] = auth.uid()::text);
