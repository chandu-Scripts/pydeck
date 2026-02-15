-- Add type column to community_flashcards
ALTER TABLE community_flashcards
ADD COLUMN type TEXT DEFAULT 'mcq' CHECK (type IN ('mcq', 'qa'));

-- Make MCQ-specific columns nullable for Q/A type
ALTER TABLE community_flashcards
ALTER COLUMN option_a DROP NOT NULL;

ALTER TABLE community_flashcards
ALTER COLUMN option_b DROP NOT NULL;

ALTER TABLE community_flashcards
ALTER COLUMN option_c DROP NOT NULL;

ALTER TABLE community_flashcards
ALTER COLUMN option_d DROP NOT NULL;

ALTER TABLE community_flashcards
ALTER COLUMN correct_answer DROP NOT NULL;

-- Update existing flashcards to MCQ type
UPDATE community_flashcards
SET type = 'mcq'
WHERE type IS NULL;
