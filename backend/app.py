import os
import time
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, Field
from fastapi import FastAPI, Request, HTTPException, Depends, Header
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from .config import HOST, PORT, DAILY_QUOTA_STUDENT
from .auth import user_manager, verify_app_token
from .limiter import rate_limiter, inspect_and_sanitize_request
from .gemini_client import gemini_bridge

app = FastAPI(
    title="Shimy AI - Backend API Gateway",
    description="Backend trung gian: Xác thực, Phân quyền, Giới hạn lượt dùng, Kiểm tra yêu cầu & Chuyển tiếp tới Gemini Web To API",
    version="2.0.0"
)

# Enable CORS for all clients (iPhone, web, local)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Pydantic Request Models
class RegisterRequest(BaseModel):
    username: str
    password: str
    full_name: Optional[str] = None
    grade: Optional[int] = 12


class LoginRequest(BaseModel):
    username: str
    password: str


class ChatMessageDto(BaseModel):
    role: str
    content: str


class ChatCompletionRequest(BaseModel):
    model: Optional[str] = "gemini-2.5-flash"
    messages: List[ChatMessageDto]
    stream: Optional[bool] = False
    web_search: Optional[bool] = False
    search: Optional[bool] = False
    thinking: Optional[bool] = False
    attached_image: Optional[str] = None


# Dependencies
def get_current_user_token(authorization: Optional[str] = Header(None)) -> Optional[Dict[str, Any]]:
    """Extract and verify app token if present."""
    if not authorization:
        return None
    token_str = authorization
    if token_str.startswith("Bearer "):
        token_str = token_str[7:].strip()
        
    # If caller is passing Google AI Studio key directly (AIza...)
    if token_str.startswith("AIza"):
        return {"uid": "google_direct", "usr": "GoogleDirectUser", "rol": "vip", "api_key": token_str}
        
    payload = verify_app_token(token_str)
    return payload


# -----------------------------------------------------------------------------
# 1. AUTHENTICATION & USER MANAGEMENT (Đăng ký · Đăng nhập)
# -----------------------------------------------------------------------------

@app.post("/api/auth/register", summary="Đăng ký tài khoản Shimy mới")
def register_user(req: RegisterRequest):
    success, message, data = user_manager.register(
        username=req.username,
        password=req.password,
        full_name=req.full_name,
        grade=req.grade or 12
    )
    if not success:
        raise HTTPException(status_code=400, detail=message)
    return {
        "status": "success",
        "message": message,
        "data": data
    }


@app.post("/api/auth/login", summary="Đăng nhập tài khoản & nhận App Token")
def login_user(req: LoginRequest):
    success, message, data = user_manager.login(
        username=req.username,
        password=req.password
    )
    if not success:
        raise HTTPException(status_code=401, detail=message)
    return {
        "status": "success",
        "message": message,
        "data": data
    }


@app.get("/api/auth/me", summary="Lấy thông tin tài khoản hiện tại")
def get_me(user: Optional[Dict[str, Any]] = Depends(get_current_user_token)):
    if not user:
        raise HTTPException(status_code=401, detail="Vui lòng đăng nhập hoặc cung cấp App Token hợp lệ")
    
    uid = user.get("uid")
    user_record = user_manager.get_user_by_id(uid)
    if not user_record:
        # Fallback payload
        return {
            "user_id": uid,
            "username": user.get("usr", "User"),
            "role": user.get("rol", "student"),
            "remaining_quota": 9999 if user.get("rol") in ["admin", "vip"] else DAILY_QUOTA_STUDENT
        }
    
    remaining = user_manager.get_remaining_quota(user_record)
    return {
        "user_id": user_record["id"],
        "username": user_record["username"],
        "login_name": user_record["login_name"],
        "email": user_record["email"],
        "role": user_record["role"],
        "grade": user_record.get("grade", 12),
        "remaining_quota": remaining
    }


# -----------------------------------------------------------------------------
# 2. STATUS & DIAGNOSTICS (Health check)
# -----------------------------------------------------------------------------

@app.get("/health")
@app.get("/healthz")
@app.get("/v1/health")
@app.get("/v1/healthz")
async def health_check():
    upstream_up = await gemini_bridge.check_upstream_server()
    has_session = gemini_bridge.is_session_available()
    return {
        "status": "ok",
        "service": "Shimy Backend Gateway",
        "gemini_web_session": "active" if has_session else "needs_login",
        "gemini_web_to_api_upstream": "connected" if upstream_up else "standalone_mode",
        "timestamp": int(time.time())
    }


# -----------------------------------------------------------------------------
# 3. OPENAI / SHIMY COMPATIBLE CHAT & MODELS (Chat AI · Lịch sử chat)
# -----------------------------------------------------------------------------

@app.get("/v1/models")
@app.get("/models")
def list_models():
    """List available Gemini AI models for Shimy iOS app."""
    return {
        "object": "list",
        "data": [
            {
                "id": "gemini-2.5-flash",
                "object": "model",
                "created": 1700000000,
                "owned_by": "google",
                "display_name": "Shimy Flash (Phản Hồi Nhanh - Mặc định)"
            },
            {
                "id": "gemini-2.5-pro",
                "object": "model",
                "created": 1700000000,
                "owned_by": "google",
                "display_name": "Shimy Pro (Chuyên Gia Học Tập & Giải Toán)"
            },
            {
                "id": "gemini-thinking",
                "object": "model",
                "created": 1700000000,
                "owned_by": "google",
                "display_name": "Shimy Think (Suy Luận Sâu Từng Bước)"
            },
            {
                "id": "gemini-auto",
                "object": "model",
                "created": 1700000000,
                "owned_by": "google",
                "display_name": "Shimy Auto (Tự Động Tối Ưu Hóa)"
            }
        ]
    }


@app.post("/v1/chat/completions", summary="Gửi tin nhắn trò chuyện hoặc sinh đề thi")
@app.post("/chat/completions", summary="Gửi tin nhắn trò chuyện hoặc sinh đề thi (alias)")
async def chat_completions(
    req: ChatCompletionRequest,
    request: Request,
    authorization: Optional[str] = Header(None)
):
    # 1. Authenticate user / token (Token xác thực của app)
    user = get_current_user_token(authorization)
    user_id = user.get("uid") if user else request.client.host
    user_role = user.get("rol", "guest") if user else "guest"
    direct_api_key = user.get("api_key") if user else None

    # 2. Rate limiting check (Giới hạn lượt dùng - Anti-Spam)
    allowed, remaining_rpm, retry_after = rate_limiter.is_allowed(user_id)
    if not allowed:
        return JSONResponse(
            status_code=429,
            content={
                "error": {
                    "message": f"Bạn đang gửi yêu cầu quá nhanh. Vui lòng đợi {retry_after}s trước khi gửi tiếp.",
                    "type": "rate_limit_exceeded"
                }
            },
            headers={"Retry-After": str(int(retry_after))}
        )

    # 3. Daily quota check (Phân quyền & hạn mức học tập trong ngày)
    if user and user_role not in ["admin", "vip"] and not direct_api_key:
        has_quota = user_manager.record_usage(user_id)
        if not has_quota:
            return JSONResponse(
                status_code=429,
                content={
                    "error": {
                        "message": "Bạn đã sử dụng hết hạn mức học tập miễn phí hôm nay (150 câu hỏi/ngày). Vui lòng quay lại vào ngày mai hoặc nâng cấp tài khoản VIP!",
                        "type": "daily_quota_exceeded"
                    }
                }
            )

    # 4. Request inspection & sanitization (Kiểm tra yêu cầu)
    raw_messages = [m.model_dump() for m in req.messages]
    sanitized_messages = inspect_and_sanitize_request(raw_messages)

    # 5. Model resolution
    chosen_model = req.model or "gemini-2.5-flash"
    if req.thinking:
        chosen_model = "gemini-thinking"

    # 6. Call Gemini Bridge (Lớp chuyển tiếp tới Gemini Web To API)
    is_web_search = req.web_search or req.search or False
    
    response_payload = await gemini_bridge.chat_completion(
        messages=sanitized_messages,
        model=chosen_model,
        stream=False,
        gemini_api_key=direct_api_key,
        web_search=is_web_search,
        attached_image_base64=req.attached_image
    )

    return JSONResponse(
        content=response_payload,
        headers={
            "X-RateLimit-Remaining": str(remaining_rpm),
            "X-Shimy-Model": chosen_model
        }
    )


@app.get("/")
def home():
    return {
        "app": "Shimy Study AI Gateway",
        "description": "Backend API chuyển tiếp Gemini Web To API cho ứng dụng Shimy iOS",
        "version": "2.0.0",
        "endpoints": {
            "login": "POST /api/auth/login",
            "register": "POST /api/auth/register",
            "chat": "POST /v1/chat/completions",
            "models": "GET /v1/models",
            "health": "GET /health"
        }
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("backend.app:app", host=HOST, port=PORT, reload=False)
