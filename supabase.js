import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!url || !anonKey || url.includes('your-project-id')) {
  // Doesn't throw — lets the app still render a clear on-screen message
  // instead of a blank white screen when .env hasn't been set up yet.
  console.error(
    'Supabase is not configured. Copy .env.example to .env and add your project URL + anon key.'
  );
}

export const supabase = createClient(url || 'https://placeholder.supabase.co', anonKey || 'placeholder');

export const isSupabaseConfigured = Boolean(url && anonKey && !url.includes('your-project-id'));
