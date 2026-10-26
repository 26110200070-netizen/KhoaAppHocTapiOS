# NHẬT KÝ QUY TRÌNH PHÁT TRIỂN & TÀI LIỆU KỸ THUẬT DỰ ÁN SHIMY iOS
> **Dự án:** Ứng dụng hỗ trợ tự học toàn diện cho học sinh THCS & THPT (Lớp 6 - 12)  
> **Nền tảng:** iOS 16.0+ (SwiftUI, WebKit, AVFoundation)  
> **Tác giả:** Anh Khoa Dev  
> **Thời gian thực hiện:** Tháng 09/2026 – Tháng 10/2026  

---

## I. NHẬT KÝ HÀNH TRÌNH TỪNG NGÀY (DEV LOG)

### -- Ngày 12/09/2026: Khảo sát thực tế & Đặt nền móng ý tưởng --
1. **Khảo sát thực tế:**
   - Dành nhiều ngày quan sát và khảo sát thói quen học tập của học sinh cấp 2 và cấp 3 xung quanh.
   - **Thực trạng nhức nhối:** Học sinh đang bị lạm dụng AI quá đà. Hễ gặp bài khó là copy-paste vào các con bot để lấy ngay đáp án cuối cùng chép vào vở đối phó. Tình trạng này khiến tư duy độc lập bị triệt tiêu, học sinh mất dần khả năng tự suy luận, tự tìm tòi, rơi vào tình trạng "thối não" và thụ động hoàn toàn.
   - **Vấn đề của các ứng dụng học tập hiện hành:** Các app trên thị trường phần lớn khóa tính năng sau vài lần dùng thử, thu phí định kỳ rất đắt đỏ đối với học sinh không tự chủ tài chính, hoặc nhồi nhét quá nhiều quảng cáo rác làm đứt gãy sự tập trung.
2. **Định hình giải pháp:**
   - Tại sao không xây dựng một ứng dụng học tập riêng, **hoàn toàn miễn phí 100% cho học sinh**, không quảng cáo?
   - Định hướng AI: **AI không giải bài hộ**, mà AI đóng vai trò như một người bạn gia sư (Tutor). AI chỉ đưa ra gợi ý phương pháp, giải thích bản chất kiến thức từ SGK chuẩn 2026, dẫn dắt học sinh tự tìm ra đáp án.

---

### -- Ngày 15/09/2026: Lựa chọn nền tảng & Ngôn ngữ --
1. Quyết định phát triển ứng dụng thuần cho hệ sinh thái **iOS** bằng ngôn ngữ **Swift & SwiftUI**, kết hợp **WebKit** để dựng giao diện bài giảng tương tác.
2. Xác định rõ đây là một thách thức kỹ thuật lớn: Tài liệu iOS của Apple rất đồ sộ và khắt khe, việc quản lý vòng đời ứng dụng (App Lifecycle), bộ nhớ, âm thanh chạy ngầm và tối ưu trải nghiệm chạm trên màn hình cảm ứng đòi hỏi sự tỉ mỉ cao.

---

### -- Ngày 16/09/2026: Khởi tạo Project & Prototype đầu tiên --
1. Thiết lập project Xcode với `project.yml` và công cụ XcodeGen để quản lý source code đồng bộ, phục vụ quy trình CI/CD tự động build file `.ipa` qua GitHub Actions.
2. Lập trình khung sườn ban đầu: Tạo màn hình Chat AI cơ bản kết nối API.
3. Nhận thấy nếu chỉ dừng lại ở giao diện chat thì app quá đơn điệu, không khác gì một vỏ bọc API thông thường. Cần phải có một hệ sinh thái học tập hoàn chỉnh: lý thuyết, luyện đề, tự học và thống kê tiến độ.

---

### -- Ngày 23/09/2026: Hoàn thiện kiến trúc tính năng tổng thể --
Quyết định xây dựng cấu trúc ứng dụng thành 7 khối chức năng gắn kết chặt chẽ:
1. **Học Lý Thuyết:** Cơ sở dữ liệu SGK chuẩn mới từ Lớp 6 đến Lớp 12, phân chia rõ ràng theo Môn học, Học kỳ, Chương và Bài học. Tích hợp video bài giảng thực tế và tóm tắt lý thuyết trọng tâm.
2. **Luyện Bài Tập (Thi Thử):** Học đi đôi với hành. Hệ thống tạo đề thi chuẩn cấu trúc Bộ GD&ĐT gồm 3 phần: Trắc nghiệm nhiều lựa chọn, Trắc nghiệm Đúng/Sai, và Câu hỏi trả lời ngắn.
3. **Treo Máy Tự Học (Focus Lock):** Phương pháp Pomodoro giúp học sinh chống nghiện điện thoại khi ngồi vào bàn học. Có đồng hồ đếm giờ, âm thanh tiếng mưa/sóng biển/rừng cây thư giãn, tặng Shimy Coin sau mỗi giờ học để nuôi pet chibi.
4. **Sơ Đồ Kiến Thức (Mindmap):** Hệ thống hóa bài học thành bản đồ tư duy logic để học sinh thấy được bức tranh tổng thể của từng chương.
5. **Sơ Đồ Thống Kê:** Biểu đồ trực quan ghi lại tổng thời gian học, số bài đã nạp, điểm trung bình các bài thi thử.
6. **Lịch Sử Học Tập:** Lưu vết toàn bộ tiến trình học, cho phép xem lại các bài giảng và đề thi đã làm.
7. **Trợ Lý Shimy AI:** Bạn đồng hành giải đáp thắc mắc, phân tích lỗi sai trong bài tập.

---

### -- Ngày 24/09/2026 - 08/10/2026: Lập trình lõi (Core Implementation) --
1. Xây dựng kho dữ liệu chương trình học khổng lồ: `SubjectCurriculumStore`, `MathCurriculumStore`, cấu trúc phân cấp từ Lớp 6 đến 12.
2. Triển khai trình phát video bài giảng YouTube bằng `WKWebView`.
3. Lập trình bộ đếm giờ Pomodoro và cơ chế âm thanh chạy nền `AmbientSoundService`.
4. Gặp phải hàng loạt lỗi hóc búa về audio session, WebView crash và tràn bộ nhớ khi học sinh chuyển qua lại giữa các bài giảng. Tiến hành tối ưu hóa bộ nhớ và hủy timer đúng lúc.

---

### -- Ngày 15/10/2026 - 24/10/2026: Hoàn thiện tính năng & Kiểm thử đa thiết bị --
1. Hoàn thiện tính năng thi thử trắc nghiệm có chấm điểm tự động và giải thích chi tiết từng câu.
2. Thiết kế thanh điều hướng uốn cong độc đáo (Curved Tab Bar) có rãnh scoop notch nổi ở giữa cho nút Shimy AI.
3. Tích hợp pipeline CI/CD GitHub Actions trên runner macOS-14 tự động build ra file unsigned `.ipa` cài đặt trực tiếp qua TrollStore / Sideloadly / AltStore.

---

### -- Ngày 25/10/2026 - 26/10/2026: Tối ưu UI/UX & Đại tu thiết kế (Taste-Skill) --
1. **Cuộc cách mạng xóa bỏ "Khung lồng khung":** Nhận thấy giao diện cũ dùng quá nhiều card bo góc lồng nhau gây nặng nề, chuyển toàn bộ 6 màn hình cốt lõi (Lịch sử, Thi thử, Sơ đồ tư duy, Thống kê, Tài khoản, Đăng nhập) sang phong cách Apple HIG Inset Grouped và thiết kế typographic đơn tầng.
2. **Tích hợp Từ Điển Bách Khoa (Free Dictionary API):**
   - Ban đầu thử nghiệm module học từ vựng CEFR theo danh sách thủ công, nhưng nhận thấy kho từ vựng bị giới hạn và tab bar bị chật chội.
   - Quyết định thay thế toàn bộ bằng việc tích hợp trực tiếp **Free Dictionary API** với hơn **8.500.000 từ vựng** lấy nguồn từ English Wiktionary.
   - Đưa nút vào từ điển thành Banner chuyên đề trên Trang Chủ, khôi phục thanh Tab Bar về chuẩn 3 nút thanh thoát: Trang Chủ - Shimy - Tài Khoản.
   - Sửa dứt điểm lỗi ký tự mã hóa URL (`%20`), bóc tách toàn bộ khung hộp bên trong từ điển, đưa về giao diện đọc thuần văn bản phẳng (Pure Typography) cực kỳ sang trọng và dễ đọc.
3. Hoàn thành đóng gói bản build phát hành `v1.2.1 (Build 68)`.

---

## II. BẢNG TỔNG HỢP NHỮNG LỖI CHÍ MẠNG ĐÃ GẶP & CÁCH KHẮC PHỤC

Trong suốt quá trình phát triển, dự án đã đối mặt với những lỗi kỹ thuật rất phức tạp, từ cấp độ hệ điều hành iOS, WebKit cho đến logic AI và thuật toán xử lý dữ liệu:

### 1. Lỗi nhúng video YouTube (Mã lỗi 150, 152, 153 & WebKit Same-Origin Policy)
- **Hiện tượng:** Khi nhúng thẻ `iframe` của YouTube vào `WKWebView` để học sinh xem bài giảng, video báo lỗi màn hình đen: *"Video này không hoạt động"* hoặc báo lỗi kiểm duyệt bản quyền mã 152 / 153.
- **Nguyên nhân sâu xa:** 
  - Code ban đầu sử dụng `baseURL` là `https://www.youtube-nocookie.com`.
  - Cơ chế bảo mật trình duyệt WebKit của iOS nhận diện đây là hành vi giả mạo cùng miền (Same-Origin Spoofing Detection). Khi gọi nhúng iframe bên trong một view có baseURL giả mạo, WebKit gửi header `Referer` kèm `Sec-Fetch-Site: same-origin`. Máy chủ YouTube lập tức phát hiện tên miền của app không phải trang web thật của YouTube và kích hoạt chặn bản quyền.
- **Cách khắc phục:**
  - Thay đổi `baseURL` sang bundle identifier chuẩn của app hoặc origin hợp lệ.
  - Cấu hình thẻ meta `referrerpolicy="strict-origin-when-cross-origin"`.
  - Tinh chỉnh `WKWebViewConfiguration`: cho phép phát inline (`allowsInlineMediaPlayback = true`), vô hiệu hóa yêu cầu tương tác người dùng ban đầu (`mediaTypesRequiringUserActionForPlayback = []`).

---

### 2. Lỗi AI Hallucination (Ảo giác) tự bịa Video ID không tồn tại
- **Hiện tượng:** Khi học sinh chọn một bài học mới để học lý thuyết, AI tự động sinh nội dung bài học kèm theo một chuỗi YouTube Video ID ngẫu nhiên. Khi bấm vào xem thì video báo *"Video không khả dụng"* vì ID đó không hề có thật trên YouTube. Nhưng khi vào màn hình Lịch sử thì một số bài cũ lại xem được bình thường.
- **Nguyên nhân:** Mô hình ngôn ngữ lớn (LLM) không thể tự ghi nhớ chính xác hàng triệu mã Video ID 11 ký tự của YouTube. Nếu để AI tự do sinh ID, nó sẽ bịa ra các chuỗi ký tự ngẫu nhiên trông giống Video ID.
- **Cách khắc phục:**
  - Thiết lập cơ sở dữ liệu ánh xạ cố định `trithucAI` (Curriculum Store).
  - Tất cả các môn học (Toán, Lý, Hóa, Sinh, Văn, Sử, Địa, GDCD, Tin học, Tiếng Anh từ lớp 6 - 12) đều được biên soạn sẵn danh sách Video ID chuẩn xác 100% từ các bài giảng uy tín đã được kiểm duyệt nội dung.
  - Tước bỏ hoàn toàn quyền sinh Video ID của AI; tầng Service bắt buộc phải lấy Video ID chuẩn từ Store gán vào bài học.

---

### 3. Lỗi ứng dụng bị Reset khi học sinh vuốt ra ngoài (Backgrounding)
- **Hiện tượng:** Khi đang học hoặc làm dở bài tập, học sinh vuốt ra màn hình chính để mở ứng dụng máy tính hoặc xem tin nhắn, khi bấm quay lại Shimy thì ứng dụng bị reset về đầu, chạy lại màn hình intro 2 giây và mất toàn bộ bài tập đang làm.
- **Nguyên nhân:** 
  - Ứng dụng không phân biệt được giữa hai sự kiện: **App bị tắt hẳn (Terminate)** và **App chạy nền tạm thời (Background / Inactive)**.
  - Trạng thái `hasSeenIntro` bị khởi tạo lại hoặc view hierarchy bị reload khi `ScenePhase` thay đổi.
- **Cách khắc phục:**
  - Sử dụng `@Environment(\.scenePhase)` trong SwiftUI để theo dõi chính xác trạng thái của app.
  - Lưu cờ `hasSeenIntro` vào bộ nhớ tạm của phiên chạy (`AppState`). Chỉ khi nào app bị tắt hẳn khỏi thanh đa nhiệm và mở lại từ đầu thì mới chạy video intro ngắn. Nếu chỉ vuốt ra ngoài rồi quay lại, giữ nguyên 100% trạng thái màn hình hiện tại.

---

### 4. Lỗi giao diện "Khung lồng khung lồng chữ" (Nested Bounding Boxes)
- **Hiện tượng:** Giao diện app bị tình trạng hộp lồng trong hộp: Một thẻ trắng to bọc bên ngoài, bên trong chứa một khung màu xám, trong khung màu xám lại chứa một khung màu xanh bọc chữ. Trông giao diện chật chội, tù túng, mất thẩm mỹ và gây mỏi mắt.
- **Cách khắc phục:**
  - Áp dụng nguyên lý thiết kế **Taste Skill** và **Apple Human Interface Guidelines (HIG)**.
  - Phá bỏ hoàn toàn các khung bọc thừa thãi.
  - Chuyển sang định dạng **đơn tầng (Single-layer surface)**: Nền trắng phẳng, phân cấp thông tin bằng độ lớn font chữ (Hierarchy Typography: Title bold 34pt, Body 15pt, Caption 12pt), sử dụng khoảng thở tự nhiên (padding, spacing) và đường kẻ hairline mảnh `0.5pt` thay vì dùng các khối hộp đóng kín.

---

### 5. Lỗi giao diện bị cắt nửa màn hình và chèn khoảng trống xám
- **Hiện tượng:** Khi tích hợp màn hình học tiếng Anh/từ điển vào app, phía trên đầu xuất hiện một khoảng trống màu xám chiếm đến 40% màn hình, nội dung bị đẩy tụt xuống dưới.
- **Nguyên nhân:** View được đặt trong `ZStack` chung với trang chủ nhưng lại không đồng bộ về safe area; ảnh banner dùng fixed height kết hợp scaleToFill không có alignment rõ ràng khiến view bị co cụm ở giữa màn hình.
- **Cách khắc phục:**
  - Chuyển màn hình chuyên đề (như Từ điển, Mindmap, Thi thử) sang cơ chế trình chiếu toàn màn hình độc lập `.fullScreenCover(isPresented:)`.
  - Cấu hình `Color.white.ignoresSafeArea()` cho toàn bộ nền và giữ các thành phần điều khiển bên trong Safe Area tự nhiên của từng dòng máy iPhone (Dynamic Island / Tai thỏ).

---

### 6. Lỗi nghẽn thanh điều hướng (Overcrowded Tab Bar)
- **Hiện tượng:** Khi cố gắng nhét thêm tab "Tiếng Anh" vào thanh Tab Bar uốn cong rãnh scoop, diện tích các nút bị bóp nghẹt, chữ bị tràn hàng, nút tròn Shimy AI ở giữa bị chèn ép mất cân đối.
- **Cách khắc phục:**
  - Giữ vững cấu trúc nhận diện thương hiệu nguyên bản của Shimy: **Trang Chủ (Trái) - Shimy AI (Giữa nổi) - Tài Khoản (Phải)**.
  - Toàn bộ các tính năng mở rộng (Từ điển 8.5M từ, Luyện đề, Lý thuyết, Mindmap, Thống kê) được tổ chức thành các Banner tương tác trực quan ngay tại Trang Chủ. Bấm vào banner sẽ mở ra không gian học tập chuyên sâu toàn màn hình.

---

### 7. Lỗi chữ bị dính ký tự mã hóa URL `%20` và HTML entities
- **Hiện tượng:** Khi tra cứu từ điển, dòng dịch nghĩa tiếng Việt bị dính các ký tự lạ: `% 20combined% 20application % 20of...`, `Máy%20hoặc%20equipment...`.
- **Nguyên nhân:** Dữ liệu dịch qua mạng bị mã hóa URL (URL percent-encoding) nhưng không được giải mã trước khi hiển thị ra giao diện; một số chuỗi bị mã hóa 2 lần (double-encoded).
- **Cách khắc phục:**
  - Xây dựng thuật toán làm sạch chuỗi `cleanText`:
    1. Chạy vòng lặp giải mã `removingPercentEncoding` 2 lượt.
    2. Dùng `replacingOccurrences` triệt tiêu mọi biến thể sót lại của `%20`, `%2C`, `%2E`, `%27`, `%22`.
    3. Giải mã các thực thể HTML phổ biến (`&quot;`, `&#39;`, `&amp;`, `&lt;`, `&gt;`).
    4. Gộp các khoảng trắng liên tiếp thành khoảng trắng đơn.

---

### 8. Lỗi Rate Limit HTTP 429 khi tra cứu từ điển
- **Hiện tượng:** Khi mở một từ có 10-15 định nghĩa, ứng dụng đồng loạt bắn 15 request dịch qua mạng trong tích tắc, dẫn đến việc máy chủ chặn IP vì nghi ngờ tấn công DDoS (HTTP 429 Too Many Requests).
- **Cách khắc phục:**
  - Thiết kế cơ chế bướm ga (Throttle): Chỉ dịch tự động nghĩa chính của từ và tối đa 4 định nghĩa quan trọng nhất của từng từ loại.
  - Thiết lập **Bộ đệm hai tầng (Dual-layer Cache)**: Khi người dùng tra lại từ đã từng xem, app lấy ngay từ RAM cache với thời gian đáp ứng O(1), không tốn thêm bất kỳ request mạng nào.

---

## III. HỆ THỐNG THUẬT TOÁN & KỸ THUẬT CỐT LÕI TRONG SHIMY

### 1. Thuật toán Pomodoro & Cơ chế Vòng lặp Gamification (Treo máy học tập)
- **Mục tiêu:** Giúp học sinh duy trì sự tập trung cao độ, đánh bại cảm giác buồn ngủ và sự cám dỗ của mạng xã hội.
- **Nguyên lý hoạt động:**
  - Sử dụng Combine Publisher `Timer.publish(every: 1.0, on: .main, in: .common)` để tính toán thời gian học tập liên tục.
  - Tích hợp phát nhạc nền sóng não (Binaural Beats / White Noise / Tiếng mưa rơi / Quán cafe) qua `AVAudioPlayer` với số lần lặp vô tận (`numberOfLoops = -1`).
  - **Thuật toán thưởng Shimy Coin:**
    $$\text{Coins Earned} = \left\lfloor \frac{\Delta t_{\text{study}}}{3600} \right\rfloor$$
    Cứ mỗi 3600 giây (60 phút) học tập thực tế không thoát app, hệ thống kích hoạt hàm cộng thưởng 1 Shimy Coin vào tài khoản học sinh, lưu trữ vĩnh viễn qua `UserDefaults`. Coin này dùng để mở khóa các bé pet Chibi đáng yêu đồng hành trên bàn học.

---

### 2. Thuật toán Bóc tách & Khử lỗi JSON Sinh Đề Thi AI (Sanitize & Robust Parser)
- **Mục tiêu:** Đảm bảo khi AI tạo đề thi trắc nghiệm (10, 20 hoặc 40 câu), ứng dụng không bao giờ bị crash kể cả khi AI trả về chuỗi markdown bị lỗi định dạng.
- **Nguyên lý hoạt động:**
  1. **Trích xuất khối JSON:** Sử dụng Regular Expression với cờ dot-matches-all:
     ```regex
     (?s)```(?:json)?\s*(.*?)\s*```
     ```
     Nếu AI bọc kết quả trong block code markdown, biểu thức chính quy sẽ trích xuất phần JSON thuần bên trong.
  2. **Chuẩn hóa cấu trúc câu hỏi:**
     - Phân loại đề thi thành 3 nhóm câu hỏi chuẩn Bộ GD&ĐT:
       - `multiple_choice` (4 lựa chọn A, B, C, D - duy nhất 1 đáp án đúng).
       - `true_false` (1 câu chủ đề kèm 4 ý a, b, c, d - mỗi ý chọn Đúng hoặc Sai).
       - `short_answer` (Học sinh tự điền số hoặc từ ngắn).
  3. **Auto-fallback:** Nếu JSON bị đứt đoạn do mạng chập chờn, thuật toán kích hoạt bộ đề thi mẫu đã được biên soạn sẵn tương ứng với bài học đó, đảm bảo trải nghiệm thi thử của học sinh không bao giờ bị gián đoạn.

---

### 3. Thuật toán Bản Đồ Tri Thức (Knowledge Mindmap Tree & Topological Sort)
- **Mục tiêu:** Trực quan hóa toàn bộ kiến thức một học kỳ thành một cây phân cấp logic, giúp học sinh biết bài nào quan trọng nhất cần ưu tiên ôn tập.
- **Cấu trúc dữ liệu:** Mô hình hóa chương trình học thành đồ thị dạng cây (Directed Tree Graph):
  $$\text{Root (Lớp)} \longrightarrow \text{Branch (Môn học)} \longrightarrow \text{Semester (Học kỳ)} \longrightarrow \text{Chapter (Chương)} \longrightarrow \text{Lesson (Bài học)}$$
- **Trọng số kiến thức (Knowledge Weight):** Mỗi bài học được gán các chỉ số:
  - Cấp độ nhận thức: `Nhận biết`, `Thông hiểu`, `Vận dụng`, `Vận dụng cao`.
  - Tần suất xuất hiện trong đề thi học kỳ / thi vào 10 / thi tốt nghiệp THPT.
  - Thuật toán sắp xếp hiển thị các chương trọng tâm lên hàng đầu để học sinh nắm chắc kiến thức nền tảng trước khi bước sang chuyên đề nâng cao.

---

### 4. Thuật toán Tự Động Hoàn Thành & Tìm Kiếm Từ Vựng (Autocomplete Engine)
- **Mục tiêu:** Gợi ý tức thì từ vựng học sinh đang nhập với tốc độ dưới 16ms (chuẩn 60fps).
- **Thuật toán xếp hạng 3 tầng ưu tiên:**
  Cho chuỗi truy vấn đầu vào $q$, tập từ vựng $W$:
  1. **Tầng 1 (Prefix Match - Tuyệt đối):**
     $$W_1 = \{w \in W \mid w.\text{word}.\text{startsWith}(q)\}$$
  2. **Tầng 2 (Meaning Match - Nghĩa tiếng Việt):**
     $$W_2 = \{w \in W \setminus W_1 \mid w.\text{meaningVI}.\text{contains}(q)\}$$
  3. **Tầng 3 (Substring Match - Chứa chuỗi):**
     $$W_3 = \{w \in W \setminus (W_1 \cup W_2) \mid w.\text{word}.\text{contains}(q)\}$$
  - Kết quả trả về: $\text{Result} = \text{Top}_K(W_1 \cup W_2 \cup W_3)$.
- **Cơ chế Debounce:** Dùng bộ đếm thời gian trễ $600\text{ms}$ (`debounceTimer`) để gom các thao tác gõ phím liên tục của học sinh, ngăn chặn việc gọi API dịch lãng phí khi học sinh chưa gõ xong từ.

---

### 5. Chiến Lược Bộ Đệm Hai Tầng (Dual-Layer Cache Architecture)
- **Mục tiêu:** Giảm 85% tải lưu lượng mạng, cho phép xem lại các từ đã tra cứu ngay lập tức kể cả khi mất kết nối Internet.
- **Sơ đồ vận hành:**
  ```
  [Yêu cầu tra từ: "technology"]
               │
               ▼
  Kiểm tra Tầng 1: RAM Cache ([String: FreeDictionaryResponse])
               ├──> [CÓ] ──> Trả về kết quả ngay lập tức (0ms)
               └──> [KHÔNG]
                      │
                      ▼
  Kiểm tra Tầng 2: Local Disk Cache (Tệp lưu trữ cục bộ)
               ├──> [CÓ] ──> Nạp vào RAM Cache & Trả về kết quả
               └──> [KHÔNG]
                      │
                      ▼
  Gọi Free Dictionary API qua HTTPS Network
                      │
                      ▼
  Lưu kết quả mới vào RAM Cache + Disk Cache
  ```

---

### 6. Quản Lý Âm Thanh Đa Kênh & AVSpeechSynthesizer Audio Ducking
- **Mục tiêu:** Học sinh có thể nghe phát âm chuẩn bản ngữ từng từ vựng hoặc ví dụ tiếng Anh trong khi nhạc nền lofi tự học vẫn đang chạy ngầm mà không bị xung đột âm thanh.
- **Giải pháp kỹ thuật:**
  - Sử dụng `AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])`.
  - Khi học sinh bấm nút phát âm một từ vựng, `AVSpeechSynthesizer` cất tiếng đọc (`rate = 0.46` rõ ràng từng âm tiết IPA), iOS sẽ tự động hạ nhỏ âm lượng của nhạc nền xuống 20% (`ducking`).
  - Ngay khi phát âm xong, âm lượng nhạc nền tự động nâng về mức ban đầu một cách êm ái.

---

## IV. TỔNG KẾT & ĐỊNH HƯỚNG TƯƠNG LAI

Dự án **Shimy iOS** đã đi từ một ý tưởng trăn trở về việc học sinh đang bị thụ động hóa bởi AI, trải qua hơn 45 ngày nghiên cứu, thiết kế và lập trình bền bỉ, vượt qua hàng loạt thách thức kỹ thuật về nhúng video, xử lý ngôn ngữ, quản lý bộ nhớ và chuẩn hóa giao diện người dùng.

Ứng dụng hiện tại đạt độ hoàn thiện cao:
- **Chuẩn giao diện:** Tối giản, hiện đại, không khung lồng khung, lấy trải nghiệm đọc hiểu và học tập của học sinh làm trung tâm.
- **Chuẩn dữ liệu:** Bám sát chương trình giáo dục phổ thông mới và tích hợp từ điển bách khoa Wiktionary 8.5 triệu từ chuẩn quốc tế.
- **Chuẩn đạo đức học tập:** Giúp học sinh học sâu, hiểu bản chất, rèn luyện tính tự giác và tư duy độc lập.
