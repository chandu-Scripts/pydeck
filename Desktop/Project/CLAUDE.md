# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PyDeck is a Python learning flashcard application with a React frontend, FastAPI backend, and Supabase database. Users progress through learning paths (Python, MySQL, Flask, Django, NumPy, Pandas), study flashcards, and track their mastery with gamification features (streaks, points, leaderboard).

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
pip install -r requirements.txt
uvicorn main:app --reload          # http://localhost:8000
uvicorn main:app --reload --port 8080
```

API docs at `http://localhost:8000/docs`

## Architecture

### Frontend Architecture

**State Management:**
- `AuthContext` manages authentication state globally (user, profile, loading)
- No Redux/Zustand — React Context + local state only
- Supabase client imported directly in components via `lib/supabase.js`

**Routing Pattern:**
```
/login (public)
/ (ProtectedRoute wrapper)
  ├─ /paths          PathSelection — home page with carousel + motivational tips
  ├─ /paths/:pathId  TopicGrid
  ├─ /topics/:topicId        SubtopicGrid
  ├─ /subtopics/:subtopicId  SubtopicDetail
  ├─ /concept/:subtopicId    Concept
  ├─ /quiz/:subtopicId       MCQFlashcard
  ├─ /study/:topicId         Flashcard
  ├─ /recall         RecallSession
  ├─ /analytics      Analytics + leaderboard
  ├─ /profile        Profile settings + avatar
  ├─ /community      CommunityFlashcards
  └─ /admin          AdminPanel (admin-only)
```

**Data Flow:**
1. Frontend calls Supabase directly for all auth and DB operations
2. Backend API routes exist but are **not used by the frontend** — direct Supabase SDK only
3. Pages fetch data in `useEffect` on mount

**Component Hierarchy:**
- `Layout` wraps all protected routes
- `BottomNav` hidden on `/study/*` routes
- `CardShuffleLoader` used as the loading screen across all pages

### Login Page

The login page (`/login`) has a **3D flip card** design:
- **Front face:** Google OAuth + email/password sign in + guest login
- **Back face:** Email sign-up form (name/email/password) → OTP verification step

Auth functions in `AuthContext`:
- `signInWithGoogle()` — OAuth redirect to `/paths`
- `signInWithEmail(email, password)` — password login
- `signUpWithEmail(email, password, name)` — registers + triggers OTP email
- `verifyEmailOtp(email, token)` — `type: 'signup'` (not 'email')
- `signInAsGuest()` — anonymous session, sets `role: 'guest'` in profiles
- `signOut()`

**Border beam effect on login card:**
Uses CSS `@property --login-beam-angle` animated via `conic-gradient`. The beam sits as an `absolute inset-0` div **outside** the 3D flip `motion.div` to avoid GPU compositing conflicts with `backfaceVisibility: hidden`. Card faces use `padding: 1.5px` so the beam shows through the gap. Inner card uses `background: #060a13` (fully opaque) to prevent center bleed.

### Backend Architecture

All routes in `backend/routes/` follow a consistent pattern: import `supabase` from `db.py`, define `APIRouter`, export for `main.py`. Service key bypasses RLS (backend only).

### Database Schema

```
paths (1) ──> (many) topics (1) ──> (many) subtopics (1) ──> (many) flashcards
                                           │                         │
                                           └──> (many) concepts      │
profiles <──────────────────────────────────────> user_progress <───┘
    ├──> study_sessions
    ├──> community_flashcards (created_by)
    ├──> flashcard_responses
    └──> user_appeals
```

**Key tables:**
- `profiles`: `role` ('user'|'moderator'|'admin'|'guest'), `status` ('active'|'blocked'), `email`
- `flashcards`: requires both `topic_id` (NOT NULL) AND `subtopic_id` for quiz flashcards; `card_type` is 'concept' or 'mcq'
- `user_progress`: status `unseen`→`mastered`|`forgot`; unique on `(user_id, flashcard_id)`; always use `upsert()`
- `study_sessions`: daily aggregates, unique on `(user_id, date)`, date as `YYYY-MM-DD` string
- `community_flashcards`: `is_approved` boolean; `created_by` → `profiles(id)` (not a PostgREST-configured FK)
- `user_appeals`: has two FKs to profiles (`user_id` and `reviewed_by`) — always use `profiles!user_id(...)` in queries

**RLS:** Frontend uses anon key (enforces RLS). Backend uses service key (bypasses RLS). Admins have insert/update/delete on `flashcards` and can update any profile.

### Key Patterns

**Community Flashcards join** — PostgREST can't auto-join `created_by` → `profiles`:
```javascript
const { data: cards } = await supabase.from('community_flashcards').select('*')
const ids = [...new Set(cards.map(c => c.created_by))]
const { data: profiles } = await supabase.from('profiles').select('id, username, avatar_url').in('id', ids)
const result = cards.map(c => ({ ...c, profiles: profiles.find(p => p.id === c.created_by) }))
```

**Streak logic:** No grace period. Streak = 0 if no `study_sessions` entry for today's date; otherwise count back consecutively.

**Flashcard status flow:** `unseen` (no row) → `mastered` → `forgot` → back to `mastered` via recall session.

**Guest accounts:** `signInAnonymously()` creates a profile with `role: 'guest'`. Guest accounts are excluded from all admin counts/lists via `.neq('role', 'guest')`.

### Admin Panel (`/admin`)

Four tabs — Pending, Approved, Users, Appeals. Accessible only to `profile.role === 'admin'`.

- **Block/Unblock:** Updates `profiles.status`. Realtime subscription in `AuthContext` auto-signs-out blocked users instantly.
- **Appeals:** Blocked users submit via `user_appeals`; admin can unblock and mark appeal as reviewed in one action.
- **Making an admin:** `UPDATE profiles SET role = 'admin' WHERE email = 'user@example.com';`

### Home Page (`/paths`)

- **3D cylinder carousel** (`PathCarousel`) — front card drives aurora background color and motivational tip color
- **Rotating motivational tips** — color matches the front carousel card via `pathTipColors` map; tip text changes every 10s, container stays fixed (only text animates)
- `frontCard` state passed from `PathCarousel` via `onFrontCardChange` prop

### Styling

**TailwindCSS 4** — custom theme in `index.css` (`--color-navy-*`, `--color-cyan-*`). No light mode. Mobile-first with `lg:` breakpoints.

**Framer Motion gotchas:**
- Declare all `useMotionValue()` / `useTransform()` at component top level (before any conditionals)
- CSS animations (`animation:` property) on elements with `backfaceVisibility: hidden` break the backface hiding due to GPU compositing — keep animated elements outside the `preserve-3d` context
- 3D flip: keep the `rotateY` wrapper separate from drag/swipe components

**PWA Icons:** `frontend/public/generate-icons.html` — open in browser to generate and download the holo fan card icons (P·Y·D·E·C·K). Downloads go into `frontend/public/` replacing existing PNGs.

### Configuration

Supabase keys are hardcoded in `frontend/src/lib/supabase.js` (anon key) and `backend/config.py` (service key). To refactor: frontend uses `VITE_` prefixed env vars, backend uses `python-dotenv`.

## Database Setup

**Run in order:**
1. `supabase/schema.sql` — core tables
2. `supabase/migration.sql` — subtopics, concepts, MCQ columns, flashcard_responses
3. `supabase/seed.sql` — learning paths + flashcards (fixed UUIDs, re-runnable)
4. `community_flashcards_migration.sql`
5. `add_email_status_to_profiles.sql`
6. `create_user_appeals.sql`
7. `admin_update_profiles_policy.sql`
8. `admin_insert_flashcards_policy.sql`

**Seed data:** `seed_subtopics.sql`, `seed_concepts_full.sql`, `seed_intermediate.sql`, `seed_advanced.sql`, `seed_dsa.sql`

**Guest role constraint:** The `profiles_role_check` constraint must include 'guest':
```sql
ALTER TABLE profiles DROP CONSTRAINT profiles_role_check;
ALTER TABLE profiles ADD CONSTRAINT profiles_role_check
  CHECK (role IN ('user', 'moderator', 'admin', 'guest'));
```

## Common Gotchas

1. **Backface + CSS animation conflict:** Never put a CSS `animation:` on an element that also has `backfaceVisibility: hidden` — the animation creates a compositing layer that breaks backface hiding. Move animated elements outside the 3D context.
2. **OTP verification type:** Use `type: 'signup'` (not `'email'`) when calling `supabase.auth.verifyOtp()` for email sign-up confirmation.
3. **Supabase free tier email limit:** 3 emails/hour on the default email service. Set up a custom SMTP provider (e.g. Resend) for production.
4. **Flashcard creation:** Both `topic_id` (NOT NULL) and `subtopic_id` are required for quiz flashcards.
5. **User appeals FK:** Always specify `.select('*, profiles!user_id(...)')` — the table has two FKs to profiles.
6. **Avatar upload:** Requires Supabase Storage bucket `avatars` with public read policy.
7. **Leaderboard points:** Calculated on-demand (mastered cards × 10), then written back to `profiles.points`.
8. **Existing users with NULL status:** `AuthContext.fetchProfile()` auto-sets `status: 'active'` on login for legacy rows.
9. **Backend routes unused:** All `/api/*` backend routes exist but the frontend calls Supabase directly — don't route new features through the backend unless intentional.
10. **Admin RLS errors:** If admin writes fail, ensure `admin_update_profiles_policy.sql` and `admin_insert_flashcards_policy.sql` have been applied.
