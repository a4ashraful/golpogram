export const DIVISIONS = [
  'Dhaka', 'Chattogram', 'Rajshahi', 'Khulna', 'Barishal', 'Sylhet', 'Rangpur', 'Mymensingh',
];

export const SKIN_TYPES = ['Oily', 'Dry', 'Combination', 'Normal', 'Sensitive', 'All Skin Types'];

export const SKIN_CONCERNS = [
  'Acne & Blemishes', 'Dark Spots', 'Fine Lines & Aging', 'Dullness', 'Dryness', 'Sensitivity', 'Oil Control',
];

export const ORDER_STATUS_FLOW = ['pending', 'confirmed', 'processing', 'shipped', 'out_for_delivery', 'delivered'];

export const ORDER_STATUS_LABELS = {
  pending: 'Order Placed',
  confirmed: 'Confirmed',
  processing: 'Processing',
  shipped: 'Shipped',
  out_for_delivery: 'Out for Delivery',
  delivered: 'Delivered',
  cancelled: 'Cancelled',
  returned: 'Returned / Refunded',
};

export const ORDER_STATUS_COLORS = {
  pending: 'bg-amber-100 text-amber-800',
  confirmed: 'bg-blue-100 text-blue-800',
  processing: 'bg-indigo-100 text-indigo-800',
  shipped: 'bg-purple-100 text-purple-800',
  out_for_delivery: 'bg-cyan-100 text-cyan-800',
  delivered: 'bg-green-100 text-green-800',
  cancelled: 'bg-red-100 text-red-800',
  returned: 'bg-stone-200 text-stone-700',
};

export const PAYMENT_METHOD_LABELS = {
  cod: 'Cash on Delivery',
  bkash: 'bKash',
  nagad: 'Nagad',
  bank_transfer: 'Bank Transfer',
};

// Simple built-in "packaging" illustrations stand in for real product photos
// until real photos are uploaded from the admin panel. Format: "placeholder:TYPE:HEX"
export const VISUAL_TYPES = ['jar', 'bottle', 'tube', 'lipstick', 'compact', 'palette', 'spray'];
