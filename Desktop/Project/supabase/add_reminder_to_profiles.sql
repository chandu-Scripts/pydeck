-- Add study reminder columns to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS reminder_enabled boolean DEFAULT false;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS reminder_time_utc text DEFAULT '08:00';
