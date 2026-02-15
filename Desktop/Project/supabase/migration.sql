-- PyDeck Migration: Subtopics, Concepts, and MCQ Flashcards
-- Run this in Supabase SQL Editor after the initial schema.sql

-- 1. Create subtopics table
CREATE TABLE IF NOT EXISTS subtopics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id UUID REFERENCES topics(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  icon TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create concepts table
CREATE TABLE IF NOT EXISTS concepts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subtopic_id UUID REFERENCES subtopics(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  code_examples TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Add MCQ columns to flashcards table
ALTER TABLE flashcards ADD COLUMN IF NOT EXISTS subtopic_id UUID REFERENCES subtopics(id) ON DELETE SET NULL;
ALTER TABLE flashcards ADD COLUMN IF NOT EXISTS option_a TEXT;
ALTER TABLE flashcards ADD COLUMN IF NOT EXISTS option_b TEXT;
ALTER TABLE flashcards ADD COLUMN IF NOT EXISTS option_c TEXT;
ALTER TABLE flashcards ADD COLUMN IF NOT EXISTS option_d TEXT;
ALTER TABLE flashcards ADD COLUMN IF NOT EXISTS correct_option CHAR(1);

-- 4. Create flashcard_responses table for tracking MCQ answers
CREATE TABLE IF NOT EXISTS flashcard_responses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  flashcard_id UUID REFERENCES flashcards(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  selected_option CHAR(1) NOT NULL,
  is_correct BOOLEAN NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on new tables
ALTER TABLE subtopics ENABLE ROW LEVEL SECURITY;
ALTER TABLE concepts ENABLE ROW LEVEL SECURITY;
ALTER TABLE flashcard_responses ENABLE ROW LEVEL SECURITY;

-- RLS Policies for subtopics (readable by authenticated users)
CREATE POLICY "Subtopics are viewable by authenticated users"
  ON subtopics FOR SELECT TO authenticated USING (true);

-- RLS Policies for concepts (readable by authenticated users)
CREATE POLICY "Concepts are viewable by authenticated users"
  ON concepts FOR SELECT TO authenticated USING (true);

-- RLS Policies for flashcard_responses (users manage their own)
CREATE POLICY "Users can view own responses"
  ON flashcard_responses FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own responses"
  ON flashcard_responses FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_subtopics_topic_id ON subtopics(topic_id);
CREATE INDEX IF NOT EXISTS idx_concepts_subtopic_id ON concepts(subtopic_id);
CREATE INDEX IF NOT EXISTS idx_flashcards_subtopic_id ON flashcards(subtopic_id);
CREATE INDEX IF NOT EXISTS idx_flashcard_responses_user_id ON flashcard_responses(user_id);
CREATE INDEX IF NOT EXISTS idx_flashcard_responses_flashcard_id ON flashcard_responses(flashcard_id);
