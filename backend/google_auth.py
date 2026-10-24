"""
Interactive Google Login module for Gemini Web.
Uses Playwright to open Chromium, allowing the user to sign in with their Google account once.
The session cookies (__Secure-1PSID, __Secure-1PSIDTS, etc.) are captured and saved.
"""

import sys
import time
from playwright.sync_api import sync_playwright

from .config import PROFILE_DIR, SESSION_FILE
from .gemini_client import gemini_bridge


def run_google_login():
    print("=" * 68)
    print("      KHOASTUDY - GOOGLE GEMINI AUTHENTICATION HELPER")
    print("=" * 68)
    print("[*] Đang mở trình duyệt Chromium...")
    print("[*] Vui lòng đăng nhập tài khoản Google của bạn tại cửa sổ mở lên.")
    print("[*] Sau khi đăng nhập thành công và vào được trang Gemini,")
    print("    hệ thống sẽ tự động nhận diện __Secure-1PSID và đóng trình duyệt!")
    print("=" * 68)

    captured_cookies = ""
    found_psid = ""
    found_psidts = ""

    with sync_playwright() as p:
        browser_context = p.chromium.launch_persistent_context(
            user_data_dir=str(PROFILE_DIR),
            headless=False,
            channel="chromium",
            args=[
                "--disable-blink-features=AutomationControlled",
                "--no-sandbox",
                "--start-maximized"
            ]
        )
        
        page = browser_context.pages[0] if browser_context.pages else browser_context.new_page()
        try:
            page.goto("https://gemini.google.com/app", wait_until="domcontentloaded", timeout=60000)
        except Exception:
            pass

        print("\n[*] Đang đợi bạn đăng nhập vào Google Gemini...")
        print("[*] Cửa sổ Chromium đang mở. Hãy đăng nhập tài khoản Google của bạn...")

        for attempt in range(180):  # Wait up to 6 minutes for user login
            time.sleep(2)
            try:
                if page.is_closed() or not browser_context.pages:
                    print("\n[!] Trình duyệt đã được đóng lại.")
                    break
            except Exception:
                break

            # Fetch ALL cookies across all domains (.google.com, gemini.google.com)
            try:
                cookies_list = browser_context.cookies()
            except Exception:
                cookies_list = []

            cookie_dict = {}
            for c in cookies_list:
                name = c.get("name")
                val = c.get("value")
                cookie_dict[name] = val
                if name == "__Secure-1PSID":
                    found_psid = val
                elif name == "__Secure-1PSIDTS":
                    found_psidts = val

            # Valid login requires __Secure-1PSID with real token length (> 25)
            if found_psid and len(found_psid) > 25:
                cookie_parts = [f"{k}={v}" for k, v in cookie_dict.items()]
                captured_cookies = "; ".join(cookie_parts)
                print(f"\n[OK] Đã phát hiện thấy phiên đăng nhập Google hợp lệ (attempt {attempt+1})!")
                print(f"[OK] __Secure-1PSID: {found_psid[:10]}... (độ dài: {len(found_psid)})")
                if found_psidts:
                    print(f"[OK] __Secure-1PSIDTS: {found_psidts[:10]}...")
                
                # Small wait to ensure Google completes setting session state
                time.sleep(2)
                break

            if attempt > 0 and attempt % 15 == 0:
                print(f"[*] Vẫn đang đợi đăng nhập Google... ({attempt * 2}s đã trôi qua)")

        try:
            browser_context.close()
        except Exception:
            pass

        if captured_cookies and found_psid:
            gemini_bridge.save_session(captured_cookies, psid=found_psid, psidts=found_psidts)
            print("\n" + "=" * 68)
            print(" [SUCCESS] LƯU PHIÊN GOOGLE GEMINI THÀNH CÔNG!")
            print(" Đã trích xuất đầy đủ Cookies xác thực (__Secure-1PSID).")
            print(" Máy chủ đã sẵn sàng phục vụ ứng dụng Shimy trên iPhone!")
            print("=" * 68 + "\n")
            return True
        else:
            print("\n[!] Chưa lấy được cookie __Secure-1PSID. Vui lòng đăng nhập lại.")
            return False


if __name__ == "__main__":
    run_google_login()
