export const formatBDT = (n) => `৳${Math.round(Number(n) || 0).toLocaleString('en-US')}`;

export const formatDate = (d) =>
  d ? new Date(d).toLocaleDateString('en-US', { day: 'numeric', month: 'short', year: 'numeric' }) : '';

export const formatDateTime = (d) =>
  d
    ? new Date(d).toLocaleDateString('en-US', {
        day: 'numeric',
        month: 'short',
        year: 'numeric',
        hour: 'numeric',
        minute: '2-digit',
      })
    : '';

export const discountPct = (regular, sale) =>
  sale && Number(sale) < Number(regular) ? Math.round((1 - Number(sale) / Number(regular)) * 100) : 0;

export const effectivePrice = (product) =>
  product.sale_price && Number(product.sale_price) < Number(product.regular_price)
    ? Number(product.sale_price)
    : Number(product.regular_price);

export const slugify = (s) =>
  (s || '')
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '');

export const genOrderNumber = () => {
  const d = new Date();
  const stamp = `${d.getFullYear().toString().slice(2)}${String(d.getMonth() + 1).padStart(2, '0')}${String(
    d.getDate()
  ).padStart(2, '0')}`;
  const rand = Math.floor(1000 + Math.random() * 9000);
  return `BB${stamp}${rand}`;
};

// Total stock for a product, accounting for variants.
export const totalStock = (product, variants) => {
  if (product.has_variants) {
    return (variants || []).reduce((sum, v) => sum + (v.stock || 0), 0);
  }
  return product.stock || 0;
};

// A small random id, stored in localStorage, used only to remember a
// person's cart/wishlist between visits on the SAME browser. It is not an
// account and identifies nothing about the person.
export const getDeviceId = () => {
  const key = 'bb_device_id';
  let id = localStorage.getItem(key);
  if (!id) {
    id = `dev_${Date.now().toString(36)}${Math.random().toString(36).slice(2, 8)}`;
    localStorage.setItem(key, id);
  }
  return id;
};
