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
    print("[*] Sau khi đăng nhập thành công, cửa sổ sẽ tự động đóng và lưu cookie!")
    print("=" * 68)

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
        
        page = browser_context.new_page()
        page.goto("https://gemini.google.com/app", wait_until="networkidle", timeout=60000)

        # Loop and check for cookies
        captured_cookies = ""
        found_psid = ""
        found_psidts = ""

        print("\n[*] Đang đợi bạn đăng nhập vào Google Gemini...")
        for attempt in range(120):  # Wait up to 4 minutes
            time.sleep(2)
            cookies_list = browser_context.cookies("https://gemini.google.com")
            
            cookie_dict = {}
            for c in cookies_list:
                name = c.get("name")
                val = c.get("value")
                cookie_dict[name] = val
                if name == "__Secure-1PSID":
                    found_psid = val
                elif name == "__Secure-1PSIDTS":
                    found_psidts = val

            if found_psid:
                # Format full Cookie string
                cookie_parts = [f"{k}={v}" for k, v in cookie_dict.items()]
                captured_cookies = "; ".join(cookie_parts)
                print("\n[OK] Đã phát hiện thấy phiên đăng nhập Google hợp lệ!")
                if found_psidts:
                    print("[OK] Đã trích xuất đầy đủ __Secure-1PSID và __Secure-1PSIDTS!")
                break
                
            # If user already navigated to chat box
            if "app" in page.url and (page.locator("textarea").count() > 0 or page.locator("rich-textarea").count() > 0):
                cookie_parts = [f"{c.get('name')}={c.get('value')}" for c in cookies_list]
                captured_cookies = "; ".join(cookie_parts)
                print("\n[OK] Đã vào trang trò chuyện Gemini!")
                break

        browser_context.close()

        if captured_cookies:
            gemini_bridge.save_session(captured_cookies, psid=found_psid, psidts=found_psidts)
            print("\n" + "=" * 68)
            print(" [SUCCESS] LƯU PHIÊN GOOGLE GEMINI THÀNH CÔNG!")
            print(" Máy chủ đã sẵn sàng phục vụ ứng dụng Shimy trên iPhone!")
            print("=" * 68 + "\n")
            return True
        else:
            print("\n[!] Chưa đăng nhập được hoặc đã đóng trình duyệt trước khi hoàn tất.")
            return False


if __name__ == "__main__":
    run_google_login()
