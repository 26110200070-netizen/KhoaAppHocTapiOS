# 📱 KhoaStudy - Ứng Dụng Học Tập Thông Minh iOS

> **KhoaStudy** là ứng dụng học tập toàn diện dành cho học sinh THCS (Lớp 6 - 9) và THPT (Lớp 10 - 12) theo chuẩn chương trình Sách Giáo Khoa (SGK) Bộ GD&ĐT, tích hợp trí tuệ nhân tạo **DeepSeek AI** cùng giao diện người dùng **Light UI bo tròn mượt mà** đẳng cấp.

---

## ✨ Tính Năng Nổi Bật

### 1. 📖 Học Lí Thuyết Chuẩn SGK
- Video bài giảng trực quan mô phỏng bài giảng AI.
- Tài liệu tóm tắt kiến thức trọng tâm từng bài / từng chương.
- Khung công thức nổi bật với họa tiết bắt mắt và ghi chú các bẫy thường gặp trong đề thi.
- Ví dụ mẫu có lời giải từng bước rõ ràng.

### 2. ✍️ Làm Bài Tập & Luyện Đề
- Tùy chọn linh hoạt số lượng câu hỏi: **5, 10, 20 hoặc 40 câu**.
- Làm trắc nghiệm trực tiếp trên app với giao diện bo tròn hiện đại.
- Chấm điểm tức thì (thang điểm 10).
- Lời giải chi tiết cho **tất cả các câu** (dù làm đúng hay sai).
- Kèm dòng ghi chú xuất xứ: `Bài tập thuộc bài [A] chương [B]`.
- Hỗ trợ xuất đề và lời giải ra file Word (.docx).

### 3. ⏱️ Treo Máy Tự Học (Khóa Máy Tập Trung)
- Chế độ Pomodoro tự học 25 phút / 50 phút.
- Giao diện Dark Emerald sang trọng mô phỏng theo dõi tập trung.
- Tích hợp âm thanh tự nhiên (tiếng mưa, sóng biển, thư viện).
- Chặn xao nhãng và ghi nhận tổng số phút học trong ngày.

### 4. 👤 Quản Lý Tài Khoản & Song Ngữ
- Đăng nhập và kết nối với **DeepSeek API** (Local server hoặc API Key).
- Chuyển đổi nhanh giữa các tài khoản học sinh.
- Chuyển đổi song ngữ **Tiếng Việt 🇻🇳** và **English 🇺🇸**.

---

## 🚀 Tự Động Build Ra File `.ipa` (GitHub Actions)

Mỗi khi có code mới đẩy lên nhánh `main`, **GitHub Actions (máy chủ macOS)** sẽ tự động:
1. Tạo dự án Xcode với `xcodegen`.
2. Biên dịch mã nguồn Swift bằng `xcodebuild`.
3. Đóng gói thành file `KhoaStudy_Unsigned.ipa`.
4. Xuất bản lên tab **Releases** và **Artifacts** để tải về cài đặt.

---
Bản quyền ứng dụng © **Anh Khoa Dev**.
