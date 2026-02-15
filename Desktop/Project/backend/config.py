import os
from dotenv import load_dotenv

# Load environment variables from .env file (for local development)
load_dotenv()

# Supabase configuration with fallback to hardcoded values
SUPABASE_URL = os.getenv("SUPABASE_URL", "https://pasfeuzwvfcbhiduzqjr.supabase.co")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY", "sb_secret_m3LlIH13XZ_EWmU5wmNozA_jJQ0Oi8k")
SUPABASE_ANON_KEY = os.getenv("SUPABASE_ANON_KEY", "sb_publishable_lofY5-vb48dCzV00pb3sDQ_yg3gEJ_S")
