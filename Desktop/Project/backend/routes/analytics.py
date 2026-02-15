
from fastapi import APIRouter
from db import supabase

router = APIRouter()


@router.get("/{user_id}")
def get_analytics(user_id: str):
    # Get study sessions
    sessions = supabase.table("study_sessions").select("*").eq("user_id", user_id).order("date").execute()

    # Get mastered count
    mastered = supabase.table("user_progress").select("*", count="exact").eq("user_id", user_id).eq("status", "mastered").execute()

    return {
        "sessions": sessions.data,
        "mastered_count": mastered.count or 0,
    }
