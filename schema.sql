-- ============================================================
-- Beauty Boutique By Tandra — Database Schema
-- Run this file first, in the Supabase SQL Editor (SQL Editor -> New query -> paste -> Run)
-- ============================================================

create extension if not exists pgcrypto;

-- ---------- Categories (self-referencing for subcategories) ----------
create table if not exists categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  parent_id uuid references categories(id) on delete cascade,
  image_url text,
  display_order int not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

-- ---------- Brands ----------
create table if not exists brands (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  logo_url text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

-- ---------- Products ----------
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  brand_id uuid references brands(id) on delete set null,
  category_id uuid references categories(id) on delete set null,
  sku text,
  short_description text,
  description text,
  regular_price numeric(10,2) not null default 0,
  sale_price numeric(10,2),
  stock int not null default 0,
  has_variants boolean not null default false,
  variant_type text check (variant_type in ('shade', 'size') or variant_type is null),
  images jsonb not null default '[]'::jsonb,
  ingredients text,
  benefits text,
  how_to_use text,
  skin_types text[] not null default '{}',
  skin_concerns text[] not null default '{}',
  country_of_origin text,
  batch_info text,
  featured boolean not null default false,
  best_seller boolean not null default false,
  new_arrival boolean not null default false,
  active boolean not null default true,
  seo_title text,
  seo_description text,
  rating numeric(2,1) not null default 0,
  review_count int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_products_category on products(category_id);
create index if not exists idx_products_brand on products(brand_id);
create index if not exists idx_products_active on products(active);

-- ---------- Product Variants (shades / sizes) ----------
create table if not exists product_variants (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references products(id) on delete cascade,
  label text not null,
  hex_color text,
  sku text,
  price numeric(10,2),
  stock int not null default 0,
  image_url text,
  display_order int not null default 0
);

create index if not exists idx_variants_product on product_variants(product_id);

-- ---------- Delivery Zones ----------
create table if not exists delivery_zones (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  charge numeric(10,2) not null default 0,
  active boolean not null default true,
  display_order int not null default 0
);

-- ---------- Coupons ----------
create table if not exists coupons (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  type text not null check (type in ('percentage', 'fixed')),
  value numeric(10,2) not null,
  min_order numeric(10,2) not null default 0,
  max_discount numeric(10,2),
  start_date date,
  expiry_date date,
  usage_limit int,
  used_count int not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

-- ---------- Homepage Banners ----------
create table if not exists banners (
  id uuid primary key default gen_random_uuid(),
  kind text not null check (kind in ('hero', 'promo')),
  title text,
  subtitle text,
  image_url text,
  button_text text,
  button_link text,
  display_order int not null default 0,
  active boolean not null default true
);

-- ---------- Customers (built up automatically from orders) ----------
create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text unique not null,
  email text,
  addresses jsonb not null default '[]'::jsonb,
  total_orders int not null default 0,
  total_spent numeric(10,2) not null default 0,
  last_order_at timestamptz,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

-- ---------- Orders ----------
create table if not exists orders (
  id uuid primary key default gen_random_uuid(),
  order_number text unique not null,
  customer_name text not null,
  customer_phone text not null,
  customer_email text,
  division text,
  district text,
  area text,
  full_address text,
  delivery_zone_id uuid references delivery_zones(id),
  delivery_zone_name text,
  delivery_charge numeric(10,2) not null default 0,
  subtotal numeric(10,2) not null default 0,
  discount numeric(10,2) not null default 0,
  coupon_code text,
  total numeric(10,2) not null default 0,
  payment_method text not null check (payment_method in ('cod', 'bkash', 'nagad', 'bank_transfer')),
  payment_number text,
  transaction_id text,
  payment_status text not null default 'pending' check (payment_status in ('pending', 'verified', 'paid')),
  status text not null default 'pending' check (status in ('pending','confirmed','processing','shipped','out_for_delivery','delivered','cancelled','returned')),
  courier text,
  tracking_number text,
  status_history jsonb not null default '[]'::jsonb,
  admin_note text,
  created_at timestamptz not null default now()
);

create index if not exists idx_orders_phone on orders(customer_phone);
create index if not exists idx_orders_status on orders(status);
create index if not exists idx_orders_created on orders(created_at desc);

-- ---------- Order Items ----------
create table if not exists order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references orders(id) on delete cascade,
  product_id uuid references products(id) on delete set null,
  variant_id uuid references product_variants(id) on delete set null,
  product_name text not null,
  variant_label text,
  price numeric(10,2) not null,
  quantity int not null,
  image_url text
);

create index if not exists idx_order_items_order on order_items(order_id);

-- ---------- Reviews ----------
create table if not exists reviews (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references products(id) on delete cascade,
  customer_name text not null,
  rating int not null check (rating between 1 and 5),
  comment text,
  status text not null default 'pending' check (status in ('pending', 'approved', 'hidden')),
  featured boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists idx_reviews_product on reviews(product_id);

-- ---------- Site Settings (single row) ----------
create table if not exists site_settings (
  id int primary key default 1,
  bkash_number text default '',
  nagad_number text default '',
  bank_details text default '',
  payment_cod_enabled boolean not null default true,
  payment_bkash_enabled boolean not null default true,
  payment_nagad_enabled boolean not null default true,
  payment_bank_enabled boolean not null default false,
  site_facebook text default '',
  site_phone text default '',
  site_email text default '',
  site_address text default '',
  constraint single_row check (id = 1)
);

insert into site_settings (id) values (1) on conflict (id) do nothing;

-- ---------- Admins (which auth.users are allowed into /admin) ----------
create table if not exists admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  name text,
  created_at timestamptz not null default now()
);
