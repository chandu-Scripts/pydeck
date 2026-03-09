import random
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime, timedelta, timezone
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from db import supabase
from config import GMAIL_USER, GMAIL_APP_PASSWORD

router = APIRouter()


class SendOtpRequest(BaseModel):
    email: str


class VerifyOtpRequest(BaseModel):
    email: str
    code: str


class CreateAccountRequest(BaseModel):
    email: str
    code: str
    password: str
    name: str


@router.post("/check-email")
async def check_email(req: SendOtpRequest):
    """Check if email is already registered."""
    email = req.email.strip().lower()
    result = supabase.table('profiles').select('id').eq('email', email).execute()
    return {"exists": len(result.data) > 0}


@router.post("/send")
async def send_otp(req: SendOtpRequest):
    email = req.email.strip().lower()

    # Generate 6-digit OTP
    code = str(random.randint(100000, 999999))
    expires_at = (datetime.now(timezone.utc) + timedelta(minutes=10)).isoformat()

    # Remove old OTPs for this email
    supabase.table('otp_codes').delete().eq('email', email).execute()

    # Store new OTP
    supabase.table('otp_codes').insert({
        'email': email,
        'code': code,
        'expires_at': expires_at
    }).execute()

    # Send email via Gmail SMTP
    try:
        msg = MIMEMultipart('alternative')
        msg['From'] = f'PyDeck <{GMAIL_USER}>'
        msg['To'] = email
        msg['Subject'] = 'Your PyDeck sign-in code'

        text = f"Your PyDeck sign-in code is: {code}\n\nThis code expires in 10 minutes."
        html = f"""
        <div style="font-family: Arial, sans-serif; max-width: 420px; margin: 0 auto; padding: 32px; background: #060a13; border-radius: 16px;">
            <h2 style="color: #22d3ee; margin-bottom: 8px;">PyDeck</h2>
            <p style="color: #94a3b8;">Your sign-in verification code is:</p>
            <div style="font-size: 40px; font-weight: bold; letter-spacing: 12px; color: #22d3ee;
                        padding: 24px; background: #0f172a; border-radius: 12px;
                        text-align: center; margin: 16px 0;">
                {code}
            </div>
            <p style="color: #64748b; font-size: 13px;">This code expires in 10 minutes. Do not share it with anyone.</p>
        </div>
        """

        msg.attach(MIMEText(text, 'plain'))
        msg.attach(MIMEText(html, 'html'))

        with smtplib.SMTP('smtp.gmail.com', 587) as server:
            server.starttls()
            server.login(GMAIL_USER, GMAIL_APP_PASSWORD)
            server.sendmail(GMAIL_USER, email, msg.as_string())

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to send email: {str(e)}")

    return {"message": "OTP sent successfully"}


@router.post("/verify")
async def verify_otp(req: VerifyOtpRequest):
    email = req.email.strip().lower()

    # Find OTP
    result = supabase.table('otp_codes') \
        .select('*') \
        .eq('email', email) \
        .eq('code', req.code.strip()) \
        .execute()

    if not result.data:
        raise HTTPException(status_code=400, detail="Invalid verification code")

    otp_record = result.data[0]

    # Check expiry
    expires_at_str = otp_record['expires_at']
    if expires_at_str.endswith('Z'):
        expires_at_str = expires_at_str[:-1] + '+00:00'
    expires_at = datetime.fromisoformat(expires_at_str)
    if datetime.now(timezone.utc) > expires_at:
        supabase.table('otp_codes').delete().eq('email', email).execute()
        raise HTTPException(status_code=400, detail="Code has expired. Request a new one.")

    # Delete OTP (one-time use)
    supabase.table('otp_codes').delete().eq('email', email).execute()

    # Generate Supabase magic link token
    try:
        response = supabase.auth.admin.generate_link({
            "type": "magiclink",
            "email": email,
        })
        hashed_token = response.properties.hashed_token
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Auth error: {str(e)}")

    return {"hashed_token": hashed_token}


@router.post("/verify-only")
async def verify_otp_only(req: VerifyOtpRequest):
    """Verify OTP without creating a session — used for sign-up flow."""
    email = req.email.strip().lower()

    result = supabase.table('otp_codes') \
        .select('*') \
        .eq('email', email) \
        .eq('code', req.code.strip()) \
        .execute()

    if not result.data:
        raise HTTPException(status_code=400, detail="Invalid verification code")

    otp_record = result.data[0]

    expires_at_str = otp_record['expires_at']
    if expires_at_str.endswith('Z'):
        expires_at_str = expires_at_str[:-1] + '+00:00'
    expires_at = datetime.fromisoformat(expires_at_str)
    if datetime.now(timezone.utc) > expires_at:
        supabase.table('otp_codes').delete().eq('email', email).execute()
        raise HTTPException(status_code=400, detail="Code has expired. Request a new one.")

    supabase.table('otp_codes').delete().eq('email', email).execute()

    return {"verified": True}


@router.post("/create-account")
async def create_account(req: CreateAccountRequest):
    """Verify OTP, create account, and return sign-in token — all in one step."""
    email = req.email.strip().lower()

    # 1. Verify OTP
    result = supabase.table('otp_codes') \
        .select('*') \
        .eq('email', email) \
        .eq('code', req.code.strip()) \
        .execute()

    if not result.data:
        raise HTTPException(status_code=400, detail="Invalid verification code")

    otp_record = result.data[0]
    expires_at_str = otp_record['expires_at']
    if expires_at_str.endswith('Z'):
        expires_at_str = expires_at_str[:-1] + '+00:00'
    expires_at = datetime.fromisoformat(expires_at_str)
    if datetime.now(timezone.utc) > expires_at:
        supabase.table('otp_codes').delete().eq('email', email).execute()
        raise HTTPException(status_code=400, detail="Code has expired. Request a new one.")

    supabase.table('otp_codes').delete().eq('email', email).execute()

    # 2. Create user with admin API (email already verified)
    new_user_id = None
    try:
        user_response = supabase.auth.admin.create_user({
            "email": email,
            "password": req.password,
            "user_metadata": {"full_name": req.name},
            "email_confirm": True,
        })
        new_user_id = user_response.user.id
    except Exception:
        # User already exists — that's fine, continue to sign in
        pass

    # 3. Create profile with correct name if new user
    if new_user_id:
        try:
            existing = supabase.table('profiles').select('id').eq('id', new_user_id).execute()
            if not existing.data:
                supabase.table('profiles').insert({
                    'id': new_user_id,
                    'username': req.name,
                    'email': email,
                    'status': 'active',
                    'role': 'user',
                    'streak': 0,
                    'points': 0,
                }).execute()
        except Exception:
            pass

    return {"ok": True}
