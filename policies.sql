-- ============================================================
-- Beauty Boutique By Tandra — Security (RLS policies + functions)
-- Run this SECOND, after schema.sql.
-- ============================================================

-- ---------- Turn on Row Level Security everywhere ----------
alter table categories enable row level security;
alter table brands enable row level security;
alter table products enable row level security;
alter table product_variants enable row level security;
alter table delivery_zones enable row level security;
alter table coupons enable row level security;
alter table banners enable row level security;
alter table customers enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;
alter table reviews enable row level security;
alter table site_settings enable row level security;
alter table admins enable row level security;

-- ---------- Helper: is the current logged-in user an admin? ----------
create or replace function is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (select 1 from admins where user_id = auth.uid());
$$;

grant execute on function is_admin() to anon, authenticated;

-- No public policies on "admins" itself — it's only ever read through is_admin().

-- ---------- Categories ----------
create policy "Public can view active categories" on categories
  for select using (active = true or is_admin());
create policy "Admins manage categories" on categories
  for all to authenticated using (is_admin()) with check (is_admin());

-- ---------- Brands ----------
create policy "Public can view active brands" on brands
  for select using (active = true or is_admin());
create policy "Admins manage brands" on brands
  for all to authenticated using (is_admin()) with check (is_admin());

-- ---------- Products ----------
create policy "Public can view active products" on products
  for select using (active = true or is_admin());
create policy "Admins manage products" on products
  for all to authenticated using (is_admin()) with check (is_admin());

-- ---------- Product Variants ----------
create policy "Public can view variants" on product_variants
  for select using (true);
create policy "Admins manage variants" on product_variants
  for all to authenticated using (is_admin()) with check (is_admin());

-- ---------- Delivery Zones ----------
create policy "Public can view active delivery zones" on delivery_zones
  for select using (active = true or is_admin());
create policy "Admins manage delivery zones" on delivery_zones
  for all to authenticated using (is_admin()) with check (is_admin());

-- ---------- Coupons ----------
-- Deliberately NOT publicly selectable (so the whole codes list can't be scraped).
-- Customers validate a code through the validate_coupon() function below.
create policy "Admins manage coupons" on coupons
  for all to authenticated using (is_admin()) with check (is_admin());

-- ---------- Banners ----------
create policy "Public can view active banners" on banners
  for select using (active = true or is_admin());
create policy "Admins manage banners" on banners
  for all to authenticated using (is_admin()) with check (is_admin());

-- ---------- Customers ----------
-- Fully server-managed (see upsert_customer_on_order trigger below) — no public writes.
create policy "Admins view customers" on customers
  for select using (is_admin());
create policy "Admins update customers" on customers
  for update using (is_admin()) with check (is_admin());

-- ---------- Orders ----------
-- Guests can place orders (checkout does not require login), but cannot read
-- anyone's order back through the table directly — see track_order() below.
create policy "Anyone can place an order" on orders
  for insert with check (true);
create policy "Admins view orders" on orders
  for select using (is_admin());
create policy "Admins update orders" on orders
  for update using (is_admin()) with check (is_admin());
create policy "Admins delete orders" on orders
  for delete using (is_admin());

-- ---------- Order Items ----------
create policy "Anyone can add items to an order they just created" on order_items
  for insert with check (true);
create policy "Admins view order items" on order_items
  for select using (is_admin());
create policy "Admins manage order items" on order_items
  for all to authenticated using (is_admin()) with check (is_admin());

-- ---------- Reviews ----------
create policy "Public can view approved reviews" on reviews
  for select using (status = 'approved' or is_admin());
create policy "Anyone can submit a review for moderation" on reviews
  for insert with check (status = 'pending');
create policy "Admins moderate reviews" on reviews
  for update using (is_admin()) with check (is_admin());
create policy "Admins delete reviews" on reviews
  for delete using (is_admin());

-- ---------- Site Settings ----------
-- Public needs to read the bKash/Nagad numbers and contact info at checkout / in the footer.
create policy "Public can view settings" on site_settings
  for select using (true);
create policy "Admins update settings" on site_settings
  for update using (is_admin()) with check (is_admin());

-- ============================================================
-- Server-side automation (runs with elevated rights, bypassing
-- the restrictive policies above where the app itself needs to)
-- ============================================================

-- Keep the customers table in sync whenever an order comes in.
create or replace function upsert_customer_on_order()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into customers (name, phone, email, total_orders, total_spent, last_order_at)
  values (new.customer_name, new.customer_phone, new.customer_email, 1, new.total, new.created_at)
  on conflict (phone) do update
    set total_orders = customers.total_orders + 1,
        total_spent = customers.total_spent + new.total,
        last_order_at = new.created_at,
        name = excluded.name,
        email = coalesce(excluded.email, customers.email);
  return new;
end;
$$;

drop trigger if exists trg_upsert_customer on orders;
create trigger trg_upsert_customer
  after insert on orders
  for each row execute function upsert_customer_on_order();

-- Track coupon redemptions.
create or replace function increment_coupon_usage()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.coupon_code is not null then
    update coupons set used_count = used_count + 1 where lower(code) = lower(new.coupon_code);
  end if;
  return new;
end;
$$;

drop trigger if exists trg_increment_coupon on orders;
create trigger trg_increment_coupon
  after insert on orders
  for each row execute function increment_coupon_usage();

-- Reduce stock the moment an order line is created.
create or replace function decrement_stock_on_order_item()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.variant_id is not null then
    update product_variants set stock = greatest(stock - new.quantity, 0) where id = new.variant_id;
  else
    update products set stock = greatest(stock - new.quantity, 0) where id = new.product_id;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_decrement_stock on order_items;
create trigger trg_decrement_stock
  after insert on order_items
  for each row execute function decrement_stock_on_order_item();

-- Put stock back if an order is later cancelled or returned.
create or replace function restore_stock_on_cancel()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status in ('cancelled', 'returned') and old.status not in ('cancelled', 'returned') then
    update product_variants pv set stock = pv.stock + oi.quantity
      from order_items oi where oi.order_id = new.id and oi.variant_id = pv.id;
    update products p set stock = p.stock + oi.quantity
      from order_items oi where oi.order_id = new.id and oi.variant_id is null and oi.product_id = p.id;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_restore_stock on orders;
create trigger trg_restore_stock
  after update on orders
  for each row execute function restore_stock_on_cancel();

-- Recalculate a product's star rating whenever its reviews change.
create or replace function refresh_product_rating()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update products p set
    rating = coalesce((select round(avg(rating)::numeric, 1) from reviews where product_id = p.id and status = 'approved'), 0),
    review_count = (select count(*) from reviews where product_id = p.id and status = 'approved')
  where p.id = coalesce(new.product_id, old.product_id);
  return coalesce(new, old);
end;
$$;

drop trigger if exists trg_refresh_rating on reviews;
create trigger trg_refresh_rating
  after insert or update or delete on reviews
  for each row execute function refresh_product_rating();

-- ============================================================
-- Public RPC functions (called from the app via supabase.rpc(...))
-- ============================================================

-- Validate a coupon without exposing the whole coupons table.
create or replace function validate_coupon(p_code text, p_subtotal numeric)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  c coupons%rowtype;
  discount numeric := 0;
begin
  select * into c from coupons where lower(code) = lower(p_code) and active = true;

  if not found then
    return jsonb_build_object('valid', false, 'message', 'That coupon code was not found.');
  end if;
  if c.start_date is not null and current_date < c.start_date then
    return jsonb_build_object('valid', false, 'message', 'This coupon is not active yet.');
  end if;
  if c.expiry_date is not null and current_date > c.expiry_date then
    return jsonb_build_object('valid', false, 'message', 'This coupon has expired.');
  end if;
  if c.usage_limit is not null and c.used_count >= c.usage_limit then
    return jsonb_build_object('valid', false, 'message', 'This coupon has reached its usage limit.');
  end if;
  if p_subtotal < c.min_order then
    return jsonb_build_object('valid', false, 'message', format('This coupon needs a minimum order of Tk %s.', c.min_order));
  end if;

  if c.type = 'percentage' then
    discount := round(p_subtotal * c.value / 100, 2);
    if c.max_discount is not null and discount > c.max_discount then
      discount := c.max_discount;
    end if;
  else
    discount := c.value;
  end if;

  if discount > p_subtotal then
    discount := p_subtotal;
  end if;

  return jsonb_build_object('valid', true, 'discount', discount, 'code', c.code, 'message', 'Coupon applied.');
end;
$$;

grant execute on function validate_coupon(text, numeric) to anon, authenticated;

-- Look up a single order for the "Track Order" page (order number + phone required).
create or replace function track_order(p_order_number text, p_phone text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  o orders%rowtype;
  items jsonb;
begin
  select * into o from orders where order_number = p_order_number and customer_phone = p_phone;

  if not found then
    return jsonb_build_object('found', false);
  end if;

  select coalesce(jsonb_agg(jsonb_build_object(
    'product_name', oi.product_name, 'variant_label', oi.variant_label,
    'price', oi.price, 'quantity', oi.quantity, 'image_url', oi.image_url
  )), '[]'::jsonb) into items from order_items oi where oi.order_id = o.id;

  return jsonb_build_object(
    'found', true, 'order_number', o.order_number, 'status', o.status,
    'payment_status', o.payment_status, 'payment_method', o.payment_method,
    'created_at', o.created_at, 'total', o.total, 'subtotal', o.subtotal,
    'discount', o.discount, 'delivery_charge', o.delivery_charge,
    'full_address', o.full_address, 'division', o.division, 'district', o.district,
    'area', o.area, 'courier', o.courier, 'tracking_number', o.tracking_number,
    'status_history', o.status_history, 'items', items
  );
end;
$$;

grant execute on function track_order(text, text) to anon, authenticated;

-- Look up all past orders for a phone number (used by the guest "My Account" page).
create or replace function get_customer_orders(p_phone text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
begin
  return (
    select coalesce(jsonb_agg(jsonb_build_object(
      'order_number', o.order_number, 'status', o.status, 'payment_status', o.payment_status,
      'total', o.total, 'created_at', o.created_at,
      'items', (
        select coalesce(jsonb_agg(jsonb_build_object(
          'product_name', oi.product_name, 'variant_label', oi.variant_label,
          'quantity', oi.quantity, 'price', oi.price, 'image_url', oi.image_url
        )), '[]'::jsonb)
        from order_items oi where oi.order_id = o.id
      )
    ) order by o.created_at desc), '[]'::jsonb)
    from orders o where o.customer_phone = p_phone
  );
end;
$$;

grant execute on function get_customer_orders(text) to anon, authenticated;
