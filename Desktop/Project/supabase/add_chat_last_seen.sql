-- Add chat_last_seen column to profiles table
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS chat_last_seen TIMESTAMPTZ DEFAULT NOW();
