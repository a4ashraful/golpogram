import React, { useEffect } from 'react';
import { Star, X, Loader2, ImageOff } from 'lucide-react';
import { useStore } from '../../context/StoreContext';

/* ---------------- Button ---------------- */
export function Button({ variant = 'primary', size = 'md', className = '', children, disabled, ...props }) {
  const base = 'inline-flex items-center justify-center gap-2 rounded-full font-medium transition-colors disabled:opacity-50 disabled:cursor-not-allowed';
  const sizes = { sm: 'px-3 py-1.5 text-sm', md: 'px-5 py-2.5 text-sm', lg: 'px-7 py-3 text-base' };
  const variants = {
    primary: 'bg-rose text-cream hover:bg-rose-deep',
    dark: 'bg-ink text-cream hover:bg-ink/90',
    outline: 'border border-ink/20 text-ink hover:border-ink hover:bg-ink/5',
    ghost: 'text-ink hover:bg-ink/5',
    danger: 'bg-red-600 text-white hover:bg-red-700',
    gold: 'bg-gold text-ink hover:bg-gold-deep',
  };
  return (
    <button className={`${base} ${sizes[size]} ${variants[variant]} ${className}`} disabled={disabled} {...props}>
      {children}
    </button>
  );
}

/* ---------------- Badge ---------------- */
export function Badge({ children, tone = 'rose', className = '' }) {
  const tones = {
    rose: 'bg-rose text-cream',
    gold: 'bg-gold text-ink',
    olive: 'bg-olive text-cream',
    ink: 'bg-ink text-cream',
    outline: 'border border-ink/20 text-ink',
    muted: 'bg-stone-200 text-stone-700',
  };
  return (
    <span className={`inline-flex items-center rounded-full px-2.5 py-1 text-xs font-medium ${tones[tone]} ${className}`}>
      {children}
    </span>
  );
}

/* ---------------- Rating stars ---------------- */
export function RatingStars({ rating = 0, count, size = 14 }) {
  const rounded = Math.round(rating * 2) / 2;
  return (
    <div className="flex items-center gap-1">
      <div className="flex">
        {[1, 2, 3, 4, 5].map((i) => (
          <Star
            key={i}
            size={size}
            className={i <= rounded ? 'fill-gold text-gold' : 'fill-stone-200 text-stone-200'}
          />
        ))}
      </div>
      {typeof count === 'number' && <span className="text-xs text-taupe">({count})</span>}
    </div>
  );
}

/* ---------------- Price tag ---------------- */
export function PriceTag({ regular, sale, size = 'md' }) {
  const hasSale = sale && Number(sale) < Number(regular);
  const cls = size === 'lg' ? 'text-2xl' : size === 'sm' ? 'text-sm' : 'text-base';
  return (
    <div className="flex items-baseline gap-2 flex-wrap">
      <span className={`font-semibold text-ink ${cls}`}>৳{Math.round(hasSale ? sale : regular).toLocaleString('en-US')}</span>
      {hasSale && <span className="text-taupe line-through text-sm">৳{Math.round(regular).toLocaleString('en-US')}</span>}
    </div>
  );
}

/* ---------------- Toggle switch ---------------- */
export function Toggle({ checked, onChange, label }) {
  return (
    <label className="inline-flex items-center gap-3 cursor-pointer select-none">
      <span
        onClick={() => onChange(!checked)}
        className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${checked ? 'bg-rose' : 'bg-stone-300'}`}
      >
        <span className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${checked ? 'translate-x-6' : 'translate-x-1'}`} />
      </span>
      {label && <span className="text-sm text-ink">{label}</span>}
    </label>
  );
}

/* ---------------- Modal ---------------- */
export function Modal({ open, onClose, title, children, wide }) {
  useEffect(() => {
    if (!open) return;
    const onKey = (e) => e.key === 'Escape' && onClose();
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [open, onClose]);

  if (!open) return null;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-ink/50" onClick={onClose}>
      <div
        className={`bg-cream rounded-2xl shadow-xl w-full ${wide ? 'max-w-3xl' : 'max-w-md'} max-h-[90vh] overflow-y-auto`}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-between px-6 py-4 border-b border-ink/10 sticky top-0 bg-cream">
          <h3 className="font-serif text-lg text-ink">{title}</h3>
          <button onClick={onClose} className="p-1 rounded-full hover:bg-ink/5" aria-label="Close">
            <X size={18} />
          </button>
        </div>
        <div className="p-6">{children}</div>
      </div>
    </div>
  );
}

export function ConfirmDialog({ open, onClose, onConfirm, title, description, confirmLabel = 'Delete', danger = true }) {
  if (!open) return null;
  return (
    <Modal open={open} onClose={onClose} title={title}>
      <p className="text-sm text-taupe mb-6">{description}</p>
      <div className="flex justify-end gap-3">
        <Button variant="ghost" onClick={onClose}>Cancel</Button>
        <Button variant={danger ? 'danger' : 'primary'} onClick={() => { onConfirm(); onClose(); }}>{confirmLabel}</Button>
      </div>
    </Modal>
  );
}

/* ---------------- Toast host ---------------- */
export function ToastHost() {
  const { toast, clearToast } = useStore();
  useEffect(() => {
    if (!toast) return;
    const t = setTimeout(clearToast, 2600);
    return () => clearTimeout(t);
  }, [toast, clearToast]);

  if (!toast) return null;
  return (
    <div className="fixed bottom-5 left-1/2 -translate-x-1/2 z-[100] px-4">
      <div
        className={`rounded-full px-5 py-2.5 text-sm shadow-lg text-cream ${toast.type === 'error' ? 'bg-red-600' : 'bg-ink'}`}
      >
        {toast.message}
      </div>
    </div>
  );
}

/* ---------------- Empty state ---------------- */
export function EmptyState({ icon: Icon = ImageOff, title, description, action }) {
  return (
    <div className="flex flex-col items-center text-center py-16 px-6">
      <div className="h-14 w-14 rounded-full bg-paper-alt flex items-center justify-center mb-4">
        <Icon size={24} className="text-taupe" />
      </div>
      <h3 className="font-serif text-lg text-ink mb-1">{title}</h3>
      {description && <p className="text-sm text-taupe max-w-sm mb-4">{description}</p>}
      {action}
    </div>
  );
}

/* ---------------- Full page spinner ---------------- */
export function PageSpinner() {
  return (
    <div className="flex items-center justify-center py-24">
      <Loader2 className="animate-spin text-rose" size={28} />
    </div>
  );
}

/* ---------------- Accordion ---------------- */
export function Accordion({ items }) {
  const [openIndex, setOpenIndex] = React.useState(0);
  return (
    <div className="divide-y divide-ink/10 border-y border-ink/10">
      {items.map((item, i) => (
        <div key={i}>
          <button
            className="w-full flex items-center justify-between py-4 text-left"
            onClick={() => setOpenIndex(openIndex === i ? -1 : i)}
          >
            <span className="font-medium text-ink pr-4">{item.q}</span>
            <span className="text-taupe text-xl leading-none">{openIndex === i ? '−' : '+'}</span>
          </button>
          {openIndex === i && <p className="pb-4 text-sm text-taupe leading-relaxed">{item.a}</p>}
        </div>
      ))}
    </div>
  );
}

/* ---------------- Product visual (illustration placeholder or real photo) ---------------- */
function PlaceholderArt({ type = 'jar', color = '#9C3450', className = '' }) {
  const shapes = {
    lipstick: (
      <>
        <rect x="42" y="8" width="16" height="32" rx="4" fill={color} />
        <rect x="40" y="38" width="20" height="9" rx="2" fill="#3a2f2f" />
        <rect x="37" y="46" width="26" height="36" rx="7" fill="#f2ece2" stroke="#ddd2bf" />
      </>
    ),
    bottle: (
      <>
        <rect x="34" y="12" width="12" height="10" rx="2" fill="#cfc9c2" />
        <rect x="26" y="22" width="28" height="58" rx="11" fill={color} />
      </>
    ),
    jar: (
      <>
        <rect x="23" y="14" width="34" height="13" rx="3" fill="#d8cba8" />
        <rect x="19" y="27" width="42" height="48" rx="9" fill={color} />
      </>
    ),
    tube: (
      <>
        <path d="M30 14 L50 14 L46 32 L34 32 Z" fill="#cfc9c2" />
        <rect x="25" y="32" width="30" height="50" rx="13" fill={color} />
      </>
    ),
    compact: (
      <>
        <circle cx="40" cy="46" r="28" fill="#3a3a3a" />
        <circle cx="40" cy="46" r="20" fill={color} />
      </>
    ),
    palette: (
      <>
        <rect x="12" y="24" width="56" height="42" rx="6" fill="#3a3a3a" />
        {Array.from({ length: 12 }).map((_, i) => {
          const r = Math.floor(i / 4);
          const c = i % 4;
          return <circle key={i} cx={21 + c * 12} cy={34 + r * 12} r="4.4" fill={i % 2 === 0 ? color : '#f2d9c4'} />;
        })}
      </>
    ),
    spray: (
      <>
        <rect x="32" y="8" width="8" height="14" rx="2" fill="#b8b2aa" />
        <rect x="26" y="22" width="20" height="11" rx="3" fill="#cfc9c2" />
        <rect x="20" y="33" width="38" height="49" rx="9" fill={color} />
      </>
    ),
  };
  return (
    <svg viewBox="0 0 80 92" className={className} role="img" aria-label={`${type} illustration`}>
      {shapes[type] || shapes.jar}
    </svg>
  );
}

export function ProductVisual({ image, className = '' }) {
  if (image && (image.startsWith('http') || image.startsWith('data:'))) {
    return <img src={image} className={`object-contain ${className}`} alt="" loading="lazy" />;
  }
  const parts = (image || 'placeholder:jar:#9C3450').split(':');
  return <PlaceholderArt type={parts[1]} color={parts[2]} className={className} />;
}
