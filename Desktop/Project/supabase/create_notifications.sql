-- Admin Notifications System
-- Allows admin to send notifications to all users

-- Create notifications table
CREATE TABLE IF NOT EXISTS admin_notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  created_by UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  is_active BOOLEAN DEFAULT true
);

-- Create user notification reads tracking
CREATE TABLE IF NOT EXISTS user_notification_reads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  notification_id UUID REFERENCES admin_notifications(id) ON DELETE CASCADE NOT NULL,
  read_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, notification_id)
);

-- Enable RLS
ALTER TABLE admin_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_notification_reads ENABLE ROW LEVEL SECURITY;

-- RLS Policies for admin_notifications

-- Admins can insert notifications
CREATE POLICY "Admins can create notifications"
  ON admin_notifications
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Admins can view all notifications
CREATE POLICY "Admins can view all notifications"
  ON admin_notifications
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- All authenticated users can view active notifications
CREATE POLICY "Users can view active notifications"
  ON admin_notifications
  FOR SELECT
  USING (is_active = true);

-- Admins can update/delete their notifications
CREATE POLICY "Admins can update notifications"
  ON admin_notifications
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- RLS Policies for user_notification_reads

-- Users can insert their own reads
CREATE POLICY "Users can mark notifications as read"
  ON user_notification_reads
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can view their own reads
CREATE POLICY "Users can view own reads"
  ON user_notification_reads
  FOR SELECT
  USING (auth.uid() = user_id);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_admin_notifications_created_at ON admin_notifications(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_admin_notifications_is_active ON admin_notifications(is_active);
CREATE INDEX IF NOT EXISTS idx_user_notification_reads_user_id ON user_notification_reads(user_id);
CREATE INDEX IF NOT EXISTS idx_user_notification_reads_notification_id ON user_notification_reads(notification_id);
