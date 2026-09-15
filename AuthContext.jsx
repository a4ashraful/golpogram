import React, { createContext, useContext, useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [session, setSession] = useState(null);
  const [isAdmin, setIsAdmin] = useState(false);
  const [checking, setChecking] = useState(true);

  async function refreshAdminStatus(activeSession) {
    if (!activeSession) {
      setIsAdmin(false);
      return;
    }
    const { data, error } = await supabase.rpc('is_admin');
    setIsAdmin(!error && data === true);
  }

  useEffect(() => {
    let mounted = true;

    supabase.auth.getSession().then(async ({ data }) => {
      if (!mounted) return;
      setSession(data.session);
      await refreshAdminStatus(data.session);
      setChecking(false);
    });

    const { data: listener } = supabase.auth.onAuthStateChange(async (_event, newSession) => {
      setSession(newSession);
      await refreshAdminStatus(newSession);
    });

    return () => {
      mounted = false;
      listener?.subscription?.unsubscribe();
    };
  }, []);

  async function signIn(email, password) {
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) return { error: error.message };
    return { error: null };
  }

  async function signOut() {
    await supabase.auth.signOut();
  }

  return (
    <AuthContext.Provider value={{ session, isAdmin, checking, signIn, signOut }}>{children}</AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
