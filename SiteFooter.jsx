import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { Facebook, Instagram, Phone, Mail, MapPin, Send } from 'lucide-react';
import { useSettings } from '../../context/SettingsContext';
import { useStore } from '../../context/StoreContext';
import { Button } from '../ui/Primitives';

const INFO_LINKS = [
  ['About Us', '/info/about'],
  ['Contact Us', '/info/contact'],
  ['FAQ', '/info/faq'],
  ['Delivery Information', '/info/delivery'],
  ['Return & Refund Policy', '/info/returns'],
  ['Privacy Policy', '/info/privacy'],
  ['Terms & Conditions', '/info/terms'],
];

export default function SiteFooter() {
  const { settings } = useSettings();
  const { showToast } = useStore();
  const [email, setEmail] = useState('');

  function subscribe(e) {
    e.preventDefault();
    if (!email.trim()) return;
    showToast('Subscribed! Watch your inbox for offers.');
    setEmail('');
  }

  return (
    <footer className="bg-ink text-cream/90 mt-20">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-14 grid grid-cols-2 md:grid-cols-4 gap-10">
        <div className="col-span-2">
          <h3 className="font-serif text-xl text-cream mb-3">Beauty Boutique By Tandra</h3>
          <p className="text-sm text-cream/60 max-w-xs mb-5">
            Skincare, makeup, hair and body care sourced with care and delivered across Bangladesh —
            cash on delivery, bKash and Nagad accepted.
          </p>
          <form onSubmit={subscribe} className="flex max-w-xs">
            <input
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              type="email"
              placeholder="Your email for offers"
              className="flex-1 rounded-l-full bg-cream/10 border border-cream/20 px-4 py-2 text-sm text-cream placeholder:text-cream/40 focus:outline-none"
            />
            <button type="submit" className="rounded-r-full bg-rose px-4 flex items-center justify-center" aria-label="Subscribe">
              <Send size={16} />
            </button>
          </form>
          <div className="flex gap-3 mt-5">
            {settings?.site_facebook && (
              <a href={settings.site_facebook} target="_blank" rel="noreferrer" className="h-9 w-9 rounded-full bg-cream/10 flex items-center justify-center hover:bg-rose transition-colors">
                <Facebook size={16} />
              </a>
            )}
            <span className="h-9 w-9 rounded-full bg-cream/10 flex items-center justify-center opacity-50">
              <Instagram size={16} />
            </span>
          </div>
        </div>

        <div>
          <h4 className="text-sm font-medium text-cream mb-4">Shop</h4>
          <ul className="space-y-2.5 text-sm text-cream/60">
            <li><Link to="/shop" className="hover:text-cream">All Products</Link></li>
            <li><Link to="/shop?sort=new" className="hover:text-cream">New Arrivals</Link></li>
            <li><Link to="/shop?sort=bestseller" className="hover:text-cream">Best Sellers</Link></li>
            <li><Link to="/shop?discount=1" className="hover:text-cream">Deals</Link></li>
            <li><Link to="/track-order" className="hover:text-cream">Track Order</Link></li>
          </ul>
        </div>

        <div>
          <h4 className="text-sm font-medium text-cream mb-4">Support</h4>
          <ul className="space-y-2.5 text-sm text-cream/60">
            {INFO_LINKS.map(([label, to]) => (
              <li key={to}><Link to={to} className="hover:text-cream">{label}</Link></li>
            ))}
          </ul>
        </div>
      </div>

      <div className="border-t border-cream/10">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 py-5 flex flex-col sm:flex-row gap-3 sm:gap-6 justify-between items-start sm:items-center text-xs text-cream/50">
          <div className="flex flex-wrap gap-x-6 gap-y-2">
            {settings?.site_phone && <span className="flex items-center gap-1.5"><Phone size={12} />{settings.site_phone}</span>}
            {settings?.site_email && <span className="flex items-center gap-1.5"><Mail size={12} />{settings.site_email}</span>}
            {settings?.site_address && <span className="flex items-center gap-1.5"><MapPin size={12} />{settings.site_address}</span>}
          </div>
          <span>© {new Date().getFullYear()} Beauty Boutique By Tandra. All rights reserved.</span>
        </div>
      </div>
    </footer>
  );
}
