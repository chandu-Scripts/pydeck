# Flashcard Types Implementation - Setup Guide

## 🎯 What's New?
You now have **2 types** of community flashcards:
1. **MCQ** - Multiple Choice Questions (existing)
2. **Q/A** - Question & Answer (new, simple format)

## 📋 Steps to Complete Setup:

### 1. Run Database Migrations

Go to **Supabase Dashboard** → **SQL Editor** and run these files in order:

#### A. Add Flashcard Types Column
```sql
-- File: C:\Users\tcs91\Desktop\Project\supabase\add_flashcard_types.sql
```
This adds the `type` column and makes MCQ fields optional for Q/A type.

#### B. Update Approval Default
```sql
-- File: C:\Users\tcs91\Desktop\Project\supabase\update_flashcard_approval.sql
```
This makes new flashcards require admin approval (sets `is_approved` default to `false`).

#### C. Add Admin Policies
```sql
-- File: C:\Users\tcs91\Desktop\Project\supabase\admin_policies.sql
```
This gives admins permission to approve/delete any flashcard.

### 2. Test the Features

#### As Normal User:
1. Go to **Community Flashcards**
2. Click **Create Flashcard**
3. Choose between **MCQ** or **Q/A** type
4. Fill in the form and submit
5. Flashcard will be **pending approval** (won't appear in View Flashcards yet)

#### As Admin (pydeckofficial@gmail.com):
1. Login as admin
2. Go to **Profile** → **Admin Panel** (you'll see this button)
3. Click **Pending tab** to see unapproved flashcards
4. Click **✓ Approve** or **✗ Delete**
5. Approved flashcards will now appear in Community

### 3. How Each Type Displays

**MCQ Type:**
- Shows with 3D flip animation
- Front: Question + 4 options
- Back: Result + explanation
- Swipe right for next

**Q/A Type:**
- Simple card (no flip)
- Question at top
- Answer below
- Button to next question

## ✅ Verification Checklist

- [ ] Database migrations ran successfully
- [ ] Can create MCQ flashcards
- [ ] Can create Q/A flashcards
- [ ] New flashcards don't appear without approval
- [ ] Admin can see pending flashcards
- [ ] Admin can approve flashcards
- [ ] Admin can delete flashcards
- [ ] Approved flashcards appear in Community
- [ ] MCQ cards show 3D flip
- [ ] Q/A cards show simple format

## 🐛 Troubleshooting

**Flashcards still appear without approval?**
- Make sure you ran `update_flashcard_approval.sql`
- Hard refresh browser (Ctrl+Shift+R)

**Delete button doesn't work?**
- Make sure you ran `admin_policies.sql`
- Verify you're logged in as admin

**Type selector not showing?**
- Check browser console for errors
- Refresh the page

## 📝 Notes

- Existing flashcards are automatically set to MCQ type
- Admin account: `pydeckofficial@gmail.com`
- Admin panel only visible to admins
- Q/A type uses the `explanation` field for the answer

---

**Need help?** Check the code in:
- Frontend: `CreateFlashcardModal.jsx`, `CommunityFlashcards.jsx`, `AdminPanel.jsx`
- Backend: SQL files in `supabase/` folder
