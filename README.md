# 📱 Shimy (KhoaStudy) - Ứng Dụng Học Tập & Luyện Thi AI iOS

> **Shimy** là ứng dụng học tập toàn diện dành cho học sinh THCS (Lớp 6 - 9) và THPT (Lớp 10 - 12) theo chuẩn chương trình Sách Giáo Khoa mới của Bộ GD&ĐT, tích hợp trí tuệ nhân tạo **Google Gemini AI** (thông qua Gateway trung gian bảo vệ chống chặn) cùng giao diện **Light UI bo tròn mượt mà** đẳng cấp iOS.

---

## 🏛️ Kiến Trúc Hệ Thống (Architecture)

```
iOS App — SwiftUI
(Đăng ký · Đăng nhập · Chat AI · Lịch sử chat · Cài đặt)
        │
        │ HTTPS · Token xác thực của app (Bearer Token)
        ▼
Backend API của bạn (FastAPI - Port 8000)
(Xác thực · Phân quyền · Giới hạn lượt dùng · Kiểm tra yêu cầu)
        │
        │ Anti-Google Block (Jitter delay, Concurrency queue, Cookie rotation)
        ▼
Gemini Web To API (Port 4981) / Direct Gemini Web
(Lớp chuyển tiếp yêu cầu tới Gemini Web)
        │
        ▼
Google Gemini
(Sinh nội dung AI: Gemini 2.5 Flash, Gemini 2.5 Pro, Gemini Thinking)
```

---

## ✨ Tính Năng Nổi Bật

### 1. 🤖 Chat Trợ Lý Gia Sư Shimy (Google Gemini)
- Lựa chọn linh hoạt giữa 4 mô hình:
  * **Shimy Flash (Gemini 2.5 Flash)**: Phản hồi siêu tốc, trả lời nhanh các câu hỏi lý thuyết.
  * **Shimy Pro (Gemini 2.5 Pro)**: Chuyên gia giải toán, lý, hóa chuyên sâu.
  * **Shimy Think (Gemini Thinking)**: Suy luận sâu từng bước, diễn giải logic chi tiết.
  * **Shimy Auto**: Tự động chọn mô hình tối ưu theo độ khó của câu hỏi.
- **Giải toán qua ảnh (Multimodal Vision)**: Chụp hoặc tải ảnh đề bài từ thư viện ảnh iPhone để AI phân tích và giải chi tiết.
- **Google Search Grounding (Tìm kiếm Web)**: Tra cứu kiến thức SGK mới nhất của Bộ GD&ĐT (Kết Nối Tri Thức, Cánh Diều, Chân Trời Sáng Tạo).
- **Hỗ trợ công thức Toán LaTeX**: Hiển thị bảng biểu, phân số, căn thức toán học đẹp mắt.

### 2. 📝 Sinh Đề Thi Chuẩn SGK Bằng AI
- Tự động sinh đề kiểm tra theo khối lớp (6-12), học kỳ (1-2) và chủ đề trọng tâm do học sinh nhập.
- Đúng cấu trúc đề mới của Bộ GD&ĐT:
  * Phần 1: Trắc nghiệm 4 lựa chọn (A, B, C, D).
  * Phần 2: Câu hỏi Đúng / Sai (ngữ cảnh + 4 ý a, b, c, d).
  * Phần 3: Trả lời ngắn điền số hoặc đơn vị.
- Tự động chấm điểm và xem lại lời giải chi tiết cho từng câu.

### 3. 🛡️ Cơ Chế Bảo Vệ Chống Google Chặn (Anti-Google Block)
- **Jitter Delay**: Giả lập độ trễ tự nhiên giữa các thao tác (300ms - 700ms), loại bỏ dấu hiệu bot quét dồn dập.
- **Kiểm soát đồng thời (Concurrency Lock)**: Giới hạn tối đa 2 request song song tới Gemini Web, xếp hàng thông minh.
- **Hạn mức sử dụng (Daily Quotas & Rate Limits)**: 25 requests/phút, 150 câu hỏi/ngày cho học sinh.
- **Phiên làm việc tự động (Session Cookie Refresh)**: Chu kỳ làm mới 24h (1440 phút) an toàn.
- **Dự phòng đám mây (Smart Fallback)**: Tự động dự phòng sang Google AI Studio API (`AIza...`) nếu cookie web cần đăng nhập lại.

### 4. ⏱️ Treo Máy Tự Học (Khóa Máy Tập Trung Pomodoro)
- Chế độ tự học 25 phút / 50 phút.
- Giao diện Dark Emerald sang trọng mô phỏng theo dõi tập trung.
- Tích hợp âm thanh tự nhiên (tiếng mưa, sóng biển, thư viện).

---

## 🖥️ Hướng Dẫn Chạy Máy Chủ Trên Máy Tính

1. Nhấp đúp vào file **`run_gemini_server.bat`** trên máy tính.
2. Trình duyệt Chromium sẽ tự động mở lên trang **`https://gemini.google.com`**.
3. Bạn đăng nhập tài khoản Google của mình một lần duy nhất.
4. Cửa sổ trình duyệt tự động đóng và máy chủ khởi chạy trên cổng **`8000`** (`http://192.168.2.16:8000/v1`).
5. Mở ứng dụng Shimy trên iPhone (cùng mạng Wi-Fi) và bắt đầu học tập!

---

## 🚀 Tự Động Build Ra File `.ipa` (GitHub Actions)

Mỗi khi có code mới đẩy lên nhánh `main`, **GitHub Actions (máy chủ macOS)** sẽ tự động:
1. Tạo dự án Xcode với `xcodegen`.
2. Biên dịch mã nguồn Swift bằng `xcodebuild`.
3. Đóng gói thành file **`Shimy_Unsigned.ipa`** và **`KhoaStudy_Unsigned.ipa`**.
4. Xuất bản lên tab **Releases** và **Artifacts** để cài qua **ESign**, **Scarlet**, **Sideloadly** hoặc **TrollStore**.

---
Bản quyền ứng dụng © **Anh Khoa Dev**.
