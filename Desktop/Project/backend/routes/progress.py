from fastapi import APIRouter
from pydantic import BaseModel
from db import supabase

router = APIRouter()


class ProgressUpdate(BaseModel):
    user_id: str
    flashcard_id: str
    status: str


@router.get("/{user_id}")
def get_user_progress(user_id: str):
    response = supabase.table("user_progress").select("*").eq("user_id", user_id).execute()
    return response.data


@router.post("/")
def update_progress(data: ProgressUpdate):
    response = supabase.table("user_progress").upsert({
        "user_id": data.user_id,
        "flashcard_id": data.flashcard_id,
        "status": data.status,
    }).execute()
    return response.data
