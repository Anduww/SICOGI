-- =========================================================
-- SICOGI — Modelo de datos para Supabase (PostgreSQL)
-- Ejecutar en: Supabase > SQL Editor > New query
-- =========================================================

-- 1. Tabla de categorías
create table categorias (
  id           serial primary key,
  nombre       text not null,
  slug         text not null unique
);

-- 2. Tabla de productos
create table productos (
  id            serial primary key,
  categoria_id  integer references categorias(id) on delete set null,
  nombre        text not null,
  descripcion   text,
  precio        numeric(12,2) not null,
  precio_anterior numeric(12,2),
  emoji         text,
  badge         text,               -- 'new' | 'sale' | 'hot' | null
  estrellas     integer default 5 check (estrellas between 0 and 5),
  creado_en     timestamptz default now()
);

-- 3. Tabla de pedidos (encabezado)
create table pedidos (
  id            uuid primary key default gen_random_uuid(),
  usuario_id    uuid references auth.users(id) not null,
  total         numeric(12,2) not null,
  estado        text default 'procesado',
  creado_en     timestamptz default now()
);

-- 4. Tabla de detalle de pedido (relación N:M entre pedidos y productos)
create table pedido_items (
  id               serial primary key,
  pedido_id        uuid references pedidos(id) on delete cascade,
  producto_id      integer references productos(id),
  cantidad         integer not null check (cantidad > 0),
  precio_unitario  numeric(12,2) not null
);

-- =========================================================
-- Seguridad: Row Level Security (RLS)
-- =========================================================

-- Productos y categorías: lectura pública, sin login
alter table categorias enable row level security;
alter table productos enable row level security;

create policy "Categorías visibles para todos"
  on categorias for select using (true);

create policy "Productos visibles para todos"
  on productos for select using (true);

-- Pedidos y pedido_items: cada usuario solo ve/crea los suyos
alter table pedidos enable row level security;
alter table pedido_items enable row level security;

create policy "Usuario ve solo sus pedidos"
  on pedidos for select using (auth.uid() = usuario_id);

create policy "Usuario crea sus propios pedidos"
  on pedidos for insert with check (auth.uid() = usuario_id);

create policy "Usuario ve items de sus pedidos"
  on pedido_items for select using (
    exists (select 1 from pedidos p where p.id = pedido_id and p.usuario_id = auth.uid())
  );

create policy "Usuario crea items de sus pedidos"
  on pedido_items for insert with check (
    exists (select 1 from pedidos p where p.id = pedido_id and p.usuario_id = auth.uid())
  );

-- =========================================================
-- Datos de prueba (los mismos productos que ya tenías en JS)
-- =========================================================

insert into categorias (nombre, slug) values
  ('Tecnología','tecnologia'),
  ('Moda','moda'),
  ('Hogar','hogar'),
  ('Deportes','deportes'),
  ('Belleza','belleza');

insert into productos (categoria_id, nombre, descripcion, precio, precio_anterior, emoji, badge, estrellas) values
((select id from categorias where slug='tecnologia'),'AirPods Pro','Cancelación de ruido activa con sonido envolvente.',299900,349900,'🎧','sale',5),
((select id from categorias where slug='tecnologia'),'Smartwatch Elite','Monitor de salud completo con GPS integrado.',459000,null,'⌚','new',5),
((select id from categorias where slug='tecnologia'),'Laptop UltraBook','Rendimiento profesional en un diseño ultradelgado.',2890000,3200000,'💻','sale',4),
((select id from categorias where slug='moda'),'Chaqueta Clásica','Corte italiano con tela premium importada.',189000,null,'🧥','new',5),
((select id from categorias where slug='moda'),'Sneakers Pro','Diseño exclusivo con suela de alta tecnología.',320000,380000,'👟','sale',4),
((select id from categorias where slug='moda'),'Bolso de Cuero','Cuero genuino artesanal con herrajes dorados.',245000,null,'👜','hot',5),
((select id from categorias where slug='hogar'),'Cafetera Barista','Espresso perfecto desde la comodidad de tu hogar.',520000,null,'☕','hot',5),
((select id from categorias where slug='hogar'),'Lámpara Minimal','Diseño nórdico con luz LED regulable.',145000,null,'💡','new',4),
((select id from categorias where slug='hogar'),'Set de Cuchillos','Acero alemán de alta precisión para chef profesional.',310000,null,'🔪',null,4),
((select id from categorias where slug='deportes'),'Bicicleta Carbono','Fibra de carbono ultraligero para máximo rendimiento.',3450000,null,'🚴','hot',5),
((select id from categorias where slug='deportes'),'Pesas Ajustables','De 2kg a 24kg en segundos, diseño compacto.',380000,420000,'🏋️','sale',4),
((select id from categorias where slug='belleza'),'Skincare Premium','Suero anti-edad con retinol y vitamina C.',195000,null,'✨','new',5),
((select id from categorias where slug='belleza'),'Perfume Élite','Fragancia exclusiva con notas de jazmín y oud.',280000,null,'🌸','hot',5),
((select id from categorias where slug='tecnologia'),'Tablet Pro 12"','Pantalla OLED 120Hz ideal para creativos y estudio.',1250000,null,'📱','new',5),
((select id from categorias where slug='hogar'),'Silla Ergonómica','Soporte lumbar adaptativo para largas jornadas.',890000,1050000,'🪑','sale',4),
((select id from categorias where slug='deportes'),'Zapatillas Running','Amortiguación reactiva para entrenamiento de alto impacto.',260000,null,'👟',null,4);
