# 🚀 Free Deployment Guide for PyDeck

This guide will help you deploy PyDeck completely **FREE** using Vercel + Supabase.

## Prerequisites

- GitHub account
- Vercel account (free - sign up at [vercel.com](https://vercel.com))
- Supabase project (already set up)

---

## Step 1: Push Code to GitHub

1. **Initialize Git repository (if not already done):**
```bash
git init
git add .
git commit -m "Initial commit"
```

2. **Create a new repository on GitHub:**
   - Go to [github.com/new](https://github.com/new)
   - Name it (e.g., "pydeck")
   - Don't initialize with README (you already have code)
   - Click "Create repository"

3. **Push your code:**
```bash
git remote add origin https://github.com/YOUR_USERNAME/pydeck.git
git branch -M main
git push -u origin main
```

---

## Step 2: Deploy Frontend to Vercel

### Option A: Deploy via Vercel Dashboard (Easiest)

1. **Go to [vercel.com](https://vercel.com) and sign in**

2. **Click "Add New" → "Project"**

3. **Import your GitHub repository:**
   - Select your "pydeck" repository
   - Click "Import"

4. **Configure Project:**
   - **Framework Preset:** Vite
   - **Root Directory:** `frontend`
   - **Build Command:** `npm run build` (auto-detected)
   - **Output Directory:** `dist` (auto-detected)

5. **Add Environment Variables:**
   Click "Environment Variables" and add:
   ```
   VITE_SUPABASE_URL = https://pasfeuzwvfcbhiduzqjr.supabase.co
   VITE_SUPABASE_ANON_KEY = sb_publishable_lofY5-vb48dCzV00pb3sDQ_yg3gEJ_S
   ```
   *(Use your actual Supabase URL and anon key)*

6. **Click "Deploy"**
   - Vercel will build and deploy your app
   - Wait 2-3 minutes
   - You'll get a live URL like: `https://pydeck.vercel.app`

### Option B: Deploy via CLI

```bash
# Install Vercel CLI
npm install -g vercel

# Login to Vercel
vercel login

# Deploy from frontend directory
cd frontend
vercel

# Follow prompts:
# - Set up and deploy? Yes
# - Which scope? (Your account)
# - Link to existing project? No
# - Project name? pydeck
# - Directory? ./
# - Override settings? No

# Add environment variables
vercel env add VITE_SUPABASE_URL
vercel env add VITE_SUPABASE_ANON_KEY

# Deploy to production
vercel --prod
```

---

## Step 3: Configure Supabase for Deployed URL

1. **Go to your Supabase Dashboard**
   - Navigate to: Authentication → URL Configuration

2. **Add Vercel URL to Redirect URLs:**
   - Add: `https://your-app.vercel.app/**`
   - Add: `https://your-app.vercel.app/paths`

3. **Update Site URL:**
   - Set to: `https://your-app.vercel.app`

---

## Step 4: Test Your Deployment

1. Visit your Vercel URL
2. Try logging in with Google
3. Create a flashcard in Community
4. Test admin panel (if you're admin)
5. Check if all features work

---

## Alternative Free Hosting Options

### Frontend Alternatives:

1. **Netlify** (Similar to Vercel)
   - Drag & drop deployment
   - Auto-deploy from Git
   - Free SSL + CDN
   - [netlify.com](https://netlify.com)

2. **Cloudflare Pages**
   - Unlimited bandwidth
   - Global CDN
   - Free builds
   - [pages.cloudflare.com](https://pages.cloudflare.com)

3. **GitHub Pages**
   - Free static hosting
   - Custom domain support
   - Requires more configuration
   - [pages.github.com](https://pages.github.com)

---

## Optional: Deploy Backend API

*Note: The frontend currently doesn't use the backend API, so this is optional.*

### Deploy to Render (Free Tier)

1. **Go to [render.com](https://render.com) and sign up**

2. **Create New Web Service:**
   - Connect your GitHub repository
   - Select "pydeck" repo
   - Click "New Web Service"

3. **Configure Service:**
   - **Name:** pydeck-api
   - **Root Directory:** `backend`
   - **Runtime:** Python 3
   - **Build Command:** `pip install -r requirements.txt`
   - **Start Command:** `uvicorn main:app --host 0.0.0.0 --port $PORT`
   - **Plan:** Free

4. **Add Environment Variables:**
   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_KEY=your_supabase_service_key
   ```

5. **Click "Create Web Service"**
   - You'll get a URL like: `https://pydeck-api.onrender.com`
   - Free tier sleeps after 15 mins of inactivity

---

## Troubleshooting

### Build Fails on Vercel

**Error:** `Module not found`
- **Fix:** Make sure all dependencies are in `package.json`
- Run: `npm install` locally first

**Error:** `Environment variable not found`
- **Fix:** Add environment variables in Vercel dashboard
- Go to Project Settings → Environment Variables

### Google OAuth Not Working

**Error:** `redirect_uri_mismatch`
- **Fix:** Add your Vercel URL to Supabase redirect URLs
- Supabase Dashboard → Authentication → URL Configuration

### App Loads But Shows Errors

**Error:** `Failed to fetch`
- **Fix:** Check Supabase environment variables are correct
- Verify CORS settings in Supabase (should allow your domain)

### Free Tier Limits

**Vercel:**
- 100 GB bandwidth/month
- 100 builds/month
- 6000 build minutes/month

**Supabase:**
- 500 MB database
- 1 GB file storage
- 2 GB bandwidth
- 50,000 monthly active users

**Render (if using backend):**
- 750 hours/month
- 512 MB RAM
- Sleeps after 15 mins inactivity

---

## Updating Your Deployed App

### Auto-Deploy (Recommended)

Vercel automatically deploys when you push to GitHub:

```bash
git add .
git commit -m "Update feature"
git push origin main
```

Vercel will automatically build and deploy the changes!

### Manual Deploy

```bash
cd frontend
vercel --prod
```

---

## Custom Domain (Optional)

### Add Custom Domain to Vercel

1. Buy a domain (Namecheap, Google Domains, Cloudflare)
2. Go to Vercel Project → Settings → Domains
3. Add your domain (e.g., `pydeck.com`)
4. Update DNS records as shown by Vercel
5. Wait for DNS propagation (5-48 hours)
6. Update Supabase redirect URLs with new domain

---

## 🎉 Congratulations!

Your PyDeck app is now live and accessible worldwide for **FREE**!

**Your Stack:**
- ✅ Frontend: Vercel (Free tier)
- ✅ Database: Supabase (Free tier)
- ✅ Authentication: Supabase Auth (Free)
- ✅ Storage: Supabase Storage (Free)
- ✅ SSL: Automatic (Free)
- ✅ CDN: Global (Free)

**Share your app:** `https://your-app.vercel.app`
