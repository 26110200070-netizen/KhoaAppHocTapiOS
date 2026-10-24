import os
import json
import time
import random
import re
import asyncio
from typing import List, Dict, Any, Optional, AsyncGenerator
import httpx

from .config import (
    SESSION_FILE,
    GEMINI_WEB_TO_API_URL,
    ANTI_BLOCK_JITTER_MIN_MS,
    ANTI_BLOCK_JITTER_MAX_MS,
    MAX_CONCURRENT_GEMINI_REQUESTS,
    BASE_DIR,
    ROOT_DIR,
)

# Regex to extract session tokens from Gemini Web HTML
ACCESS_TOKEN_REGEX = re.compile(r'"SNlM0e":"([^"]+)"')
ACCESS_TOKEN_FALLBACK_REGEX = re.compile(r'\["SNlM0e","([^"]+)"\]')
PUSH_ID_REGEX = re.compile(r'"qKIAYe":"([^"]+)"')
BUILD_LABEL_REGEX = re.compile(r'"cfb2h":"([^"]+)"')
SESSION_ID_REGEX = re.compile(r'"FdrFJe":"([^"]+)"')

# Realistic Browser Headers (Mimics Chrome on Windows)
STEALTH_HEADERS = {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
    "Accept-Language": "vi-VN,vi;q=0.9,en-US;q=0.8,en;q=0.7",
    "Cache-Control": "max-age=0",
    "Origin": "https://gemini.google.com",
    "Sec-Ch-Ua": '"Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"',
    "Sec-Ch-Ua-Mobile": "?0",
    "Sec-Ch-Ua-Platform": '"Windows"',
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "same-origin",
    "X-Same-Domain": "1",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
}


class GeminiBridge:
    def __init__(self):
        self.semaphore = asyncio.Semaphore(MAX_CONCURRENT_GEMINI_REQUESTS)
        self.session_data: Dict[str, Any] = {}
        self.at_token: Optional[str] = None
        self.session_id: Optional[str] = None
        self.build_label: Optional[str] = None
        self.last_refresh: float = 0
        self._load_saved_session()

    def _load_saved_session(self):
        """Loads session cookies from session.json or environment."""
        if SESSION_FILE.exists():
            try:
                self.session_data = json.loads(SESSION_FILE.read_text(encoding="utf-8"))
            except Exception:
                self.session_data = {}
        
        # Also check .env files
        if not self.session_data.get("cookies"):
            cookies_env = os.getenv("GEMINI_COOKIES", "")
            if cookies_env:
                self.session_data["cookies"] = cookies_env

    def save_session(self, cookies: str, psid: str = "", psidts: str = ""):
        self.session_data = {
            "cookies": cookies,
            "__Secure-1PSID": psid,
            "__Secure-1PSIDTS": psidts,
            "updated_at": time.time()
        }
        SESSION_FILE.write_text(json.dumps(self.session_data, indent=2), encoding="utf-8")
        
        # Also sync to gemini-web-to-api/.env
        env_file = ROOT_DIR / "gemini-web-to-api" / ".env"
        try:
            env_content = f"""PORT=4981
LOG_LEVEL=info
APP_ENV=production
RATE_LIMIT_ENABLED=true
RATE_LIMIT_WINDOW_MS=60000
RATE_LIMIT_MAX_REQUESTS=30
GEMINI_COOKIES="{cookies}"
GEMINI_REFRESH_INTERVAL=1440
GEMINI_MAX_RETRIES=3
GEMINI_TEMPORARY=false
"""
            env_file.write_text(env_content, encoding="utf-8")
        except Exception:
            pass

    def get_cookie_header(self) -> str:
        return self.session_data.get("cookies", "")

    def is_session_available(self) -> bool:
        api_key = os.getenv("GEMINI_API_KEY", "") or self.session_data.get("api_key", "")
        if api_key and api_key.startswith("AIza"):
            return True
        cookies = self.get_cookie_header()
        return bool(cookies and ("__Secure-1PSID" in cookies or "__Secure-1PSIDTS" in cookies))

    async def _apply_anti_block_jitter(self):
        """Simulate human typing/action delay to avoid rapid bot detection."""
        delay = random.uniform(ANTI_BLOCK_JITTER_MIN_MS, ANTI_BLOCK_JITTER_MAX_MS) / 1000.0
        await asyncio.sleep(delay)

    async def check_upstream_server(self) -> bool:
        """Check if gemini-web-to-api Go server is running on port 4981."""
        try:
            async with httpx.AsyncClient(timeout=2.0) as client:
                res = await client.get(f"{GEMINI_WEB_TO_API_URL}/health")
                return res.status_code == 200
        except Exception:
            return False

    async def chat_completion(
        self,
        messages: List[Dict[str, Any]],
        model: str = "gemini-2.5-flash",
        stream: bool = False,
        gemini_api_key: Optional[str] = None,
        web_search: bool = False,
        attached_image_base64: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Main completion method with multi-layer resilience:
        1. If Gemini Official API Key is provided (or in GEMINI_API_KEY env), use Google AI Studio directly.
        2. If gemini-web-to-api service is running (port 4981), forward request to it.
        3. Built-in direct Gemini Web client.
        4. Intelligent fallback with friendly Vietnamese guidance.
        """
        async with self.semaphore:
            await self._apply_anti_block_jitter()

            # Layer A: Official Google AI Studio Gemini API (if key starting with AIza is given)
            effective_api_key = gemini_api_key or os.getenv("GEMINI_API_KEY", "") or self.session_data.get("api_key", "")
            if effective_api_key and effective_api_key.startswith("AIza"):
                return await self._call_official_gemini_api(
                    messages=messages,
                    model=model,
                    api_key=effective_api_key,
                    web_search=web_search,
                    attached_image_base64=attached_image_base64
                )

            # Layer B: Upstream gemini-web-to-api server (port 4981)
            is_upstream_up = await self.check_upstream_server()
            if is_upstream_up:
                try:
                    return await self._call_upstream_server(
                        messages=messages,
                        model=model,
                        stream=stream,
                        web_search=web_search,
                        attached_image_base64=attached_image_base64
                    )
                except Exception as e:
                    # If upstream failed, attempt direct web
                    pass

            # Layer C: Built-in Gemini Web client using browser cookies
            if self.is_session_available():
                try:
                    return await self._call_direct_gemini_web(
                        messages=messages,
                        model=model,
                        web_search=web_search,
                        attached_image_base64=attached_image_base64
                    )
                except Exception as e:
                    error_msg = str(e)
                    if "unusual traffic" in error_msg.lower() or "429" in error_msg:
                        return self._format_error_response(
                            "⚠️ Google tạm thời phát hiện tần suất yêu cầu cao (Rate Limit 429).\n"
                            "👉 Hệ thống Shimy đã kích hoạt bộ đệm bảo vệ chống chặn. Bạn vui lòng đợi 15 giây rồi gửi lại câu hỏi nhé!"
                        )
                    if "auth" in error_msg.lower() or "cookie" in error_msg.lower():
                        return self._format_error_response(
                            "⚠️ Phiên đăng nhập Google Gemini trên máy tính đã hết hạn.\n"
                            "👉 Cách xử lý siêu nhanh: Mở file `run_gemini_server.bat` trên máy tính để đăng nhập lại tài khoản Google trong 5 giây nhé!"
                        )
                    return self._format_error_response(f"⚠️ Shimy Gemini phản hồi: {error_msg}")

            # If no cookies and no key
            return self._format_error_response(
                "⚠️ Máy chủ chưa được đăng nhập tài khoản Google Gemini hoặc chưa cấu hình Cookie.\n\n"
                "👉 Cách kích hoạt chỉ 1 bước:\n"
                "1. Trên máy tính, hãy mở file `run_gemini_server.bat`.\n"
                "2. Cửa sổ trình duyệt sẽ tự động mở lên, bạn đăng nhập tài khoản Google của mình.\n"
                "3. Máy chủ sẽ tự động lưu phiên và hoạt động ngay lập tức!"
            )

    async def _call_upstream_server(
        self,
        messages: List[Dict[str, Any]],
        model: str,
        stream: bool,
        web_search: bool,
        attached_image_base64: Optional[str]
    ) -> Dict[str, Any]:
        """Forward request to gemini-web-to-api server."""
        # Map Shimy models to gemini-web-to-api models
        target_model = "gemini-auto"
        if "flash" in model.lower():
            target_model = "gemini-3.6-flash"
        elif "pro" in model.lower():
            target_model = "gemini-3.1-pro"
        
        # Build payload
        payload = {
            "model": target_model,
            "messages": messages,
            "stream": False
        }
        
        async with httpx.AsyncClient(timeout=65.0) as client:
            res = await client.post(
                f"{GEMINI_WEB_TO_API_URL}/openai/v1/chat/completions",
                json=payload,
                headers={"Content-Type": "application/json"}
            )
            if res.status_code == 200:
                return res.json()
            else:
                raise Exception(f"Upstream returned HTTP {res.status_code}: {res.text}")

    async def _call_official_gemini_api(
        self,
        messages: List[Dict[str, Any]],
        model: str,
        api_key: str,
        web_search: bool,
        attached_image_base64: Optional[str]
    ) -> Dict[str, Any]:
        """Direct call to Google AI Studio Gemini API (100% reliable, official, free tier)."""
        target_model = "gemini-1.5-flash"
        if "pro" in model.lower():
            target_model = "gemini-1.5-pro"

        contents = []
        system_instruction = "Bạn tên là Shimy, một trợ lý học tập AI thông minh và tận tâm, được phát triển và huấn luyện bởi Duy Nguyễn. Hãy giải thích chi tiết, ân cần, đầy đủ bảng biểu, công thức toán học và mã nguồn nếu cần để hỗ trợ học sinh học tập tốt nhất. Tuyệt đối không đề cập đến tên gọi hay nhà phát triển nào khác, tên duy nhất của bạn là Shimy do Duy Nguyễn huấn luyện."
        
        for msg in messages:
            role = "user" if msg["role"] == "user" else "model"
            if msg["role"] == "system":
                system_instruction += "\n" + msg["content"]
                continue
            parts = [{"text": msg["content"]}]
            contents.append({"role": role, "parts": parts})

        # Append image if present on last user message
        if attached_image_base64 and contents and contents[-1]["role"] == "user":
            contents[-1]["parts"].append({
                "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": attached_image_base64
                }
            })

        body: Dict[str, Any] = {
            "contents": contents,
            "systemInstruction": {
                "parts": [{"text": system_instruction}]
            },
            "generationConfig": {
                "temperature": 0.7,
                "maxOutputTokens": 4096
            }
        }

        if web_search:
            body["tools"] = [{"googleSearch": {}}]

        url = f"https://generativelanguage.googleapis.com/v1beta/models/{target_model}:generateContent?key={api_key}"
        async with httpx.AsyncClient(timeout=45.0) as client:
            resp = await client.post(url, json=body)
            if resp.status_code == 200:
                data = resp.json()
                try:
                    candidates = data.get("candidates", [])
                    content_parts = candidates[0]["content"]["parts"]
                    text_parts = [p.get("text", "") for p in content_parts if "text" in p]
                    full_text = "".join(text_parts)
                    return self._format_openai_response(full_text, model=model)
                except Exception as e:
                    raise Exception(f"Lỗi phân tích cú pháp Gemini: {str(e)}")
            else:
                raise Exception(f"Google AI Studio trả về mã {resp.status_code}: {resp.text}")

    async def _call_direct_gemini_web(
        self,
        messages: List[Dict[str, Any]],
        model: str,
        web_search: bool,
        attached_image_base64: Optional[str]
    ) -> Dict[str, Any]:
        """Calls Gemini Web reverse-engineered endpoint."""
        cookie_str = self.get_cookie_header()
        
        # 1. Ensure SNlM0e session token is obtained
        if not self.at_token or (time.time() - self.last_refresh > 3600):
            await self._refresh_session_token(cookie_str)

        # 2. Extract last user prompt and conversation history
        user_prompt = ""
        for m in reversed(messages):
            if m["role"] == "user":
                user_prompt = m["content"]
                break

        # 3. Construct Gemini Web batchexecute payload
        # Standard Shimy prompt augmentation
        full_prompt = f"[Bạn là Shimy - Gia sư AI thông minh do Duy Nguyễn phát triển].\n\n{user_prompt}"
        if web_search:
            full_prompt += "\n\n[Hãy tra cứu tài liệu SGK mới nhất của Bộ GD&ĐT Việt Nam để đưa ra đáp án chuẩn xác nhất]."

        req_data = [
            [full_prompt, 0, None, None, None, None, 0],
            ["vi"],
            [self.session_id or "", "", ""],
            None, None, None, [1], 0, [], [], 1, 0,
            None, None, None, None, None,
            [1],
            [],
        ]

        envelope = [
            [["otAQ7b", json.dumps(req_data, separators=(',', ':')), None, "generic"]]
        ]
        
        post_data = {
            "f.req": json.dumps(envelope, separators=(',', ':')),
            "at": self.at_token or ""
        }

        headers = dict(STEALTH_HEADERS)
        headers["Cookie"] = cookie_str
        headers["Content-Type"] = "application/x-www-form-urlencoded;charset=UTF-8"
        headers["Referer"] = "https://gemini.google.com/"

        url = "https://gemini.google.com/_/BardChatUi/data/batchexecute?rpcids=otAQ7b&source-path=%2Fapp"
        async with httpx.AsyncClient(timeout=60.0, follow_redirects=True) as client:
            res = await client.post(url, data=post_data, headers=headers)
            if res.status_code != 200:
                raise Exception(f"Gemini Web batchexecute trả về HTTP {res.status_code}")

            answer = self._parse_gemini_web_response(res.text)
            if not answer:
                raise Exception("Không trích xuất được phản hồi văn bản từ Gemini Web")

            return self._format_openai_response(answer, model=model)

    async def _refresh_session_token(self, cookie_str: str):
        """Fetch SNlM0e from gemini.google.com."""
        headers = dict(STEALTH_HEADERS)
        headers["Cookie"] = cookie_str
        
        async with httpx.AsyncClient(timeout=30.0, follow_redirects=True) as client:
            res = await client.get("https://gemini.google.com/app", headers=headers)
            html_text = res.text
            
            m = ACCESS_TOKEN_REGEX.search(html_text) or ACCESS_TOKEN_FALLBACK_REGEX.search(html_text)
            if m:
                self.at_token = m.group(1)
            
            m_sid = SESSION_ID_REGEX.search(html_text)
            if m_sid:
                self.session_id = m_sid.group(1)
                
            m_bl = BUILD_LABEL_REGEX.search(html_text)
            if m_bl:
                self.build_label = m_bl.group(1)
                
            self.last_refresh = time.time()
            if not self.at_token:
                raise Exception("Không tìm thấy token SNlM0e trong trang Gemini Web (Có thể Cookie đã hết hạn)")

    def _parse_gemini_web_response(self, text: str) -> Optional[str]:
        """Parses the nested JSON lines response from batchexecute."""
        lines = text.split("\n")
        for line in lines:
            line = line.strip()
            if not line.startswith("[") or "otAQ7b" not in line:
                continue
            try:
                outer = json.loads(line)
                for item in outer:
                    if len(item) >= 3 and item[0] == "wrb.fr" and item[1] == "otAQ7b":
                        inner_str = item[2]
                        inner = json.loads(inner_str)
                        # The answer text is in inner[4][0][1][0]
                        if len(inner) > 4 and inner[4]:
                            cand = inner[4][0]
                            if len(cand) > 1 and cand[1]:
                                return cand[1][0]
            except Exception:
                continue
        return None

    def _format_openai_response(self, text: str, model: str) -> Dict[str, Any]:
        return {
            "id": f"chatcmpl-shimy-{int(time.time()*1000)}",
            "object": "chat.completion",
            "created": int(time.time()),
            "model": model,
            "choices": [
                {
                    "index": 0,
                    "message": {
                        "role": "assistant",
                        "content": text
                    },
                    "finish_reason": "stop"
                }
            ],
            "usage": {
                "prompt_tokens": 100,
                "completion_tokens": len(text.split()),
                "total_tokens": 100 + len(text.split())
            }
        }

    def _format_error_response(self, message: str) -> Dict[str, Any]:
        return {
            "id": f"chatcmpl-err-{int(time.time())}",
            "object": "chat.completion",
            "created": int(time.time()),
            "model": "gemini-shimy",
            "choices": [
                {
                    "index": 0,
                    "message": {
                        "role": "assistant",
                        "content": message
                    },
                    "finish_reason": "stop"
                }
            ],
            "error": {
                "message": message,
                "type": "server_guidance"
            }
        }


gemini_bridge = GeminiBridge()
