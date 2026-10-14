# Hilo — páginas de enlaces con cuentas y fotos

Web estática (un solo `index.html`) pensada para GitHub Pages. Las cuentas, los perfiles y las fotos se guardan en [Supabase](https://supabase.com) (plan gratuito), porque GitHub Pages por sí solo no tiene servidor.

## Puesta en marcha

1. **Supabase**: crea un proyecto nuevo.
2. **Base de datos**: en *SQL Editor*, pega y ejecuta `supabase-setup.sql`.
3. **Claves**: en *Project Settings → API* copia la *Project URL* y la clave *anon public*, y pégalas en `CONFIG` al principio del `<script>` de `index.html`.
4. **Redirecciones**: en *Authentication → URL Configuration* pon como *Site URL* la dirección de tu GitHub Pages (por ejemplo `https://usuario.github.io/repositorio/`) y añádela también a *Redirect URLs*.
5. **Correo (opcional)**: en *Authentication → Providers → Email* puedes desactivar *Confirm email* si quieres que la gente entre sin confirmar el correo.
6. **GitHub Pages**: sube `index.html` a tu repositorio y activa *Settings → Pages → Deploy from a branch → main / (root)*.

## Rutas

| Ruta | Qué muestra |
| --- | --- |
| `#/` | Inicio con demo |
| `#/crear`, `#/entrar` | Registro y acceso |
| `#/editor` | Editor con vista previa en vivo |
| `#/u/nombre` | Página pública de cada usuario |

## Notas

- La clave `anon` es pública por diseño; la seguridad la dan las políticas RLS del archivo SQL (cada persona solo puede editar su perfil y su carpeta de fotos).
- Las fotos se reducen y se convierten a WebP en el navegador antes de subirse (máx. 24 en la galería).
- Las fotos que quitas del editor se borran de Supabase al guardar.
