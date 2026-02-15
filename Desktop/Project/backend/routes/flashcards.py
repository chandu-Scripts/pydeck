from fastapi import APIRouter
from db import supabase

router = APIRouter()


@router.get("/")
def get_flashcards(topic_id: str = None):
    query = supabase.table("flashcards").select("*")
    if topic_id:
        query = query.eq("topic_id", topic_id)
    response = query.execute()
    return response.data


@router.get("/{card_id}")
def get_flashcard(card_id: str):
    response = supabase.table("flashcards").select("*").eq("id", card_id).single().execute()
    return response.data
