from fastapi import APIRouter
from db import supabase

router = APIRouter()


@router.get("/")
def get_topics(path_id: str = None):
    query = supabase.table("topics").select("*")
    if path_id:
        query = query.eq("path_id", path_id)
    response = query.order("display_order").execute()
    return response.data


@router.get("/{topic_id}")
def get_topic(topic_id: str):
    response = supabase.table("topics").select("*, paths(name)").eq("id", topic_id).single().execute()
    return response.data
