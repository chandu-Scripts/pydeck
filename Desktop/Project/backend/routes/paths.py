from fastapi import APIRouter
from db import supabase

router = APIRouter()


@router.get("/")
def get_paths():
    response = supabase.table("paths").select("*").order("display_order").execute()
    return response.data


@router.get("/{path_id}")
def get_path(path_id: str):
    response = supabase.table("paths").select("*").eq("id", path_id).single().execute()
    return response.data
