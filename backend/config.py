import os
from pathlib import Path
from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent
ROOT_DIR = BASE_DIR.parent

# Load .env if present
load_dotenv(BASE_DIR / ".env")
load_dotenv(ROOT_DIR / "gemini-web-to-api" / ".env")

# Server Config
HOST = os.getenv("HOST", "0.0.0.0")
PORT = int(os.getenv("PORT", "8000"))

# Upstream Gemini Web To API endpoint (if running in parallel)
GEMINI_WEB_TO_API_URL = os.getenv("GEMINI_WEB_TO_API_URL", "http://127.0.0.1:4981")

# Rate Limiting & Quotas (Chống spam & bảo vệ Gemini Cookie)
RATE_LIMIT_PER_MINUTE = int(os.getenv("RATE_LIMIT_PER_MINUTE", "25"))
DAILY_QUOTA_STUDENT = int(os.getenv("DAILY_QUOTA_STUDENT", "150"))
DAILY_QUOTA_VIP = int(os.getenv("DAILY_QUOTA_VIP", "500"))

# Anti-Google Block Settings (Đảm bảo không bị Google chặn)
ANTI_BLOCK_JITTER_MIN_MS = int(os.getenv("ANTI_BLOCK_JITTER_MIN_MS", "300"))
ANTI_BLOCK_JITTER_MAX_MS = int(os.getenv("ANTI_BLOCK_JITTER_MAX_MS", "700"))
MAX_CONCURRENT_GEMINI_REQUESTS = int(os.getenv("MAX_CONCURRENT_GEMINI_REQUESTS", "2"))
COOKIE_ROTATION_INTERVAL_MINUTES = int(os.getenv("COOKIE_ROTATION_INTERVAL_MINUTES", "1440"))

# JWT / Bearer Secret Key for App Authentication
APP_SECRET_KEY = os.getenv("APP_SECRET_KEY", "shimy-study-gemini-secret-key-2026-v1")

# Directory paths
DATA_DIR = BASE_DIR / "data"
SESSION_DIR = BASE_DIR / "session"
DATA_DIR.mkdir(parents=True, exist_ok=True)
SESSION_DIR.mkdir(parents=True, exist_ok=True)

USERS_FILE = DATA_DIR / "users.json"
SESSION_FILE = SESSION_DIR / "session.json"
PROFILE_DIR = SESSION_DIR / "profile"
