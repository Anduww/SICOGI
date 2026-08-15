# SICOGI

Proyecto final del Tecnólogo en Análisis y Desarrollo de Software (ADSO) — SENA.

**Aprendiz:** Wilmer Andrés Madroñero López
**Ficha:** [tu número de ficha]
**Instructor:** [nombre del instructor]

## 📌 Descripción

SICOGI es una tienda en línea (e-commerce) que permite a los usuarios registrarse, explorar un catálogo de productos por categorías, buscar, agregar productos al carrito y finalizar compras generando un pedido real en la base de datos.

## 🎯 Problema que resuelve

[Describe aquí, en 2-3 líneas, la necesidad u organización que dio origen al proyecto — lo mismo que pusiste en tu documento de requisitos.]

## 🛠️ Tecnologías utilizadas

- **Frontend:** HTML5, CSS3, JavaScript
- **Backend / Base de datos:** [Supabase](https://supabase.com) (PostgreSQL, autenticación, API REST autogenerada)
- **Pruebas de API:** Postman

## 📂 Archivos del proyecto

- `sicogi_conectado_supabase.html` — Página web principal (frontend)
- `sicogi_schema.sql` — Script de creación del modelo de datos en Supabase
- `SICOGI.postman_collection.json` — Colección de pruebas de la API

## ⚙️ Cómo ejecutar el proyecto

1. Clona el repositorio: `git clone [url-de-tu-repo]`
2. Abre `sicogi_conectado_supabase.html` en tu navegador (o despliégalo en tu hosting preferido).
3. El proyecto se conecta automáticamente al proyecto de Supabase configurado en el código.

## 🗄️ Base de datos

El modelo de datos incluye las tablas `categorias`, `productos`, `pedidos` y `pedido_items`, con seguridad a nivel de fila (RLS) para que cada usuario solo pueda ver y crear sus propios pedidos. El script completo está en [`sicogi_schema.sql`](./sicogi_schema.sql).

## 🧪 Pruebas de API

La colección de Postman en [`SICOGI.postman_collection.json`](./SICOGI.postman_collection.json) incluye pruebas de:
- Autenticación de usuarios
- Consulta de categorías y productos
- Creación de productos y pedidos
- Verificación de seguridad (un usuario no puede ver pedidos de otro)

## 👤 Autor

Wilmer Andrés Madroñero López —
