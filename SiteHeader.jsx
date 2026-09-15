import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Search, ShoppingBag, Heart, Menu, X, Phone } from 'lucide-react';
import { useStore } from '../../context/StoreContext';
import { useSettings } from '../../context/SettingsContext';

const NAV_LINKS = [
  { to: '/', label: 'Home' },
  { to: '/shop', label: 'Shop' },
  { to: '/shop?featured=1', label: 'Featured' },
  { to: '/info/about', label: 'About' },
  { to: '/info/contact', label: 'Contact' },
];

export default function SiteHeader() {
  const { cartCount, wishlist } = useStore();
  const { settings } = useSettings();
  const [mobileOpen, setMobileOpen] = useState(false);
  const [query, setQuery] = useState('');
  const navigate = useNavigate();

  function submitSearch(e) {
    e.preventDefault();
    if (query.trim()) navigate(`/shop?q=${encodeURIComponent(query.trim())}`);
    setMobileOpen(false);
  }

  return (
    <header className="sticky top-0 z-40 bg-cream/95 backdrop-blur border-b border-ink/10">
      {settings?.site_phone && (
        <div className="hidden sm:flex bg-ink text-cream text-xs justify-center items-center gap-2 py-1.5">
          <Phone size={12} />
          <span>Order by phone: {settings.site_phone}</span>
          <span className="text-cream/50">•</span>
          <span>Cash on delivery available nationwide</span>
        </div>
      )}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-4 flex items-center gap-4">
        <button className="lg:hidden p-2 -ml-2" onClick={() => setMobileOpen(true)} aria-label="Open menu">
          <Menu size={22} />
        </button>

        <Link to="/" className="font-serif text-xl sm:text-2xl text-ink tracking-tight shrink-0">
          Beauty Boutique <span className="text-rose">By Tandra</span>
        </Link>

        <nav className="hidden lg:flex items-center gap-7 ml-6">
          {NAV_LINKS.map((l) => (
            <Link key={l.label} to={l.to} className="text-sm text-ink/80 hover:text-rose transition-colors">
              {l.label}
            </Link>
          ))}
        </nav>

        <form onSubmit={submitSearch} className="hidden md:flex items-center flex-1 max-w-sm ml-auto relative">
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Search products, brands..."
            className="w-full rounded-full border border-ink/15 bg-paper px-4 py-2 pr-10 text-sm focus:outline-none focus:border-rose"
          />
          <button type="submit" className="absolute right-3 text-taupe" aria-label="Search">
            <Search size={16} />
          </button>
        </form>

        <div className="flex items-center gap-1 ml-auto md:ml-4">
          <button className="md:hidden p-2" onClick={() => navigate('/shop')} aria-label="Search">
            <Search size={20} />
          </button>
          <Link to="/wishlist" className="relative p-2" aria-label="Wishlist">
            <Heart size={20} />
            {wishlist.length > 0 && (
              <span className="absolute top-0 right-0 h-4 w-4 rounded-full bg-rose text-cream text-[10px] flex items-center justify-center">
                {wishlist.length}
              </span>
            )}
          </Link>
          <Link to="/cart" className="relative p-2" aria-label="Cart">
            <ShoppingBag size={20} />
            {cartCount > 0 && (
              <span className="absolute top-0 right-0 h-4 w-4 rounded-full bg-rose text-cream text-[10px] flex items-center justify-center">
                {cartCount}
              </span>
            )}
          </Link>
        </div>
      </div>

      {mobileOpen && (
        <div className="fixed inset-0 z-50 bg-ink/50 lg:hidden" onClick={() => setMobileOpen(false)}>
          <div className="bg-cream h-full w-72 p-6" onClick={(e) => e.stopPropagation()}>
            <div className="flex justify-between items-center mb-8">
              <span className="font-serif text-lg">Menu</span>
              <button onClick={() => setMobileOpen(false)} aria-label="Close menu">
                <X size={20} />
              </button>
            </div>
            <form onSubmit={submitSearch} className="mb-6 relative">
              <input
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder="Search products..."
                className="w-full rounded-full border border-ink/15 bg-paper px-4 py-2 pr-10 text-sm"
              />
              <button type="submit" className="absolute right-3 top-2.5 text-taupe" aria-label="Search">
                <Search size={16} />
              </button>
            </form>
            <nav className="flex flex-col gap-1">
              {NAV_LINKS.map((l) => (
                <Link
                  key={l.label}
                  to={l.to}
                  onClick={() => setMobileOpen(false)}
                  className="py-3 border-b border-ink/10 text-ink"
                >
                  {l.label}
                </Link>
              ))}
              <Link to="/track-order" onClick={() => setMobileOpen(false)} className="py-3 border-b border-ink/10 text-ink">
                Track Order
              </Link>
              <Link to="/account" onClick={() => setMobileOpen(false)} className="py-3 border-b border-ink/10 text-ink">
                My Account
              </Link>
            </nav>
          </div>
        </div>
      )}
    </header>
  );
}
