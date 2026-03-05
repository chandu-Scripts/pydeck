import os
from dotenv import load_dotenv

# Load environment variables from .env file (for local development)
load_dotenv()

# Supabase configuration - use environment variables
SUPABASE_URL = os.getenv("SUPABASE_URL", "your_supabase_url_here")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY", "your_service_key_here")
SUPABASE_ANON_KEY = os.getenv("SUPABASE_ANON_KEY", "your_anon_key_here")

GMAIL_USER = os.getenv("GMAIL_USER", "")
GMAIL_APP_PASSWORD = os.getenv("GMAIL_APP_PASSWORD", "")

FRONTEND_URL = os.getenv("FRONTEND_URL", "https://pydeck.vercel.app")
