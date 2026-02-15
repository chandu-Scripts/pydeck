# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PyDeck is a Python learning flashcard application with a React frontend, FastAPI backend, and Supabase database. Users progress through learning paths (Python Basics → Intermediate → Advanced → DSA), study flashcards, and track their mastery with gamification features (streaks, points, leaderboard).

## Development Commands

### Frontend (React + Vite)
```bash
cd frontend
npm install              # Install dependencies
npm run dev             # Start dev server (http://localhost:5173)
npm run build           # Build for production
npm run lint            # Run ESLint
npm run preview         # Preview production build
```

### Backend (FastAPI)
```bash
cd backend
pip install -r requirements.txt    # Install dependencies
uvicorn main:app --reload          # Start dev server (http://localhost:8000)
uvicorn main:app --reload --port 8080  # Use custom port
```

Access API docs at `http://localhost:8000/docs` (Swagger UI)

## Architecture

### Frontend Architecture

**State Management:**
- `AuthContext` manages authentication state globally (user, profile, loading)
- No Redux/Zustand - uses React Context + local state
- Supabase client imported directly in components via `lib/supabase.js`

**Routing Pattern:**
```
/login (public)
/ (ProtectedRoute wrapper)
  ├─ /paths (PathSelection - home page with learning paths)
  ├─ /paths/:pathId (TopicGrid - topics within a path)
  ├─ /topics/:topicId (SubtopicGrid - subtopics within a topic)
  ├─ /subtopics/:subtopicId (SubtopicDetail - flashcard/quiz selection)
  ├─ /concept/:subtopicId (Concept - concept learning flashcards)
  ├─ /quiz/:subtopicId (MCQFlashcard - MCQ quiz with 3D flip)
  ├─ /study/:topicId (Flashcard - original flashcard study)
  ├─ /recall (RecallSession - practice forgot cards)
  ├─ /analytics (Analytics - stats and leaderboard)
  ├─ /profile (Profile - user settings and avatar)
  ├─ /community (CommunityFlashcards - user-generated flashcards)
  └─ /admin (AdminPanel - admin-only content management)
```

**Data Flow:**
1. Frontend calls Supabase directly for auth and database operations
2. Backend API (`/api/paths`, `/api/topics`, etc.) is implemented but **not currently used by frontend**
3. All CRUD operations happen via Supabase client SDK in React components

**Component Hierarchy:**
- `Layout` wraps all protected routes, includes gradient background
- `BottomNav` conditionally renders (hidden on `/study/*` routes)
- Pages fetch data in `useEffect` hooks on mount

### Backend Architecture

**API Modules:**
All routes in `backend/routes/` follow consistent pattern:
- Import `supabase` from `db.py`
- Define APIRouter
- Export router for inclusion in `main.py`

**Database Access:**
- Direct Supabase queries via `supabase.table()` methods
- No ORM or database abstraction layer
- Service key allows bypassing RLS (used in backend only)

### Database Schema

**Key Relationships:**
```
paths (1) ──> (many) topics (1) ──> (many) subtopics (1) ──> (many) flashcards
                                           │                         │
                                           ├──> (many) concepts      │
                                           │                         │
profiles <─────────────────────────────────┴─> user_progress <──────┘
    │
    ├──> study_sessions
    ├──> community_flashcards (created_by)
    ├──> flashcard_responses
    └──> user_appeals
```

**Important Tables:**
- `subtopics`: Subdivisions of topics
  - Foreign key to `topics(id)`
  - Flashcards are linked to subtopics, not topics directly

- `concepts`: Learning content for each subtopic
  - Contains title, content, code_examples
  - Displayed in `/concept/:subtopicId` page

- `flashcards`: Official flashcards created by admins
  - Required: `topic_id` (NOT NULL), `question`, `answer`
  - Optional: `subtopic_id` (links to quiz), `explanation`
  - MCQ fields: `option_a`, `option_b`, `option_c`, `option_d`, `correct_option`
  - `card_type`: 'concept' or 'mcq'
  - Both topic_id AND subtopic_id must be provided for quiz flashcards

- `user_progress`: Tracks flashcard status (`unseen`, `mastered`, `forgot`) per user
  - Unique constraint on `(user_id, flashcard_id)`
  - Use `upsert()` when updating progress

- `study_sessions`: Daily aggregates (cards_studied, cards_mastered)
  - Unique constraint on `(user_id, date)`
  - Updated after each flashcard interaction

- `community_flashcards`: User-generated MCQ flashcards
  - Foreign key to `profiles(id)` for creator tracking
  - Contains: question, 4 options (a-d), correct_answer, explanation
  - `is_approved` boolean for admin moderation

- `flashcard_responses`: Tracks MCQ answers for analytics
  - Records user's selected option and whether it was correct
  - Used to display "How others answered" bar chart

- `profiles`: User profiles with additional fields
  - `role`: 'user', 'moderator', or 'admin'
  - `status`: 'active' or 'blocked'
  - `email`: Stored for admin user management
  - Auto-populated from auth.users on login

- `user_appeals`: Appeal system for blocked users
  - `user_id`: Foreign key to profiles (specify as `profiles!user_id` in queries)
  - `message`: Appeal text (max 500 chars in UI)
  - `status`: 'pending' or 'reviewed'
  - `reviewed_by`: Admin who approved/denied

**RLS Policies:**
- All tables have RLS enabled
- Users can only view/modify their own progress and sessions
- Paths, topics, subtopics, flashcards, concepts are readable by all authenticated users
- Frontend uses anon key, backend uses service key
- **Admin-specific policies:**
  - Admins can INSERT, UPDATE, DELETE on `flashcards` table
  - Admins can UPDATE any user's profile (for blocking/unblocking)
  - Admins can view all `user_appeals` with status='pending'
  - Users can INSERT their own appeals
  - When querying appeals with profiles, use explicit FK: `profiles!user_id(...)`

### Key Patterns

**Progress Calculation:**
When displaying topic/path progress, calculate from user_progress:
```javascript
// Get all flashcard IDs for topic
const cards = await supabase.from('flashcards').select('id').eq('topic_id', topicId)
// Get user's progress for those cards
const progress = await supabase.from('user_progress').select('*').eq('user_id', userId)
// Calculate: mastered / total
```

**Streak Logic:**
Streaks have **no grace period**. User must study TODAY to have any streak count:
1. Check if `study_sessions` has entry for today's date
2. If yes, count backward consecutively (yesterday, day before, etc.)
3. If no, streak is 0

**Session Tracking:**
After marking a flashcard as mastered/recall:
1. Upsert `user_progress` with new status
2. Query today's `study_sessions` record
3. If exists, increment counts; if not, insert new record

**Flashcard Status Flow:**
- New cards: no entry in `user_progress` (treated as `unseen`)
- User marks "Mastered": status → `mastered`
- User marks "Recall": status → `forgot`
- Forgot cards appear in `/recall` session
- In recall session, can be re-mastered (status → `mastered`)

**Community Flashcards Pattern:**
Since `community_flashcards.created_by` references `profiles(id)` (not a direct PostgREST foreign key):
1. Fetch flashcards: `supabase.from('community_flashcards').select('*')`
2. Get unique creator IDs from results
3. Fetch profiles separately: `supabase.from('profiles').select('id, username, avatar_url').in('id', creatorIds)`
4. Join in JavaScript: `cards.map(card => ({ ...card, profiles: profiles.find(p => p.id === card.created_by) }))`

This avoids PostgREST join syntax errors when foreign key relationships aren't directly configured.

### Admin System

**Admin Panel (`/admin`):**
- **Access Control:** Only users with `profile.role === 'admin'` can access
- **Tabs:**
  - **Pending:** Community flashcards awaiting approval
  - **Approved:** All approved community flashcards
  - **Users:** User management (view all users, change roles, block/unblock)
  - **Appeals:** View and process unblock requests from blocked users
  - **Quiz:** Create official MCQ flashcards with cascading dropdowns

**Quiz Creation Flow:**
1. Select Learning Path (from `paths` table)
2. Select Topic (filtered by selected path from `topics` table)
3. Select Subtopic (filtered by selected topic from `subtopics` table)
4. Fill MCQ form: question, 4 options, correct answer, explanation
5. Submit → Inserts into `flashcards` with BOTH `topic_id` and `subtopic_id`
6. Flashcard appears in `/quiz/:subtopicId` for that subtopic

**Block/Unblock System:**
1. Admin clicks "Block" on user in admin panel
2. User's `status` updated to 'blocked' in `profiles` table
3. **Realtime subscription** in AuthContext detects profile change
4. Blocked user is instantly signed out
5. On next login attempt, blocked user sees `BlockedUserScreen`
6. User can send appeal message (max 500 chars) via `user_appeals` table
7. Admin sees appeal in Appeals tab, can unblock user
8. Unblocking updates both `profiles.status='active'` and `user_appeals.status='reviewed'`

**Admin Controls in Quiz Page:**
When admin views `/quiz/:subtopicId`, they see additional buttons:
- **Edit (pencil icon):** Opens modal to edit current flashcard in place
- **Delete (trash icon):** Removes flashcard after confirmation
- Perfect for quick fixes, removing duplicates, or correcting errors without leaving quiz

**Making Users Admin:**
Run SQL in Supabase: `UPDATE profiles SET role = 'admin' WHERE email = 'user@example.com';`
Or use `supabase/make_admin.sql` script.

### Configuration

**Environment Variables:**
Currently hardcoded in `backend/config.py` and `frontend/src/lib/supabase.js`. When refactoring:
- Backend: Use `.env` file with `python-dotenv`
- Frontend: Use `.env` file with `VITE_` prefix (Vite convention)

**Supabase Keys:**
- **Anon Key** (frontend): Safe for client-side, enforces RLS
- **Service Key** (backend): Bypasses RLS, server-side only
- Avatar uploads use Supabase Storage `avatars` bucket

### Styling & Animations

**TailwindCSS:**
- **TailwindCSS 4** with custom theme in `index.css`
- Custom colors: navy-900 through navy-500, cyan-400/500/600
- Dark theme (no light mode)
- Responsive breakpoint: `lg:` for desktop layouts
- Mobile-first design with bottom nav, desktop has sidebar

**Framer Motion:**
- 3D flip cards: Use `transform: rotateY()` with `transformStyle: 'preserve-3d'` and `backfaceVisibility: 'hidden'`
- Separate flip transform from drag transform to avoid conflicts
- Swipe gestures: `useMotionValue(0)` for x position, `useTransform()` for rotation/opacity
- Declare all motion values at top level (React Hooks ordering)
- Stagger animations imported from `utils/animations.js`

**Brand Icons:**
- Uses `react-icons/si` for tech logos (SiPython, SiMysql, SiFlask, SiDjango)
- Path icons configured in `PathSelection.jsx` with matching color schemes

### Testing & Linting

**ESLint Config:**
- Ignores unused vars starting with uppercase or underscore (`varsIgnorePattern`)
- React Hooks plugin with recommended rules
- React Refresh plugin for HMR

**No Test Suite:**
No testing framework is currently configured (no Jest, Vitest, pytest).

## Database Setup

**Initial Schema:**
1. Run `supabase/schema.sql` - Creates core tables (paths, topics, flashcards, profiles, user_progress, study_sessions)
2. Run `supabase/migration.sql` - Adds subtopics, concepts, MCQ columns to flashcards, flashcard_responses
3. Run `supabase/seed.sql` - Populates with learning paths and flashcards (uses fixed UUIDs, can be re-run safely)

**Feature Migrations (run in order):**
1. `community_flashcards_migration.sql` - Community-generated flashcards
2. `add_email_status_to_profiles.sql` - Adds email and status columns to profiles
3. `create_user_appeals.sql` - Appeal system for blocked users
4. `admin_update_profiles_policy.sql` - RLS policy for admins to update any profile
5. `admin_insert_flashcards_policy.sql` - RLS policies for admins to create/edit/delete flashcards

**Seed Data Files:**
- `seed_subtopics.sql` - Subtopics for all topics
- `seed_concepts_full.sql` - Concept content for subtopics
- `seed_intermediate.sql`, `seed_advanced.sql`, `seed_dsa.sql` - Additional flashcards

## Common Gotchas

1. **Avatar Upload:** Requires Supabase Storage bucket `avatars` to exist with proper policies
2. **Leaderboard:** Points are calculated on-demand (mastered cards × 10), then updated in profiles table
3. **Date Handling:** Study sessions use ISO date strings (`YYYY-MM-DD`), not timestamps
4. **Phone OTP:** UI is present in Login page but functionality is disabled (Google OAuth only)
5. **Backend API Routes:** Exist but unused by frontend - direct Supabase calls instead
6. **React Hooks Ordering:** When using Framer Motion, declare all `useMotionValue()` and `useTransform()` at component top level before conditional logic to avoid "Hooks changed order" errors
7. **3D Card Flips:** Keep flip transform wrapper (`rotateY`) separate from drag motion component to prevent transform conflicts
8. **Community Flashcards Join:** Cannot use PostgREST join syntax for `profiles` - fetch separately and join in JavaScript (see Community Flashcards Pattern above)
9. **Admin RLS Errors:** If admin actions fail with RLS errors, ensure all admin policies are applied (`admin_update_profiles_policy.sql`, `admin_insert_flashcards_policy.sql`)
10. **Flashcard Creation:** When creating quiz flashcards, BOTH `topic_id` (NOT NULL) and `subtopic_id` are required, not just subtopic_id
11. **User Appeals Foreign Key:** When fetching appeals with user profiles, specify FK explicitly: `.select('*, profiles!user_id(id, username, email, avatar_url)')` - the table has two FKs to profiles (user_id and reviewed_by)
12. **Blocked User Detection:** Blocked status is detected via realtime subscription in AuthContext - user is auto-signed out when status changes to 'blocked'
13. **Existing User Status:** Users created before status column was added may have NULL status - AuthContext auto-sets to 'active' on login
