-- Add email and status columns to profiles table

-- Add email column
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS email TEXT;

-- Add status column (active or blocked)
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'active';

-- Create index on email for faster lookups
CREATE INDEX IF NOT EXISTS profiles_email_idx ON profiles(email);

-- Create index on status for filtering
CREATE INDEX IF NOT EXISTS profiles_status_idx ON profiles(status);

-- Update existing profiles with email from auth.users
-- This requires a function to be run by admin
CREATE OR REPLACE FUNCTION sync_user_emails()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE profiles
  SET email = au.email
  FROM auth.users au
  WHERE profiles.id = au.id
  AND profiles.email IS NULL;
END;
$$;

-- Run the sync function
SELECT sync_user_emails();
