-- Migration: Add Community Chat Feature
-- Run this in Supabase SQL Editor

-- Create community_chat table
CREATE TABLE IF NOT EXISTS community_chat (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  username TEXT NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE
);

-- Enable Row Level Security
ALTER TABLE community_chat ENABLE ROW LEVEL SECURITY;

-- RLS Policies for community_chat

-- Anyone can view chat messages
CREATE POLICY "Chat messages are viewable by authenticated users"
ON community_chat FOR SELECT
TO authenticated
USING (true);

-- Users can insert their own messages
CREATE POLICY "Users can send chat messages"
ON community_chat FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Users can delete their own messages
CREATE POLICY "Users can delete own messages"
ON community_chat FOR DELETE
TO authenticated
USING (auth.uid() = user_id);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_community_chat_created_at ON community_chat(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_community_chat_user_id ON community_chat(user_id);
