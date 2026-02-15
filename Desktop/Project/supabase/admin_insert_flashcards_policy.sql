-- Allow admins to insert flashcards (for quiz creation)

DROP POLICY IF EXISTS "Admins can insert flashcards" ON flashcards;

CREATE POLICY "Admins can insert flashcards"
  ON flashcards
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Also allow admins to update flashcards (for editing)
DROP POLICY IF EXISTS "Admins can update flashcards" ON flashcards;

CREATE POLICY "Admins can update flashcards"
  ON flashcards
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Also allow admins to delete flashcards
DROP POLICY IF EXISTS "Admins can delete flashcards" ON flashcards;

CREATE POLICY "Admins can delete flashcards"
  ON flashcards
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );
