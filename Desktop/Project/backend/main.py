from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from routes.paths import router as paths_router
from routes.topics import router as topics_router
from routes.flashcards import router as flashcards_router
from routes.progress import router as progress_router
from routes.analytics import router as analytics_router
from routes.otp import router as otp_router
from routes.notifications import router as notifications_router
from routes.push import router as push_router, send_scheduled_reminders


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Start reminder scheduler
    try:
        from apscheduler.schedulers.asyncio import AsyncIOScheduler
        scheduler = AsyncIOScheduler()
        scheduler.add_job(send_scheduled_reminders, 'cron', minute='*')
        scheduler.start()
        print("Reminder scheduler started.")
    except ImportError:
        print("apscheduler not installed — reminders disabled.")
    yield


app = FastAPI(title="PyDeck API", version="1.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(paths_router, prefix="/api/paths", tags=["Paths"])
app.include_router(topics_router, prefix="/api/topics", tags=["Topics"])
app.include_router(flashcards_router, prefix="/api/flashcards", tags=["Flashcards"])
app.include_router(progress_router, prefix="/api/progress", tags=["Progress"])
app.include_router(analytics_router, prefix="/api/analytics", tags=["Analytics"])
app.include_router(otp_router, prefix="/api/otp", tags=["OTP"])
app.include_router(notifications_router, prefix="/api/notifications", tags=["Notifications"])
app.include_router(push_router, prefix="/api/push", tags=["Push"])


@app.get("/")
def root():
    return {"message": "PyDeck API is running", "version": "1.0.0"}
