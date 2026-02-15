-- Create user_appeals table for blocked users to send messages to admin

CREATE TABLE IF NOT EXISTS user_appeals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed')),
  reviewed_at TIMESTAMPTZ,
  reviewed_by UUID REFERENCES profiles(id)
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS user_appeals_user_id_idx ON user_appeals(user_id);
CREATE INDEX IF NOT EXISTS user_appeals_status_idx ON user_appeals(status);

-- Enable Row Level Security
ALTER TABLE user_appeals ENABLE ROW LEVEL SECURITY;

-- Policy: Users can insert their own appeals
CREATE POLICY "Users can create their own appeals"
  ON user_appeals
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can view their own appeals
CREATE POLICY "Users can view their own appeals"
  ON user_appeals
  FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Admins can view all appeals
CREATE POLICY "Admins can view all appeals"
  ON user_appeals
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Policy: Admins can update appeals
CREATE POLICY "Admins can update appeals"
  ON user_appeals
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );
