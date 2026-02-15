-- Allow admins to update any user's profile (for blocking/unblocking)

-- First, drop existing policy if it exists
DROP POLICY IF EXISTS "Admins can update any profile" ON profiles;

-- Create new policy allowing admins to update profiles
CREATE POLICY "Admins can update any profile"
  ON profiles
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Also ensure users can update their own profiles
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;

CREATE POLICY "Users can update own profile"
  ON profiles
  FOR UPDATE
  USING (auth.uid() = id);
