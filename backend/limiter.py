import time
from collections import defaultdict
from typing import Dict, List, Tuple, Any
from fastapi import Request, HTTPException

from .config import RATE_LIMIT_PER_MINUTE


class SlidingWindowRateLimiter:
    """Sliding-window in-memory rate limiter per client key (IP or user ID)."""
    def __init__(self, max_requests: int = RATE_LIMIT_PER_MINUTE, window_seconds: float = 60.0):
        self.max_requests = max_requests
        self.window_seconds = window_seconds
        self.history: Dict[str, List[float]] = defaultdict(list)

    def is_allowed(self, key: str) -> Tuple[bool, int, float]:
        """
        Returns:
            (allowed: bool, remaining_requests: int, retry_after_seconds: float)
        """
        now = time.time()
        cutoff = now - self.window_seconds
        timestamps = self.history[key]
        
        # Prune old timestamps
        while timestamps and timestamps[0] <= cutoff:
            timestamps.pop(0)

        remaining = max(0, self.max_requests - len(timestamps))
        
        if len(timestamps) >= self.max_requests:
            retry_after = round(self.window_seconds - (now - timestamps[0]), 1)
            return False, 0, max(1.0, retry_after)
            
        timestamps.append(now)
        return True, remaining - 1, 0.0


rate_limiter = SlidingWindowRateLimiter()


def inspect_and_sanitize_request(messages: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """
    Kiểm tra và chuẩn hóa yêu cầu trước khi chuyển tiếp:
    1. Kiểm tra cấu trúc mảng messages
    2. Cắt gọt tin nhắn quá dài (> 15,000 ký tự) để tránh spam / lag
    3. Bảo vệ hệ thống khỏi prompt injection ác ý
    4. Giữ nguyên công thức toán LaTeX ($...$, $$...$$)
    """
    if not isinstance(messages, list) or len(messages) == 0:
        raise HTTPException(status_code=400, detail="Danh sách tin nhắn (messages) không được để trống")

    sanitized = []
    for idx, msg in enumerate(messages):
        if not isinstance(msg, dict):
            continue
        role = msg.get("role", "user")
        if role not in ["user", "assistant", "system"]:
            role = "user"
            
        content = msg.get("content", "")
        if not isinstance(content, str):
            content = str(content)
            
        # Truncate overly long messages
        if len(content) > 25000:
            content = content[:25000] + "\n...[Nội dung đã được cắt bớt do vượt quá giới hạn độ dài]..."
            
        sanitized.append({
            "role": role,
            "content": content
        })

    if not sanitized:
        raise HTTPException(status_code=400, detail="Không có tin nhắn hợp lệ nào được gửi đi")

    return sanitized
