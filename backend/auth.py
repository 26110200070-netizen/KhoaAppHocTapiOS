import os
import json
import time
import hmac
import hashlib
import base64
import secrets
from typing import Optional, Dict, Any
from datetime import datetime, date

from .config import USERS_FILE, APP_SECRET_KEY, DAILY_QUOTA_STUDENT, DAILY_QUOTA_VIP


def _hash_password(password: str, salt: Optional[str] = None) -> tuple[str, str]:
    if not salt:
        salt = secrets.token_hex(16)
    hashed = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), salt.encode("utf-8"), 100000)
    return hashed.hex(), salt


def _verify_password(password: str, hashed_hex: str, salt: str) -> bool:
    hashed = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), salt.encode("utf-8"), 100000)
    return hmac.compare_digest(hashed.hex(), hashed_hex)


def generate_app_token(user_id: str, username: str, role: str) -> str:
    """Generate a tamper-proof URL-safe App Bearer Token."""
    payload = {
        "uid": user_id,
        "usr": username,
        "rol": role,
        "exp": int(time.time()) + 30 * 86400,  # 30 days valid
        "rnd": secrets.token_hex(8)
    }
    raw = json.dumps(payload, separators=(',', ':')).encode("utf-8")
    b64_payload = base64.urlsafe_b64encode(raw).decode("utf-8").rstrip("=")
    signature = hmac.new(APP_SECRET_KEY.encode("utf-8"), b64_payload.encode("utf-8"), hashlib.sha256).hexdigest()
    return f"shimy_{b64_payload}.{signature[:32]}"


def verify_app_token(token: str) -> Optional[Dict[str, Any]]:
    """Verify and decode the App Bearer Token."""
    if not token:
        return None
    token = token.strip()
    if token.startswith("Bearer "):
        token = token[7:].strip()
    if not token.startswith("shimy_") or "." not in token:
        return None
    
    body = token[6:]
    parts = body.split(".")
    if len(parts) != 2:
        return None
    b64_payload, signature = parts
    expected_sig = hmac.new(APP_SECRET_KEY.encode("utf-8"), b64_payload.encode("utf-8"), hashlib.sha256).hexdigest()[:32]
    if not hmac.compare_digest(signature, expected_sig):
        return None
    
    # Pad base64
    pad_len = 4 - (len(b64_payload) % 4)
    if pad_len != 4:
        b64_payload += "=" * pad_len
        
    try:
        raw = base64.urlsafe_b64decode(b64_payload)
        payload = json.loads(raw.decode("utf-8"))
        if payload.get("exp", 0) < time.time():
            return None  # Expired
        return payload
    except Exception:
        return None


class UserManager:
    def __init__(self):
        self.file_path = USERS_FILE
        self._init_db()

    def _init_db(self):
        if not self.file_path.exists():
            # Seed initial default accounts
            h_khoa, s_khoa = _hash_password("123456")
            h_std, s_std = _hash_password("123456")
            initial_data = {
                "users": {
                    "khoadev": {
                        "id": "u_khoadev_001",
                        "username": "Anh Khoa Dev",
                        "login_name": "khoadev",
                        "password_hash": h_khoa,
                        "salt": s_khoa,
                        "email": "khoadev@study.edu.vn",
                        "role": "admin",
                        "grade": 12,
                        "created_at": datetime.now().isoformat(),
                        "usage": {}
                    },
                    "student": {
                        "id": "u_student_002",
                        "username": "Học Sinh THPT",
                        "login_name": "student",
                        "password_hash": h_std,
                        "salt": s_std,
                        "email": "student@study.edu.vn",
                        "role": "student",
                        "grade": 12,
                        "created_at": datetime.now().isoformat(),
                        "usage": {}
                    }
                }
            }
            self.file_path.write_text(json.dumps(initial_data, indent=2, ensure_ascii=False), encoding="utf-8")

    def _read_data(self) -> Dict[str, Any]:
        try:
            return json.loads(self.file_path.read_text(encoding="utf-8"))
        except Exception:
            return {"users": {}}

    def _write_data(self, data: Dict[str, Any]):
        self.file_path.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")

    def register(self, username: str, password: str, full_name: Optional[str] = None, grade: int = 12) -> tuple[bool, str, Optional[Dict[str, Any]]]:
        clean_user = username.strip().lower()
        if len(clean_user) < 3:
            return False, "Tên đăng nhập phải có ít nhất 3 ký tự", None
        if len(password) < 6:
            return False, "Mật khẩu phải có ít nhất 6 ký tự", None

        data = self._read_data()
        if clean_user in data["users"]:
            return False, "Tên đăng nhập đã tồn tại trên hệ thống", None

        h, s = _hash_password(password)
        uid = f"u_{secrets.token_hex(6)}"
        display_name = (full_name or username).strip()
        user_record = {
            "id": uid,
            "username": display_name,
            "login_name": clean_user,
            "password_hash": h,
            "salt": s,
            "email": f"{clean_user}@study.edu.vn",
            "role": "student",
            "grade": grade,
            "created_at": datetime.now().isoformat(),
            "usage": {}
        }
        data["users"][clean_user] = user_record
        self._write_data(data)
        
        token = generate_app_token(uid, clean_user, "student")
        return True, "Đăng ký tài khoản thành công!", {
            "user_id": uid,
            "username": display_name,
            "login_name": clean_user,
            "role": "student",
            "grade": grade,
            "token": token,
            "daily_quota": DAILY_QUOTA_STUDENT,
            "remaining_quota": DAILY_QUOTA_STUDENT
        }

    def login(self, username: str, password: str) -> tuple[bool, str, Optional[Dict[str, Any]]]:
        clean_user = username.strip().lower()
        data = self._read_data()
        
        # Check by login_name or email
        user_record = None
        for k, u in data["users"].items():
            if k == clean_user or u.get("email", "").lower() == clean_user:
                user_record = u
                break
                
        if not user_record:
            return False, "Tài khoản không tồn tại trên máy chủ", None

        if not _verify_password(password, user_record["password_hash"], user_record["salt"]):
            return False, "Mật khẩu không chính xác", None

        role = user_record.get("role", "student")
        uid = user_record["id"]
        token = generate_app_token(uid, user_record["login_name"], role)
        
        remaining = self.get_remaining_quota(user_record)
        return True, "Đăng nhập thành công!", {
            "user_id": uid,
            "username": user_record["username"],
            "login_name": user_record["login_name"],
            "email": user_record["email"],
            "role": role,
            "grade": user_record.get("grade", 12),
            "token": token,
            "daily_quota": 9999 if role in ["admin", "vip"] else DAILY_QUOTA_STUDENT,
            "remaining_quota": remaining
        }

    def get_user_by_id(self, user_id: str) -> Optional[Dict[str, Any]]:
        data = self._read_data()
        for u in data["users"].values():
            if u.get("id") == user_id:
                return u
        return None

    def get_remaining_quota(self, user_record: Dict[str, Any]) -> int:
        role = user_record.get("role", "student")
        if role in ["admin", "vip"]:
            return 9999
        today = date.today().isoformat()
        usage = user_record.get("usage", {}).get(today, 0)
        return max(0, DAILY_QUOTA_STUDENT - usage)

    def record_usage(self, user_id: str) -> bool:
        """Increment usage count for today. Returns False if quota exceeded."""
        data = self._read_data()
        for key, u in data["users"].items():
            if u.get("id") == user_id:
                role = u.get("role", "student")
                if role in ["admin", "vip"]:
                    return True
                today = date.today().isoformat()
                if "usage" not in u:
                    u["usage"] = {}
                current = u["usage"].get(today, 0)
                if current >= DAILY_QUOTA_STUDENT:
                    return False
                u["usage"][today] = current + 1
                self._write_data(data)
                return True
        return True


user_manager = UserManager()
