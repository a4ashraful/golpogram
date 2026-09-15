-- ============================================================
-- Beauty Boutique By Tandra — Starter Catalog
-- Run this THIRD (optional but recommended), after schema.sql and policies.sql.
-- This gives you a working, realistic-looking store on day one. Everything
-- here is a placeholder — edit or delete every row from the Admin dashboard
-- once you're ready to list your real products.
-- Product "photos" use a small built-in illustration generator (no real
-- images are seeded) — upload real photos per product from the admin panel.
-- ============================================================

-- ---------- Delivery Zones ----------
insert into delivery_zones (id, name, charge, active, display_order) values
  ('d0000000-0000-0000-0000-000000000001', 'Inside Dhaka', 60, true, 1),
  ('d0000000-0000-0000-0000-000000000002', 'Outside Dhaka', 120, true, 2)
on conflict (id) do nothing;

-- ---------- Brands ----------
insert into brands (id, name, slug, active) values
  ('b0000000-0000-0000-0000-000000000001', 'Tandra''s Own', 'tandras-own', true),
  ('b0000000-0000-0000-0000-000000000002', 'GlowLab', 'glowlab', true),
  ('b0000000-0000-0000-0000-000000000003', 'Petal & Pearl', 'petal-pearl', true),
  ('b0000000-0000-0000-0000-000000000004', 'Nourish Naturals', 'nourish-naturals', true),
  ('b0000000-0000-0000-0000-000000000005', 'Velvet Touch', 'velvet-touch', true),
  ('b0000000-0000-0000-0000-000000000006', 'Dhaka Botanicals', 'dhaka-botanicals', true)
on conflict (id) do nothing;

-- ---------- Categories (top-level) ----------
insert into categories (id, name, slug, parent_id, display_order, active) values
  ('a0000000-0000-0000-0000-000000000001', 'Skincare', 'skincare', null, 1, true),
  ('a0000000-0000-0000-0000-000000000007', 'Makeup', 'makeup', null, 2, true),
  ('a0000000-0000-0000-0000-000000000014', 'Hair Care', 'hair-care', null, 3, true),
  ('a0000000-0000-0000-0000-000000000018', 'Body Care', 'body-care', null, 4, true),
  ('a0000000-0000-0000-0000-000000000021', 'Fragrance', 'fragrance', null, 5, true),
  ('a0000000-0000-0000-0000-000000000024', 'Accessories', 'accessories', null, 6, true)
on conflict (id) do nothing;

-- ---------- Categories (subcategories) ----------
insert into categories (id, name, slug, parent_id, display_order, active) values
  ('a0000000-0000-0000-0000-000000000002', 'Cleanser', 'cleanser', 'a0000000-0000-0000-0000-000000000001', 1, true),
  ('a0000000-0000-0000-0000-000000000003', 'Toner', 'toner', 'a0000000-0000-0000-0000-000000000001', 2, true),
  ('a0000000-0000-0000-0000-000000000004', 'Serum', 'serum', 'a0000000-0000-0000-0000-000000000001', 3, true),
  ('a0000000-0000-0000-0000-000000000005', 'Moisturizer', 'moisturizer', 'a0000000-0000-0000-0000-000000000001', 4, true),
  ('a0000000-0000-0000-0000-000000000006', 'Sunscreen', 'sunscreen', 'a0000000-0000-0000-0000-000000000001', 5, true),
  ('a0000000-0000-0000-0000-000000000008', 'Lipstick', 'lipstick', 'a0000000-0000-0000-0000-000000000007', 1, true),
  ('a0000000-0000-0000-0000-000000000009', 'Foundation', 'foundation', 'a0000000-0000-0000-0000-000000000007', 2, true),
  ('a0000000-0000-0000-0000-000000000010', 'Eyeshadow', 'eyeshadow', 'a0000000-0000-0000-0000-000000000007', 3, true),
  ('a0000000-0000-0000-0000-000000000011', 'Mascara', 'mascara', 'a0000000-0000-0000-0000-000000000007', 4, true),
  ('a0000000-0000-0000-0000-000000000012', 'Blush', 'blush', 'a0000000-0000-0000-0000-000000000007', 5, true),
  ('a0000000-0000-0000-0000-000000000013', 'Compact Powder', 'compact-powder', 'a0000000-0000-0000-0000-000000000007', 6, true),
  ('a0000000-0000-0000-0000-000000000015', 'Shampoo', 'shampoo', 'a0000000-0000-0000-0000-000000000014', 1, true),
  ('a0000000-0000-0000-0000-000000000016', 'Conditioner', 'conditioner', 'a0000000-0000-0000-0000-000000000014', 2, true),
  ('a0000000-0000-0000-0000-000000000017', 'Hair Oil', 'hair-oil', 'a0000000-0000-0000-0000-000000000014', 3, true),
  ('a0000000-0000-0000-0000-000000000019', 'Body Lotion', 'body-lotion', 'a0000000-0000-0000-0000-000000000018', 1, true),
  ('a0000000-0000-0000-0000-000000000020', 'Body Scrub', 'body-scrub', 'a0000000-0000-0000-0000-000000000018', 2, true),
  ('a0000000-0000-0000-0000-000000000022', 'Perfume', 'perfume', 'a0000000-0000-0000-0000-000000000021', 1, true),
  ('a0000000-0000-0000-0000-000000000023', 'Body Mist', 'body-mist', 'a0000000-0000-0000-0000-000000000021', 2, true),
  ('a0000000-0000-0000-0000-000000000025', 'Brushes & Sponges', 'brushes-sponges', 'a0000000-0000-0000-0000-000000000024', 1, true)
on conflict (id) do nothing;

-- ---------- Products ----------
insert into products (id, name, slug, brand_id, category_id, sku, short_description, description, regular_price, sale_price, stock, has_variants, variant_type, images, ingredients, benefits, how_to_use, skin_types, skin_concerns, country_of_origin, featured, best_seller, new_arrival, active, rating, review_count) values

('p0000000-0000-0000-0000-000000000001', 'Velvet Matte Lipstick', 'velvet-matte-lipstick', 'b0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000008', 'PP-LIP-001', 'Long-lasting matte lipstick with a weightless, velvety finish.', 'A richly pigmented matte lipstick that glides on smoothly and stays put for hours without drying out your lips.', 450, 380, 0, true, 'shade', '[{"url":"placeholder:lipstick:#a24552","is_main":true}]', 'Ozokerite, Castor Seed Oil, Vitamin E, Mica, Pigments.', 'Long-wear, weightless, non-drying, richly pigmented.', 'Apply directly from the bullet starting at the centre of the lips, or use a lip brush for precision.', array['All Skin Types'], array[]::text[], 'Made in Bangladesh', true, true, false, true, 4.6, 0),

('p0000000-0000-0000-0000-000000000002', 'Hydra Glow Foundation', 'hydra-glow-foundation', 'b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000009', 'GL-FDN-002', 'Buildable, lightweight foundation for a natural dewy finish.', 'A hydrating foundation that evens out skin tone while letting your natural glow through. Buildable from light to medium coverage.', 950, null, 0, true, 'shade', '[{"url":"placeholder:bottle:#e8bd93","is_main":true}]', 'Water, Glycerin, Hyaluronic Acid, Dimethicone, Titanium Dioxide.', 'Hydrating, buildable coverage, dewy finish.', 'Apply with a damp beauty sponge or foundation brush, building coverage as needed.', array['Dry','Normal','Combination'], array['Dullness'], 'Made in South Korea', false, false, true, true, 4.4, 0),

('p0000000-0000-0000-0000-000000000003', 'Silk Touch Compact Powder', 'silk-touch-compact-powder', 'b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000013', 'VT-CMP-003', 'Oil-control pressed powder for a smooth matte finish.', 'Keeps shine at bay for hours while blurring the look of pores, without looking cakey.', 550, 450, 22, false, null, '[{"url":"placeholder:compact:#e6c9a8","is_main":true}]', 'Talc, Silica, Zinc Stearate, Mica.', 'Oil control, pore-blurring, lightweight.', 'Press and roll the puff over the face for a natural matte finish.', array['Oily','Combination'], array['Oil Control'], 'Made in Thailand', false, false, false, true, 4.2, 0),

('p0000000-0000-0000-0000-000000000004', 'Vitamin C Brightening Serum', 'vitamin-c-brightening-serum', 'b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000004', 'NN-SER-004', '20% Vitamin C serum to brighten and even skin tone.', 'A potent antioxidant serum that visibly brightens dull skin, fades the look of dark spots, and supports a more even complexion over time.', 890, null, 0, true, 'size', '[{"url":"placeholder:jar:#f5c451","is_main":true}]', 'Vitamin C (Ascorbic Acid) 20%, Vitamin E, Ferulic Acid, Hyaluronic Acid.', 'Brightens skin tone, fades dark spots, antioxidant protection.', 'Apply 3-4 drops to clean skin every morning before moisturiser and sunscreen.', array['All Skin Types'], array['Dark Spots','Dullness'], 'Made in Bangladesh', true, true, false, true, 4.8, 0),

('p0000000-0000-0000-0000-000000000005', 'Niacinamide 10% Serum', 'niacinamide-10-serum', 'b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000004', 'NN-SER-005', 'Minimises the look of pores and controls excess oil.', 'A lightweight serum formulated with 10% niacinamide and zinc to visibly refine pores and balance oily, blemish-prone skin.', 750, null, 16, false, null, '[{"url":"placeholder:jar:#dfe6e0","is_main":true}]', 'Niacinamide 10%, Zinc PCA, Water.', 'Reduces pore appearance, controls oil, calms blemishes.', 'Apply a few drops to clean skin morning and night before moisturiser.', array['Oily','Combination'], array['Acne & Blemishes','Oil Control'], 'Made in Bangladesh', false, false, false, true, 4.5, 0),

('p0000000-0000-0000-0000-000000000006', 'Aloe Vera Soothing Gel', 'aloe-vera-soothing-gel', 'b0000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000005', 'DB-MOI-006', '99% pure aloe vera gel for instant hydration.', 'A soothing, lightweight gel moisturiser that calms irritated skin and delivers a burst of hydration, perfect for hot and humid days.', 320, 280, 30, false, null, '[{"url":"placeholder:jar:#bfe3b0","is_main":true}]', 'Aloe Barbadensis Leaf Extract 99%, Glycerin.', 'Soothes, hydrates, calms redness.', 'Apply a thin layer to clean skin as needed, day or night.', array['All Skin Types','Sensitive'], array['Sensitivity','Dryness'], 'Made in Bangladesh', false, false, false, true, 4.3, 0),

('p0000000-0000-0000-0000-000000000007', 'Rose Water Toner', 'rose-water-toner', 'b0000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000003', 'DB-TON-007', 'Alcohol-free toner that refreshes and balances skin.', 'Steam-distilled rose water that gently tones, hydrates, and preps skin for the rest of your routine.', 280, null, 25, false, null, '[{"url":"placeholder:spray:#f0b6c4","is_main":true}]', 'Rosa Damascena Flower Water 100%.', 'Hydrates, balances pH, refreshes.', 'Spray onto face after cleansing or use with a cotton pad.', array['All Skin Types'], array[]::text[], 'Made in Bangladesh', false, false, false, true, 4.1, 0),

('p0000000-0000-0000-0000-000000000008', 'Charcoal Deep Cleanse Face Wash', 'charcoal-deep-cleanse-face-wash', 'b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'TO-CLN-008', 'Activated charcoal face wash that purifies pores.', 'Deep-cleans without stripping, lifting away dirt, oil and impurities while leaving skin feeling fresh, not tight.', 350, null, 40, false, null, '[{"url":"placeholder:tube:#4a4a4a","is_main":true}]', 'Activated Charcoal, Salicylic Acid, Aloe Vera.', 'Purifies pores, controls oil, gentle exfoliation.', 'Massage onto damp skin morning and night, then rinse.', array['Oily','Combination'], array['Acne & Blemishes','Oil Control'], 'Made in Bangladesh', false, true, false, true, 4.5, 0),

('p0000000-0000-0000-0000-000000000009', 'Matte Sunscreen SPF50', 'matte-sunscreen-spf50', 'b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000006', 'GL-SUN-009', 'Broad-spectrum SPF50 with a weightless matte finish.', 'Lightweight, non-greasy sun protection that layers beautifully under makeup, with no white cast.', 650, 550, 5, false, null, '[{"url":"placeholder:tube:#f7e2c4","is_main":true}]', 'Zinc Oxide, Niacinamide, Vitamin E.', 'Broad-spectrum SPF50, matte finish, no white cast.', 'Apply generously as the last step of your morning routine and reapply every 3-4 hours.', array['All Skin Types'], array[]::text[], 'Made in South Korea', true, false, false, true, 4.7, 0),

('p0000000-0000-0000-0000-000000000010', 'Argan Hair Oil', 'argan-hair-oil', 'b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000017', 'NN-OIL-010', 'Nourishing hair oil for shine and frizz control.', 'Cold-pressed argan oil blended with lightweight botanicals to tame frizz and add lasting shine.', 420, null, 20, false, null, '[{"url":"placeholder:bottle:#b98442","is_main":true}]', 'Argania Spinosa Kernel Oil, Vitamin E.', 'Tames frizz, adds shine, nourishes split ends.', 'Apply a few drops to damp or dry hair, focusing on the ends.', array[]::text[], array[]::text[], 'Made in Bangladesh', false, false, false, true, 4.4, 0),

('p0000000-0000-0000-0000-000000000011', 'Keratin Repair Shampoo', 'keratin-repair-shampoo', 'b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000015', 'VT-SHM-011', 'Sulfate-free shampoo that repairs damaged strands.', 'A gentle, sulfate-free formula that strengthens weak, damaged hair while cleansing without stripping natural oils.', 480, 399, 24, false, null, '[{"url":"placeholder:bottle:#d8c7e0","is_main":true}]', 'Hydrolyzed Keratin, Panthenol, Coconut-derived Cleansers.', 'Repairs damage, strengthens strands, sulfate-free.', 'Massage into wet hair, lather, and rinse thoroughly. Follow with conditioner.', array[]::text[], array[]::text[], 'Made in Bangladesh', false, false, false, true, 4.3, 0),

('p0000000-0000-0000-0000-000000000012', 'Silk Smooth Conditioner', 'silk-smooth-conditioner', 'b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000016', 'VT-CON-012', 'Deep conditioning treatment for silky, manageable hair.', 'Detangles and softens even the driest hair, leaving it smooth, glossy and easy to style.', 480, null, 18, false, null, '[{"url":"placeholder:bottle:#e3d5ea","is_main":true}]', 'Shea Butter, Panthenol, Silk Amino Acids.', 'Detangles, softens, adds shine.', 'Apply to washed hair, leave for 2-3 minutes, then rinse.', array[]::text[], array[]::text[], 'Made in Bangladesh', false, false, false, true, 4.2, 0),

('p0000000-0000-0000-0000-000000000013', 'Shea Butter Body Lotion', 'shea-butter-body-lotion', 'b0000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000019', 'DB-LOT-013', '24-hour hydrating body lotion with shea butter.', 'A fast-absorbing lotion that melts into skin, leaving it soft and nourished all day long.', 380, null, 26, false, null, '[{"url":"placeholder:bottle:#f2e2c8","is_main":true}]', 'Shea Butter, Glycerin, Vitamin E.', '24-hour hydration, fast-absorbing, non-greasy.', 'Apply generously all over the body after showering.', array['Dry','Normal'], array['Dryness'], 'Made in Bangladesh', false, false, true, true, 4.4, 0),

('p0000000-0000-0000-0000-000000000014', 'Coffee Body Scrub', 'coffee-body-scrub', 'b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000020', 'TO-SCR-014', 'Exfoliating coffee scrub to reveal smoother skin.', 'Ground coffee and natural oils buff away dead skin, leaving you smooth, soft and glowing.', 420, 350, 15, false, null, '[{"url":"placeholder:jar:#6b4a35","is_main":true}]', 'Coffee Grounds, Coconut Oil, Brown Sugar.', 'Exfoliates, smooths, boosts circulation.', 'Massage onto damp skin in circular motions, then rinse.', array['All Skin Types'], array['Dullness'], 'Made in Bangladesh', false, false, false, true, 4.3, 0),

('p0000000-0000-0000-0000-000000000015', 'Blooming Rose Eau de Parfum', 'blooming-rose-eau-de-parfum', 'b0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000022', 'PP-PRF-015', 'A romantic floral fragrance with notes of rose and musk.', 'An elegant eau de parfum that opens with fresh rose petals and settles into a warm, musky base that lasts all day.', 1450, null, 10, false, null, '[{"url":"placeholder:spray:#d8a0b0","is_main":true}]', 'Alcohol Denat, Fragrance (Parfum), Rose Extract.', 'Long-lasting, romantic floral scent.', 'Spray onto pulse points such as wrists and neck.', array[]::text[], array[]::text[], 'Imported', true, false, false, true, 4.6, 0),

('p0000000-0000-0000-0000-000000000016', 'Citrus Breeze Body Mist', 'citrus-breeze-body-mist', 'b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000023', 'GL-MST-016', 'Light, refreshing body mist with citrus notes.', 'A crisp, refreshing mist perfect for everyday wear, layering beautifully under your favourite perfume.', 350, null, 28, false, null, '[{"url":"placeholder:spray:#f5d98a","is_main":true}]', 'Water, Alcohol Denat, Fragrance.', 'Refreshing, lightweight, layerable.', 'Mist generously over body after showering.', array[]::text[], array[]::text[], 'Made in Thailand', false, false, false, true, 4.0, 0),

('p0000000-0000-0000-0000-000000000017', 'Eyeshadow Palette — Sunset Hues', 'eyeshadow-palette-sunset-hues', 'b0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000010', 'PP-EYS-017', '12-shade eyeshadow palette in warm sunset tones.', 'A versatile mix of mattes and shimmers in warm, wearable sunset shades for everyday looks or a bold night out.', 890, 720, 13, false, null, '[{"url":"placeholder:palette:#e08a4d","is_main":true}]', 'Mica, Talc, Dimethicone, Pigments.', 'Highly pigmented, blendable, long-wearing.', 'Apply with a brush, building intensity as desired.', array[]::text[], array[]::text[], 'Made in South Korea', true, true, false, true, 4.7, 0),

('p0000000-0000-0000-0000-000000000018', 'Volumizing Mascara', 'volumizing-mascara', 'b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000011', 'TO-MAS-018', 'Buildable mascara for dramatic volume and length.', 'A jet-black formula that coats every lash for bold, fluttery volume without clumping.', 380, null, 0, false, null, '[{"url":"placeholder:tube:#1a1a1a","is_main":true}]', 'Beeswax, Carnauba Wax, Pigments.', 'Volumising, buildable, smudge-resistant.', 'Wiggle the wand from root to tip, building layers as needed.', array[]::text[], array[]::text[], 'Made in Bangladesh', false, false, true, true, 4.1, 0),

('p0000000-0000-0000-0000-000000000019', 'Blush Duo — Peach Glow', 'blush-duo-peach-glow', 'b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000012', 'VT-BLS-019', 'Two-tone blush duo for a natural flushed finish.', 'A silky-soft blush duo that blends effortlessly for a natural, lit-from-within flush.', 420, null, 4, false, null, '[{"url":"placeholder:compact:#f0a898","is_main":true}]', 'Talc, Mica, Pigments, Vitamin E.', 'Blendable, buildable, natural finish.', 'Sweep onto the apples of cheeks with a fluffy brush.', array[]::text[], array[]::text[], 'Made in Bangladesh', false, false, false, true, 4.3, 0),

('p0000000-0000-0000-0000-000000000020', 'Mini Lip Balm Trio Set', 'mini-lip-balm-trio-set', 'b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000008', 'TO-LIP-020', 'Set of 3 tinted lip balms for everyday softness.', 'Three sheer, tinted balms packed with nourishing oils for soft, healthy-looking lips all day.', 280, 250, 35, false, null, '[{"url":"placeholder:lipstick:#e8a8a0","is_main":true}]', 'Shea Butter, Coconut Oil, Vitamin E.', 'Hydrating, sheer tint, nourishing.', 'Apply directly to lips as needed throughout the day.', array['All Skin Types'], array[]::text[], 'Made in Bangladesh', true, false, false, true, 4.5, 0)

on conflict (id) do nothing;

-- ---------- Variants ----------
insert into product_variants (product_id, label, hex_color, stock, display_order) values
  ('p0000000-0000-0000-0000-000000000001', 'Rosewood', '#a24552', 14, 1),
  ('p0000000-0000-0000-0000-000000000001', 'Brick Red', '#9c3b2e', 8, 2),
  ('p0000000-0000-0000-0000-000000000001', 'Nude Blush', '#c48a7d', 0, 3),
  ('p0000000-0000-0000-0000-000000000001', 'Berry Wine', '#6e2a3d', 11, 4),
  ('p0000000-0000-0000-0000-000000000002', 'Fair', '#f2d3b3', 9, 1),
  ('p0000000-0000-0000-0000-000000000002', 'Light', '#e8bd93', 12, 2),
  ('p0000000-0000-0000-0000-000000000002', 'Medium', '#c98f61', 10, 3),
  ('p0000000-0000-0000-0000-000000000002', 'Tan', '#a86a3f', 6, 4),
  ('p0000000-0000-0000-0000-000000000002', 'Deep', '#7c4a2a', 5, 5);

insert into product_variants (product_id, label, price, stock, display_order) values
  ('p0000000-0000-0000-0000-000000000004', '15ml', 890, 18, 1),
  ('p0000000-0000-0000-0000-000000000004', '30ml', 1450, 9, 2);

-- ---------- Coupons ----------
insert into coupons (code, type, value, min_order, max_discount, start_date, expiry_date, usage_limit, active) values
  ('WELCOME10', 'percentage', 10, 500, 200, '2026-01-01', '2027-12-31', 500, true),
  ('FLAT100', 'fixed', 100, 999, null, '2026-01-01', '2027-12-31', 200, true);

-- ---------- Banners ----------
insert into banners (kind, title, subtitle, button_text, button_link, image_url, display_order, active) values
  ('hero', 'Glow starts here', 'Up to 30% off skincare essentials this week', 'Shop Skincare', '/shop?category=skincare', 'placeholder:jar:#f5c451', 1, true),
  ('hero', 'New season, new shades', 'Discover the Sunset Hues eyeshadow collection', 'Explore Makeup', '/shop?category=makeup', 'placeholder:palette:#e08a4d', 2, true),
  ('promo', 'Free delivery inside Dhaka', 'On orders over Tk 999', 'Shop now', '/shop', 'placeholder:bottle:#e8bd93', 1, true),
  ('promo', 'Bundle & save', 'Use WELCOME10 for 10% off your first order', 'View offer', '/shop', 'placeholder:lipstick:#a24552', 2, true);

-- ---------- Sample reviews (on the seeded products — replace as real reviews come in) ----------
insert into reviews (product_id, customer_name, rating, comment, status, featured) values
  ('p0000000-0000-0000-0000-000000000001', 'Nusrat J.', 5, 'Stays on through lunch and does not dry out my lips at all.', 'approved', true),
  ('p0000000-0000-0000-0000-000000000004', 'Farzana A.', 5, 'My dark spots have visibly faded after a month of using this every morning.', 'approved', true),
  ('p0000000-0000-0000-0000-000000000008', 'Rakibul I.', 4, 'Great face wash for oily skin, though I wish it came in a bigger size.', 'approved', false),
  ('p0000000-0000-0000-0000-000000000017', 'Tania R.', 5, 'These shades are so pigmented and blend beautifully.', 'approved', true),
  ('p0000000-0000-0000-0000-000000000009', 'Sadia I.', 4, 'No white cast at all, perfect under makeup.', 'approved', false);

-- ---------- Site settings ----------
-- IMPORTANT: replace these with your real numbers/links from the Admin -> Settings page
-- before you launch — these are placeholders so the site has something to display.
update site_settings set
  bkash_number = '01XXXXXXXXX',
  nagad_number = '01XXXXXXXXX',
  site_facebook = 'https://facebook.com/yourpage',
  site_phone = '01XXXXXXXXX',
  site_email = 'hello@yourdomain.com',
  site_address = 'Dhaka, Bangladesh'
where id = 1;
