import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://pasfeuzwvfcbhiduzqjr.supabase.co'
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'sb_publishable_lofY5-vb48dCzV00pb3sDQ_yg3gEJ_S'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
