-- Add poll functionality to notifications

-- Add poll columns to admin_notifications table
ALTER TABLE admin_notifications
  ADD COLUMN IF NOT EXISTS is_poll BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS poll_question TEXT,
  ADD COLUMN IF NOT EXISTS poll_option_a TEXT,
  ADD COLUMN IF NOT EXISTS poll_option_b TEXT,
  ADD COLUMN IF NOT EXISTS poll_option_c TEXT,
  ADD COLUMN IF NOT EXISTS poll_option_d TEXT;

-- Create poll responses table to track user votes
CREATE TABLE IF NOT EXISTS poll_responses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  notification_id UUID REFERENCES admin_notifications(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  selected_option CHAR(1) NOT NULL CHECK (selected_option IN ('a', 'b', 'c', 'd')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(notification_id, user_id)
);

-- Enable RLS
ALTER TABLE poll_responses ENABLE ROW LEVEL SECURITY;

-- RLS Policies for poll_responses

-- Users can insert their own votes
CREATE POLICY "Users can vote on polls"
  ON poll_responses
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can view their own votes
CREATE POLICY "Users can view own votes"
  ON poll_responses
  FOR SELECT
  USING (auth.uid() = user_id);

-- Admins can view all poll responses
CREATE POLICY "Admins can view all poll responses"
  ON poll_responses
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_poll_responses_notification_id ON poll_responses(notification_id);
CREATE INDEX IF NOT EXISTS idx_poll_responses_user_id ON poll_responses(user_id);
