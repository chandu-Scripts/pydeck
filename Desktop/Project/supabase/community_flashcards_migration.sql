-- Migration: Add Community Flashcards Feature
-- Run this in Supabase SQL Editor

-- Create community_flashcards table
CREATE TABLE IF NOT EXISTS community_flashcards (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_by UUID NOT NULL,
  question TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  correct_answer TEXT NOT NULL CHECK (correct_answer IN ('a', 'b', 'c', 'd')),
  explanation TEXT,
  is_approved BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT fk_creator FOREIGN KEY (created_by) REFERENCES profiles(id) ON DELETE CASCADE
);

-- Enable Row Level Security
ALTER TABLE community_flashcards ENABLE ROW LEVEL SECURITY;

-- RLS Policies for community_flashcards

-- Anyone can view approved community flashcards
CREATE POLICY "Approved community flashcards are viewable by authenticated users"
ON community_flashcards FOR SELECT
TO authenticated
USING (is_approved = true);

-- Users can insert their own community flashcards
CREATE POLICY "Users can create community flashcards"
ON community_flashcards FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = created_by);

-- Users can update their own community flashcards
CREATE POLICY "Users can update own community flashcards"
ON community_flashcards FOR UPDATE
TO authenticated
USING (auth.uid() = created_by);

-- Users can delete their own community flashcards
CREATE POLICY "Users can delete own community flashcards"
ON community_flashcards FOR DELETE
TO authenticated
USING (auth.uid() = created_by);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_community_flashcards_created_by ON community_flashcards(created_by);
CREATE INDEX IF NOT EXISTS idx_community_flashcards_approved ON community_flashcards(is_approved);
