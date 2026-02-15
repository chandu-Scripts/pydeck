-- Step 1: Add role column to profiles table (if it doesn't exist)
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin'));

-- Step 2: Find the user_id for pydeckofficial@gmail.com
SELECT id, email, raw_user_meta_data->>'full_name' as full_name
FROM auth.users
WHERE email = 'pydeckofficial@gmail.com';

-- Step 3: Make pydeckofficial@gmail.com an admin
-- Replace 'USER_ID_HERE' with the actual id from Step 2
UPDATE profiles
SET role = 'admin'
WHERE id = (
  SELECT id FROM auth.users WHERE email = 'pydeckofficial@gmail.com'
);

-- Step 4: Verify admin status
SELECT p.id, p.username, p.email, p.role, u.email as auth_email
FROM profiles p
JOIN auth.users u ON p.id = u.id
WHERE p.role = 'admin';
