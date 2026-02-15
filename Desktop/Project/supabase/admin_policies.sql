-- First, drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Users can delete own flashcards" ON community_flashcards;
DROP POLICY IF EXISTS "Users can update own flashcards" ON community_flashcards;
DROP POLICY IF EXISTS "Users can view approved flashcards" ON community_flashcards;

-- Allow admins to delete any community flashcard
CREATE POLICY "Admins can delete any flashcard"
ON community_flashcards
FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- Allow admins to update any community flashcard (for approval)
CREATE POLICY "Admins can update any flashcard"
ON community_flashcards
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- Allow admins to view all flashcards (including unapproved)
CREATE POLICY "Admins can view all flashcards"
ON community_flashcards
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
  )
  OR is_approved = true
);
