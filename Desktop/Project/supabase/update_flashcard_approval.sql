-- Change default value of is_approved to false
-- New flashcards will require admin approval
ALTER TABLE community_flashcards
ALTER COLUMN is_approved SET DEFAULT false;

-- Optional: Set existing flashcards to approved (so they don't disappear)
UPDATE community_flashcards
SET is_approved = true
WHERE is_approved IS NULL OR is_approved = false;
