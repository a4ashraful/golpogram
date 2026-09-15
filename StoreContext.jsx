import React, { createContext, useContext, useEffect, useState, useCallback } from 'react';

const StoreContext = createContext(null);

const CART_KEY = 'bb_cart';
const WISHLIST_KEY = 'bb_wishlist';

function readJSON(key, fallback) {
  try {
    const raw = localStorage.getItem(key);
    return raw ? JSON.parse(raw) : fallback;
  } catch {
    return fallback;
  }
}

export function StoreProvider({ children }) {
  const [cart, setCart] = useState(() => readJSON(CART_KEY, []));
  const [wishlist, setWishlist] = useState(() => readJSON(WISHLIST_KEY, []));
  const [toast, setToast] = useState(null);

  useEffect(() => {
    localStorage.setItem(CART_KEY, JSON.stringify(cart));
  }, [cart]);

  useEffect(() => {
    localStorage.setItem(WISHLIST_KEY, JSON.stringify(wishlist));
  }, [wishlist]);

  const showToast = useCallback((message, type = 'success') => {
    setToast({ message, type, id: Date.now() });
  }, []);

  // ---------- Cart ----------
  const addToCart = useCallback(
    (item, qty = 1) => {
      const lineId = `${item.productId}_${item.variantId || 'base'}`;
      setCart((prev) => {
        const existing = prev.find((l) => l.lineId === lineId);
        const maxStock = item.maxStock ?? Infinity;
        if (existing) {
          const nextQty = Math.min(existing.qty + qty, maxStock);
          if (nextQty === existing.qty) {
            showToast(`Only ${maxStock} in stock — you already have the max in your cart.`, 'error');
            return prev;
          }
          return prev.map((l) => (l.lineId === lineId ? { ...l, qty: nextQty } : l));
        }
        const startQty = Math.min(qty, maxStock);
        return [...prev, { ...item, lineId, qty: startQty }];
      });
      showToast('Added to cart');
    },
    [showToast]
  );

  const updateCartQty = useCallback((lineId, qty) => {
    setCart((prev) =>
      prev
        .map((l) => (l.lineId === lineId ? { ...l, qty: Math.max(1, Math.min(qty, l.maxStock ?? Infinity)) } : l))
        .filter((l) => l.qty > 0)
    );
  }, []);

  const removeFromCart = useCallback(
    (lineId) => {
      setCart((prev) => prev.filter((l) => l.lineId !== lineId));
      showToast('Removed from cart');
    },
    [showToast]
  );

  const clearCart = useCallback(() => setCart([]), []);

  const cartSubtotal = cart.reduce((sum, l) => sum + l.price * l.qty, 0);
  const cartCount = cart.reduce((sum, l) => sum + l.qty, 0);

  // ---------- Wishlist ----------
  const toggleWishlist = useCallback(
    (productId) => {
      setWishlist((prev) => {
        if (prev.includes(productId)) {
          showToast('Removed from wishlist');
          return prev.filter((id) => id !== productId);
        }
        showToast('Added to wishlist');
        return [...prev, productId];
      });
    },
    [showToast]
  );

  const isWishlisted = useCallback((productId) => wishlist.includes(productId), [wishlist]);

  return (
    <StoreContext.Provider
      value={{
        cart,
        cartSubtotal,
        cartCount,
        addToCart,
        updateCartQty,
        removeFromCart,
        clearCart,
        wishlist,
        toggleWishlist,
        isWishlisted,
        toast,
        showToast,
        clearToast: () => setToast(null),
      }}
    >
      {children}
    </StoreContext.Provider>
  );
}

export const useStore = () => useContext(StoreContext);
