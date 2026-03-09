import json
import os
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from db import supabase

router = APIRouter()

VAPID_PRIVATE_KEY = os.getenv('VAPID_PRIVATE_KEY')
VAPID_CLAIMS = {"sub": "mailto:admin@pydeck.app"}


class SubscriptionRequest(BaseModel):
    user_id: str
    subscription: dict


class PushRequest(BaseModel):
    title: str
    body: str


@router.post("/subscribe")
async def save_subscription(req: SubscriptionRequest):
    supabase.table('push_subscriptions').upsert(
        {'user_id': req.user_id, 'subscription': req.subscription},
        on_conflict='user_id'
    ).execute()
    return {"ok": True}


@router.post("/send")
async def send_push(req: PushRequest):
    try:
        from pywebpush import webpush, WebPushException
    except ImportError:
        raise HTTPException(status_code=500, detail="pywebpush not installed")

    if not VAPID_PRIVATE_KEY:
        raise HTTPException(status_code=500, detail="VAPID_PRIVATE_KEY not set")

    result = supabase.table('push_subscriptions').select('subscription').execute()
    subs = result.data or []

    sent = 0
    for row in subs:
        try:
            webpush(
                subscription_info=row['subscription'],
                data=json.dumps({"title": req.title, "body": req.body}),
                vapid_private_key=VAPID_PRIVATE_KEY,
                vapid_claims=VAPID_CLAIMS,
            )
            sent += 1
        except WebPushException:
            pass

    return {"sent": sent}


async def send_scheduled_reminders():
    """Called every minute by APScheduler — sends push to users whose reminder time matches now (UTC)."""
    try:
        from pywebpush import webpush, WebPushException
    except ImportError:
        return
    if not VAPID_PRIVATE_KEY:
        return

    from datetime import datetime, timezone
    now_utc = datetime.now(timezone.utc)
    current_time = f"{now_utc.hour:02d}:{now_utc.minute:02d}"

    # Find users with reminder enabled at this exact UTC minute
    result = supabase.table('profiles').select('id').eq('reminder_enabled', True).eq('reminder_time_utc', current_time).execute()
    users = result.data or []
    if not users:
        return

    user_ids = [u['id'] for u in users]

    # Get their push subscriptions
    subs_result = supabase.table('push_subscriptions').select('subscription').in_('user_id', user_ids).execute()
    subs = subs_result.data or []

    payload = json.dumps({
        "title": "Time to study! 📚",
        "body": "Keep your streak alive — your daily cards are waiting.",
    })

    for row in subs:
        try:
            webpush(
                subscription_info=row['subscription'],
                data=payload,
                vapid_private_key=VAPID_PRIVATE_KEY,
                vapid_claims=VAPID_CLAIMS,
            )
        except WebPushException:
            pass
