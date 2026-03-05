import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from db import supabase
from config import GMAIL_USER, GMAIL_APP_PASSWORD, FRONTEND_URL

router = APIRouter()


class AnnouncementRequest(BaseModel):
    title: str
    message: str


@router.post("/send-update")
async def send_update(req: AnnouncementRequest):
    title = req.title.strip()
    message = req.message.strip()

    if not title or not message:
        raise HTTPException(status_code=400, detail="Title and message are required")

    # Fetch all active non-guest users with emails
    result = supabase.table('profiles') \
        .select('email') \
        .neq('role', 'guest') \
        .eq('status', 'active') \
        .not_.is_('email', 'null') \
        .execute()

    emails = [row['email'] for row in (result.data or []) if row.get('email')]

    if not emails:
        return {"sent": 0}

    html_body = f"""
    <div style="font-family: Arial, sans-serif; max-width: 480px; margin: 0 auto; padding: 32px; background: #060a13; border-radius: 16px;">
        <h2 style="color: #22d3ee; margin-bottom: 4px; font-size: 24px;">PyDeck</h2>
        <p style="color: #64748b; font-size: 13px; margin-top: 0; margin-bottom: 24px;">Python Learning Platform</p>
        <h3 style="color: #ffffff; font-size: 20px; margin-bottom: 12px;">{title}</h3>
        <p style="color: #94a3b8; line-height: 1.6; font-size: 15px;">{message}</p>
        <div style="margin-top: 32px; text-align: center;">
            <a href="{FRONTEND_URL}" style="display: inline-block; padding: 12px 28px; background: #22d3ee; color: #060a13; font-weight: bold; border-radius: 10px; text-decoration: none; font-size: 15px;">
                Open PyDeck
            </a>
        </div>
        <p style="color: #334155; font-size: 12px; margin-top: 32px; text-align: center;">
            You're receiving this because you have a PyDeck account.
        </p>
    </div>
    """
    text_body = f"{title}\n\n{message}\n\nOpen PyDeck to learn more."

    sent = 0
    try:
        with smtplib.SMTP('smtp.gmail.com', 587) as server:
            server.starttls()
            server.login(GMAIL_USER, GMAIL_APP_PASSWORD)
            for email in emails:
                try:
                    msg = MIMEMultipart('alternative')
                    msg['From'] = f'PyDeck <{GMAIL_USER}>'
                    msg['To'] = email
                    msg['Subject'] = f'PyDeck: {title}'
                    msg.attach(MIMEText(text_body, 'plain'))
                    msg.attach(MIMEText(html_body, 'html'))
                    server.sendmail(GMAIL_USER, email, msg.as_string())
                    sent += 1
                except Exception:
                    pass
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"SMTP error: {str(e)}")

    return {"sent": sent}
