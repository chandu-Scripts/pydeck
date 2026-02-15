# 🐍 Backend Deployment Guide (FastAPI)

This guide covers deploying the FastAPI backend for free on Render.com.

**Note:** The frontend currently doesn't use the backend API - it calls Supabase directly. Deploy the backend only if you plan to add custom server logic in the future.

---

## Option 1: Deploy to Render.com (Recommended - FREE)

### Why Render?
- ✅ Free tier with 750 hours/month
- ✅ Auto-deploy from GitHub
- ✅ Free SSL
- ✅ Python/FastAPI support
- ⚠️ Sleeps after 15 minutes of inactivity (wakes up in ~30 seconds on first request)

### Steps:

#### 1. Prepare Backend for Deployment

First, update the backend to use environment variables:

**Create `backend/.env.example`:**
```
SUPABASE_URL=your_supabase_url
SUPABASE_SERVICE_KEY=your_supabase_service_key
PORT=8000
```

**Update `backend/config.py`:**
```python
import os
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL", "https://pasfeuzwvfcbhiduzqjr.supabase.co")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY", "your_service_key_here")
```

**Update `backend/requirements.txt`** (add python-dotenv if missing):
```
fastapi
uvicorn[standard]
supabase
python-dotenv
```

#### 2. Create `render.yaml` (Optional - Infrastructure as Code)

Create `render.yaml` in project root:

```yaml
services:
  - type: web
    name: pydeck-api
    env: python
    region: oregon
    plan: free
    buildCommand: pip install -r backend/requirements.txt
    startCommand: cd backend && uvicorn main:app --host 0.0.0.0 --port $PORT
    envVars:
      - key: SUPABASE_URL
        value: https://pasfeuzwvfcbhiduzqjr.supabase.co
      - key: SUPABASE_SERVICE_KEY
        sync: false  # Will be added manually for security
```

#### 3. Deploy via Render Dashboard

1. **Sign up at [render.com](https://render.com)**

2. **Create New Web Service:**
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Select your repository

3. **Configure Service:**
   ```
   Name: pydeck-api
   Region: Oregon (or closest to you)
   Branch: main
   Root Directory: backend
   Runtime: Python 3
   Build Command: pip install -r requirements.txt
   Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
   Plan: Free
   ```

4. **Add Environment Variables:**
   - Click "Environment"
   - Add:
     ```
     SUPABASE_URL = https://pasfeuzwvfcbhiduzqjr.supabase.co
     SUPABASE_SERVICE_KEY = your_service_key_here
     ```

   **Where to find Service Key:**
   - Supabase Dashboard → Settings → API → `service_role` key

5. **Click "Create Web Service"**
   - Build takes 2-3 minutes
   - You'll get a URL like: `https://pydeck-api.onrender.com`

6. **Test Your API:**
   - Visit: `https://pydeck-api.onrender.com/docs`
   - You should see FastAPI Swagger docs

#### 4. Connect Frontend to Backend (Optional)

If you want to use the backend instead of direct Supabase calls:

**Create `frontend/.env`:**
```
VITE_API_URL=https://pydeck-api.onrender.com
VITE_SUPABASE_URL=https://pasfeuzwvfcbhiduzqjr.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key
```

**Update API calls in frontend** (example):
```javascript
// Instead of:
const { data } = await supabase.from('paths').select('*')

// Use:
const response = await fetch(`${import.meta.env.VITE_API_URL}/api/paths`)
const data = await response.json()
```

---

## Option 2: Deploy to Fly.io (FREE with credit card)

### Why Fly.io?
- ✅ Always-on (doesn't sleep)
- ✅ Global edge network
- ✅ 3 free VMs
- ⚠️ Requires credit card (won't charge on free tier)

### Steps:

1. **Install Fly CLI:**
```bash
# Windows
powershell -Command "iwr https://fly.io/install.ps1 -useb | iex"

# Mac/Linux
curl -L https://fly.io/install.sh | sh
```

2. **Login:**
```bash
fly auth login
```

3. **Launch App:**
```bash
cd backend
fly launch

# Follow prompts:
# - App name: pydeck-api
# - Region: (choose closest)
# - Postgres: No
# - Deploy now: No
```

4. **Update `fly.toml`:**
```toml
app = "pydeck-api"

[build]
  builder = "paketobuildpacks/builder:base"

[[services]]
  http_checks = []
  internal_port = 8000
  protocol = "tcp"

  [[services.ports]]
    force_https = true
    handlers = ["http"]
    port = 80

  [[services.ports]]
    handlers = ["tls", "http"]
    port = 443
```

5. **Set Environment Variables:**
```bash
fly secrets set SUPABASE_URL="https://pasfeuzwvfcbhiduzqjr.supabase.co"
fly secrets set SUPABASE_SERVICE_KEY="your_service_key"
```

6. **Deploy:**
```bash
fly deploy
```

7. **Access:**
```bash
fly open
# Visit: https://pydeck-api.fly.dev/docs
```

---

## Option 3: Deploy to Railway (FREE Trial)

### Why Railway?
- ✅ Very easy setup
- ✅ Auto-deploy from GitHub
- ✅ $5 free credit (lasts ~1 month)
- ⚠️ Becomes paid after trial

### Steps:

1. **Go to [railway.app](https://railway.app)**

2. **Deploy from GitHub:**
   - Click "Start a New Project"
   - Select "Deploy from GitHub repo"
   - Choose your repository
   - Select "backend" folder

3. **Add Environment Variables:**
   ```
   SUPABASE_URL=https://pasfeuzwvfcbhiduzqjr.supabase.co
   SUPABASE_SERVICE_KEY=your_service_key
   PORT=8000
   ```

4. **Add Start Command:**
   - Settings → Start Command:
   ```
   uvicorn main:app --host 0.0.0.0 --port $PORT
   ```

5. **Deploy:**
   - Railway auto-deploys
   - Get URL from dashboard

---

## Comparison Table

| Platform | Free Tier | Always On? | Credit Card? | Limits |
|----------|-----------|------------|--------------|--------|
| **Render** | ✅ Yes | ❌ Sleeps after 15min | ❌ No | 750 hrs/month |
| **Fly.io** | ✅ Yes | ✅ Yes | ⚠️ Required | 3 free VMs |
| **Railway** | ⚠️ Trial | ✅ Yes | ⚠️ Required | $5 credit |
| **Vercel** | ❌ No* | ✅ Yes | ❌ No | Serverless only |
| **Heroku** | ❌ No | - | - | No free tier |

*Vercel supports serverless Python but not ideal for FastAPI

---

## Enable CORS (Required)

If frontend will call backend, update `backend/main.py`:

```python
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",  # Local development
        "https://your-app.vercel.app",  # Production frontend
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## Troubleshooting

### Build Fails

**Error:** `ModuleNotFoundError`
- Fix: Ensure all imports are in `requirements.txt`
- Run: `pip freeze > requirements.txt`

### API Returns 502/503

**Error:** `Service unavailable`
- Fix (Render): Wait 30 seconds for service to wake up from sleep
- Fix: Check logs for errors

### CORS Errors

**Error:** `CORS policy blocked`
- Fix: Add your Vercel URL to CORS allow_origins
- Update `main.py` with frontend URL

---

## Cost Breakdown

### Render Free Tier
- 750 hours/month = ~31 days if always on
- OR unlimited if traffic < 750 hours
- Sleeps after 15min inactivity
- Wakes in ~30 seconds

### Fly.io Free Tier
- 3 shared-cpu-1x VMs (256MB RAM each)
- 160GB bandwidth/month
- Always on

---

## Recommended Setup

**For PyDeck:**

1. **Frontend:** Vercel (free)
2. **Backend:** Render (free) - only if you need custom server logic
3. **Database:** Supabase (free)

**Total Cost:** $0/month 🎉

---

## Keep Backend Awake (Optional)

If using Render and want to prevent sleeping:

**Option 1: Cron Job (UptimeRobot)**
- Sign up at [uptimerobot.com](https://uptimerobot.com)
- Add monitor for your Render URL
- Ping interval: 5 minutes
- Free tier: 50 monitors

**Option 2: GitHub Actions**
Create `.github/workflows/keep-alive.yml`:

```yaml
name: Keep Backend Alive

on:
  schedule:
    - cron: '*/14 * * * *'  # Every 14 minutes

jobs:
  ping:
    runs-on: ubuntu-latest
    steps:
      - name: Ping API
        run: curl https://pydeck-api.onrender.com/docs
```

---

## Next Steps

1. Choose deployment platform
2. Deploy backend
3. Test API at `/docs` endpoint
4. (Optional) Update frontend to use backend instead of direct Supabase calls
5. Add backend URL to Vercel environment variables

**Questions?** Check Render/Fly.io documentation or Discord communities!
