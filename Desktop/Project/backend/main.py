from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes.paths import router as paths_router
from routes.topics import router as topics_router
from routes.flashcards import router as flashcards_router
from routes.progress import router as progress_router
from routes.analytics import router as analytics_router

app = FastAPI(title="PyDeck API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(paths_router, prefix="/api/paths", tags=["Paths"])
app.include_router(topics_router, prefix="/api/topics", tags=["Topics"])
app.include_router(flashcards_router, prefix="/api/flashcards", tags=["Flashcards"])
app.include_router(progress_router, prefix="/api/progress", tags=["Progress"])
app.include_router(analytics_router, prefix="/api/analytics", tags=["Analytics"])


@app.get("/")
def root():
    return {"message": "PyDeck API is running", "version": "1.0.0"}
