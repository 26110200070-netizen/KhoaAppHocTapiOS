import Foundation

/// Kho dữ liệu chương trình học chuẩn hóa cho 6 môn học (Toán, Vật lí, Hóa học, Sinh học, Lịch sử, Địa lí)
/// Dữ liệu và liên kết video bài giảng YouTube được đồng bộ 100% từ thư mục trithucAI
struct SubjectCurriculumStore {
    static let shared = SubjectCurriculumStore()
    private init() {}

    func getTopics(subject: String, grade: Int, semester: Int) -> [TheoryTopicItem] {
        var s = subject.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if s == "vật lý" { s = "vật lí" }
        if s == "địa lý" { s = "địa lí" }
        
        switch (s, grade, semester) {
        case ("toán", 6, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g6_s1_1",
                    title: "I. Số học và Đại số",
                    summary: "",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "gUtIhlCluwI",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g6_s1_2",
                    title: "1. Tập hợp và Số tự nhiên",
                    summary: "Tập hợp và phần tử:** Ký hiệu thuộc ($\\in$) và không thuộc ($\\notin$). Cách viết một tập hợp bằng cách liệt kê phần tử hoặc chỉ ra tính chất đặc trưng.; Tập hợp các số tự nhiên:** Tập $\\mathbb{N}$ (từ số 0) và tập $\\mathbb{N}^*$ (từ số 1). Thứ tự trong tập hợp số tự nhiên.; Các phép tính trong tập hợp số tự nhiên:**",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "gUtIhlCluwI",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g6_s1_3",
                    title: "2. Tính chất chia hết trong tập hợp số tự nhiên",
                    summary: "Quan hệ chia hết:** Khái niệm ước và bội. Cách tìm tập hợp các ước Ư($a$) và tập hợp các bội B($a$).; Tính chất chia hết của một tổng:** Nếu tất cả các số hạng đều chia hết cho $m$ thì tổng chia hết cho $m$. Nếu có đúng một số hạng không chia hết cho $m$ (các số hạng còn lại đều chia hết) thì tổng không chia hết cho $m$.; Dấu hiệu chia hết:** Dấu hiệu chia hết cho 2, 5 (xét chữ số tận cùng) và cho 3, 9 (xét tổng các chữ số).",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "CAd3j9cHw0c",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g6_s1_4",
                    title: "3. Số nguyên",
                    summary: "Tập hợp số nguyên ($\\mathbb{Z}$):** Trục số nguyên, số đối của một số nguyên. Khái niệm số nguyên âm, số nguyên dương và số 0. So sánh hai số nguyên.; Các phép tính trong tập hợp số nguyên:**; Phép cộng hai số nguyên (cùng dấu, khác dấu). Tính chất phép cộng.",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "CGoCjPhhF5w",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g6_s1_5",
                    title: "II. Hình học trực quan (Hình học phẳng cơ bản)",
                    summary: "",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "FjOoJanifI0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 6, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g6_s2_1",
                    title: "I. Số học và Đại số (tiếp theo)",
                    summary: "",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "NS6bj4vIqqA",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g6_s2_2",
                    title: "1. Phân số",
                    summary: "Khái niệm phân số:** Mở rộng phân số với tử và mẫu là các số nguyên ($\\frac{a}{b}$ với $a, b \\in \\mathbb{Z}, b \\neq 0$). Hai phân số bằng nhau.; Tính chất cơ bản của phân số:** Nhân hoặc chia cả tử và mẫu với cùng một số nguyên khác 0.; Rút gọn phân số:** Đưa phân số về dạng tối giản bằng cách chia cả tử và mẫu cho ƯCLN của chúng.",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "NS6bj4vIqqA",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g6_s2_3",
                    title: "2. Số thập phân",
                    summary: "Khái niệm số thập phân:** Số thập phân âm, số thập phân dương. Số đối của số thập phân.; Các phép tính với số thập phân:** Cộng, trừ, nhân, chia số thập phân (tuân theo quy tắc đặt tính và quy tắc dấu tương tự số nguyên).; Làm tròn số và ước lượng:** Quy tắc làm tròn số đến một hàng đơn vị cho trước.",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "KfdwK2qJXwo",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g6_s2_4",
                    title: "II. Hình học phẳng (Điểm, Đường thẳng, Góc)",
                    summary: "",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "kHyIZtiPzOI",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g6_s2_5",
                    title: "III. Một số yếu tố Thống kê và Xác suất",
                    summary: "",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "Zs-BaHzZ63w",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 7, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g7_s1_1",
                    title: "I. Số học và Đại số",
                    summary: "",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "Hoq1PPwtnrg",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s1_2",
                    title: "1. Số hữu tỉ",
                    summary: "Tập hợp số hữu tỉ ($\\mathbb{Q}$):** Định nghĩa số hữu tỉ là số viết được dưới dạng phân số $\\frac{a}{b}$ với $a, b \\in \\mathbb{Z}, b \\neq 0$. Biểu diễn số hữu tỉ trên trục số và so sánh các số hữu tỉ.; Các phép tính trong tập hợp số hữu tỉ:**; Cộng, trừ, nhân, chia số hữu tỉ.",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "Hoq1PPwtnrg",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s1_3",
                    title: "2. Số thực",
                    summary: "Số thập phân hữu hạn và số thập phân vô hạn tuần hoàn:** Cách nhận biết và viết một phân số dưới dạng số thập phân.; Số vô tỉ:** Định nghĩa số vô tỉ là số viết được dưới dạng số thập phân vô hạn không tuần hoàn. Khái niệm căn bậc hai số học của một số không âm.; Tập hợp số thực ($\\mathbb{R}$):** Bao gồm số hữu tỉ và số vô tỉ. Trục số thực. So sánh các số thực.",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "UJFrZiG5Pkk",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s1_4",
                    title: "3. Tỉ lệ thức và Đại lượng tỉ lệ",
                    summary: "Tỉ lệ thức:** Định nghĩa $\\frac{a}{b} = \\frac{c}{d}$. Tính chất cơ bản của tỉ lệ thức ($a \\cdot d = b \\cdot c$).; Tính chất của dãy tỉ số bằng nhau:** $\\frac{a}{b} = \\frac{c}{d} = \\frac{e}{f} = \\frac{a+c+e}{b+d+f} = \\frac{a-c+e}{b-d+f}$ (với các mẫu số khác 0).; Đại lượng tỉ lệ thuận:** Định nghĩa $y = k \\cdot x$ ($k \\neq 0$ là hệ số tỉ lệ). Tính chất của hai đại lượng tỉ lệ thuận.",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "kN_D6JNDXqQ",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s1_5",
                    title: "II. Hình học trực quan và Hình học phẳng cơ bản",
                    summary: "",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "KjTq2mOwQNk",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s1_6",
                    title: "1. Hình khối trong thực tiễn",
                    summary: "Hình lăng trụ đứng tam giác, Hình lăng trụ đứng tứ giác:**; Mô tả định dạng, nhận biết đỉnh, cạnh, mặt đáy, mặt bên.; Công thức tính **Diện tích xung quanh ($S_{xq} = C_{đáy} \\cdot h$)** và **Thể tích ($V = S_{đáy} \\cdot h$)**.",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "KjTq2mOwQNk",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s1_7",
                    title: "2. Góc và Đường thẳng song song",
                    summary: "Góc ở vị trí đặc biệt:** Hai góc kề bù (có tổng bằng $180^\\circ$), hai góc đối đỉnh (thì bằng nhau). Tia phân giác của một góc.; Hai đường thẳng song song:**; Dấu hiệu nhận biết: Nếu đường thẳng $c$ cắt hai đường thẳng $a, b$ và trong các góc tạo thành có một cặp góc so le trong bằng nhau hoặc một cặp góc đồng vị bằng nhau thì $a // b$.",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "LtWBlV6gLvw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 7, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g7_s2_1",
                    title: "I. Số học và Đại số (tiếp theo)",
                    summary: "",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "osh7Po4Q0cM",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s2_2",
                    title: "1. Biểu thức đại số và Đa thức một biến",
                    summary: "Biểu thức đại số:** Khái niệm biểu thức đại số, tính giá trị của một biểu thức đại số tại giá trị cho trước của biến.; Đa thức một biến:**; Định nghĩa, thu gọn đa thức.",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "osh7Po4Q0cM",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s2_3",
                    title: "II. Hình học phẳng (Tam giác)",
                    summary: "",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "CXf-DO0fN9g",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s2_4",
                    title: "1. Tam giác và Các trường hợp bằng nhau",
                    summary: "Tổng các góc trong một tam giác:** Bằng $180^\\circ$.; Hai tam giác bằng nhau:** Định nghĩa hai tam giác bằng nhau.; Ba trường hợp bằng nhau của tam giác:**",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "CXf-DO0fN9g",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s2_5",
                    title: "2. Quan hệ giữa các yếu tố trong tam giác",
                    summary: "Quan hệ giữa góc và cạnh đối diện:** Trong một tam giác, góc đối diện với cạnh lớn hơn là góc lớn hơn và ngược lại.; Quan hệ giữa đường vuông góc và đường xiên:** Đường vuông góc là đường ngắn nhất trong các đường kẻ từ một điểm đến một đường thẳng.; Bất đẳng thức tam giác:** Trong một tam giác, tổng độ dài hai cạnh bất kỳ bao giờ cũng lớn hơn độ dài cạnh còn lại ($a + b > c$).",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "BjIKQ2J0JqM",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s2_6",
                    title: "3. Các đường đồng quy trong tam giác",
                    summary: "Đường trung tuyến:** Ba đường trung tuyến đồng quy tại một điểm gọi là **Trọng tâm**. Trọng tâm cách mỗi đỉnh một khoảng bằng $\\frac{2}{3}$ độ dài đường trung tuyến đi qua đỉnh đó.; Đường phân giác:** Ba đường phân giác đồng quy tại một điểm cách đều ba cạnh của tam giác (tâm đường tròn nội tiếp).; Đường trung trực:** Ba đường trung trực của tam giác đồng quy tại một điểm cách đều ba đỉnh của tam giác (tâm đường tròn ngoại tiếp).",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "kgAGfVfEWTo",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s2_7",
                    title: "III. Thống kê và Xác suất",
                    summary: "",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "NN3oA3Z_Ock",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s2_8",
                    title: "1. Thu thập, biểu diễn và phân tích dữ liệu",
                    summary: "Biểu đồ đoạn thẳng:** Đọc, phân tích thông tin và vẽ biểu đồ đoạn thẳng biểu diễn xu hướng thay đổi của dữ liệu theo thời gian.; Biểu đồ hình quạt tròn:** Đọc, phân tích thông tin và hiểu ý nghĩa biểu diễn tỉ lệ phần trăm của các loại dữ liệu trong tổng thể.",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "NN3oA3Z_Ock",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g7_s2_9",
                    title: "2. Biến cố và Xác suất của biến cố",
                    summary: "Làm quen với biến cố:** Khái niệm biến cố chắc chắn, biến cố không thể và biến cố ngẫu nhiên.; Xác suất của biến cố ngẫu nhiên:** Tính xác suất của một số biến cố ngẫu nhiên đơn giản trong các trò chơi (tung đồng xu, gieo xúc xắc, rút thẻ).",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "91uxTRlSx0o",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 8, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g8_s1_1",
                    title: "I. Đa thức và Hằng đẳng thức",
                    summary: "",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "ej4vRHdFQM0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s1_2",
                    title: "1. Đa thức nhiều biến",
                    summary: "Đơn thức và đa thức nhiều biến:** Khái niệm đơn thức, đa thức nhiều biến. Đơn thức đồng dạng. Thu gọn và tìm bậc của đa thức.; Các phép tính với đa thức:**; Cộng và trừ hai đa thức.",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "ej4vRHdFQM0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s1_3",
                    title: "2. Hằng đẳng thức đáng nhớ",
                    summary: "7 Hằng đẳng thức đáng nhớ:**; Phân tích đa thức thành nhân tử:** Các phương pháp cơ bản gồm đặt nhân tử chung, dùng hằng đẳng thức, nhóm hạng tử, và phối hợp nhiều phương pháp.",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "PmKsnnRRaoQ",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s1_4",
                    title: "II. Phân thức đại số",
                    summary: "",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "LUHzIfHAYQA",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s1_5",
                    title: "III. Hình học trực quan và Hình học phẳng",
                    summary: "",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "SEExAkZfIls",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s1_6",
                    title: "1. Hình khối trong thực tiễn",
                    summary: "Hình chóp tam giác đều và Hình chóp tứ giác đều:**; Nhận biết đỉnh, cạnh bên, mặt bên, mặt đáy, đường cao, trung đoạn của hình chóp đều.; Công thức tính **Diện tích xung quanh ($S_{xq} = p \\cdot d$)** với $p$ là nửa chu vi đáy, $d$ là trung đoạn.",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "SEExAkZfIls",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s1_7",
                    title: "2. Tứ giác",
                    summary: "Tứ giác:** Định nghĩa tứ giác lồi. Tổng các góc của một tứ giác bằng $360^\\circ$.; Các hình tứ giác đặc biệt:** Định nghĩa, tính chất và dấu hiệu nhận biết của:; Hình thang cân.",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "ouGQUeExsb0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 8, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g8_s2_1",
                    title: "I. Hàm số và Đồ thị",
                    summary: "",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "Po1jmH4dEGc",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s2_2",
                    title: "II. Phương trình bậc nhất một ẩn",
                    summary: "",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "LWKWymb4bWc",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s2_3",
                    title: "III. Hình học phẳng (Định lý Thales và Tam giác đồng dạng)",
                    summary: "",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "yf8Sy2Uacr8",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s2_4",
                    title: "1. Định lý Thales trong tam giác",
                    summary: "Định lý Thales (Thuận và Đảo):** Nếu một đường thẳng song song với một cạnh của tam giác và cắt hai cạnh còn lại thì nó định ra trên hai cạnh đó những đoạn thẳng tương ứng tỉ lệ.; Đường trung bình của tam giác:** Định nghĩa đường trung bình. Tính chất: Đường trung bình của tam giác thì song song với cạnh thứ ba và bằng nửa cạnh ấy.; Tính chất đường phân giác:** Đường phân giác trong của một góc trong tam giác chia cạnh đối diện thành hai đoạn thẳng tỉ lệ với hai cạnh kề hai đoạn ấy.",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "yf8Sy2Uacr8",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s2_5",
                    title: "2. Tam giác đồng dạng",
                    summary: "Khái niệm:** Định nghĩa hai tam giác đồng dạng, tỉ số đồng dạng $k$.; Các trường hợp đồng dạng của hai tam giác thường:**; Cạnh - cạnh - cạnh (c.c.c).",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "DSaKTM_Kv-0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s2_6",
                    title: "IV. Một số yếu tố Thống kê và Xác suất",
                    summary: "",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "MXZp4DahD58",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s2_7",
                    title: "1. Thống kê",
                    summary: "Thu thập và lựa chọn dữ liệu:** Lựa chọn phương pháp thu thập dữ liệu thích hợp. Biểu diễn dữ liệu bằng các dạng biểu đồ đã học.; Biểu đồ đoạn thẳng và Biểu đồ hình quạt tròn:** Phân tích và xử lý số liệu thu được từ biểu đồ để đưa ra nhận xét, dự đoán.",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "MXZp4DahD58",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g8_s2_8",
                    title: "2. Xác suất",
                    summary: "Xác suất của biến cố ngẫu nhiên:** Định nghĩa xác suất của biến cố trong các mô hình đồng khả năng:",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "W4m3UsAXmnU",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 9, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g9_s1_1",
                    title: "I. Căn thức",
                    summary: "",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "-zy-k0lj6ug",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s1_2",
                    title: "1. Căn bậc hai và Căn bậc ba",
                    summary: "Căn bậc hai số học:** Định nghĩa căn bậc hai số học của số không âm $a$ là số không âm $x$ sao cho $x^2 = a$ (Ký hiệu: $\\sqrt{a}$).; Điều kiện xác định:** Căn thức bậc hai $\\sqrt{A}$ xác định (có nghĩa) khi và chỉ khi $A \\ge 0$.; Hằng đẳng thức căn thức:** $\\sqrt{A^2} = |A| = \\begin{cases} A & \\text{nếu } A \\ge 0 \\\\ -A & \\text{nếu } A < 0 \\end{cases}$",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "-zy-k0lj6ug",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s1_3",
                    title: "2. Các phép biến đổi căn thức bậc hai",
                    summary: "Khai phương một tích và Nhân các căn thức bậc hai:** $\\sqrt{A \\cdot B} = \\sqrt{A} \\cdot \\sqrt{B}$ (với $A \\ge 0, B \\ge 0$).; Khai phương một thương và Chia các căn thức bậc hai:** $\\sqrt{\\frac{A}{B}} = \\frac{\\sqrt{A}}{\\sqrt{B}}$ (với $A \\ge 0, B > 0$).; Đưa thừa số vào trong / ra ngoài dấu căn:**",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "gtPvuxw5q3w",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s1_4",
                    title: "II. Phương trình và Hệ phương trình",
                    summary: "",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "NuvqobBmxps",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s1_5",
                    title: "1. Phương trình quy về phương trình bậc nhất một ẩn",
                    summary: "Phương trình tích:** Phương trình dạng $A(x) \\cdot B(x) = 0 \\Leftrightarrow A(x) = 0$ hoặc $B(x) = 0$.; Phương trình chứa ẩn ở mẫu:** Các bước giải bao gồm tìm điều kiện xác định (ĐKXH), quy đồng mẫu thức hai vế và khử mẫu, giải phương trình nhận được, đối chiếu ĐKXĐ và kết luận nghiệm.",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "NuvqobBmxps",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s1_6",
                    title: "2. Hệ hai phương trình bậc nhất hai ẩn",
                    summary: "Khái niệm:** Hệ có dạng $\\begin{cases} ax + by = c \\\\ a'x + b'y = c' \\end{cases}$; Phương pháp giải:**; Phương pháp thế.",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "X7V4NCEL0zY",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s1_7",
                    title: "III. Hình học phẳng và Hệ thức lượng",
                    summary: "",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "bZzzBIXT2RU",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s1_8",
                    title: "1. Hệ thức lượng trong tam giác vuông",
                    summary: "Các hệ thức về cạnh và đường cao:** Cho tam giác $ABC$ vuông tại $A$, đường cao $AH$, gọi b, c là 2 cạnh góc vuông; a là cạnh huyền; b', c' là hình chiếu của b, c trên cạnh huyền; h là đường cao:; $s\\text{in}, cos, tan, cotan$ của góc nhọn trong tam giác vuông.; $b^2 = a \\cdot b'$ và $c^2 = a \\cdot c'$",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "bZzzBIXT2RU",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s1_9",
                    title: "2. Đường tròn (Phần cơ bản)",
                    summary: "Khái niệm đường tròn:** Định nghĩa, sự xác định đường tròn, tính chất đối xứng của đường tròn.; Quan hệ đường kính và dây cung:** Đường kính vuông góc với một dây thì đi qua trung điểm của dây ấy và ngược lại.; Vị trí tương đối của đường thẳng và đường tròn:** Đường thẳng cắt đường tròn (2 điểm chung), tiếp xúc đường tròn (1 điểm chung - tiếp tuyến), không giao nhau (0 điểm chung).",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "UGLJ7_nrJZg",
                    channelName: "DỄ... (VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 9, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g9_s2_1",
                    title: "I. Đại số (Hàm số và Phương trình bậc hai)",
                    summary: "",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "fw80aTfTz2Q",
                    channelName: "chương trình mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s2_2",
                    title: "1. Hàm số $y = ax^2$ ($a \\neq 0$) và Phương trình bậc hai một ẩn",
                    summary: "Hàm số $y = ax^2$:** Tính chất đồng biến, nghịch biến tùy thuộc vào dấu của hệ số $a$. Đồ thị hàm số là một đường Parabol nhận trục Oy làm trục đối xứng.; Phương trình bậc hai một ẩn:** Phương trình có dạng $ax^2 + bx + c = 0$ ($a \\neq 0$).; Công thức nghiệm và Công thức nghiệm thu gọn:** Sử dụng biệt thức $\\Delta = b^2 - 4ac$ (hoặc $\\Delta' = b'^2 - ac$) để biện luận số nghiệm của phương trình (vô nghiệm, nghiệm kép, 2 nghiệm phân biệt).",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "fw80aTfTz2Q",
                    channelName: "chương trình mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s2_3",
                    title: "II. Hình học phẳng và Hình khối (Đường tròn & Hình không gian)",
                    summary: "",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "qxl2KQrAOgc",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s2_4",
                    title: "1. Góc với đường tròn",
                    summary: "Góc ở tâm:** Số đo của góc ở tâm bằng số đo của cung bị chắn.; Góc nội tiếp:** Số đo của góc nội tiếp bằng nửa số đo của cung bị chắn. Góc nội tiếp chắn nửa đường tròn là góc vuông.; Góc tạo bởi tia tiếp tuyến và dây cung:** Số đo bằng nửa số đo của cung bị chắn.",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "qxl2KQrAOgc",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s2_5",
                    title: "2. Hình trụ - Hình nón - Hình cầu",
                    summary: "Hình trụ:** Công thức tính Diện tích xung quanh ($S_{xq} = 2\\pi Rh$) và Thể tích ($V = \\pi R^2h$).; Hình nón:** Công thức tính Diện tích xung quanh ($S_{xq} = \\pi Rl$) với $l$ là đường sinh và Thể tích ($V = \\frac{1}{3}\\pi R^2h$).; Hình cầu:** Công thức tính Diện tích mặt cầu ($S = 4\\pi R^2$) và Thể tích hình cầu ($V = \\frac{4}{3}\\pi R^3$).",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "JLwoiL9eaVQ",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g9_s2_6",
                    title: "III. Tần suất và Xác suất nâng cao",
                    summary: "",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "eLKFZLl3zKo",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 10, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g10_s1_1",
                    title: "I. Đại số và Đại số tổ hợp",
                    summary: "",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "edVegk01ZsA",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s1_2",
                    title: "1. Mệnh đề và Tập hợp",
                    summary: "Mệnh đề toán học:** Khái niệm mệnh đề, mệnh đề phủ định ($\\overline{P}$), mệnh đề kéo theo ($P \\Rightarrow Q$), mệnh đề tương đương ($P \\Leftrightarrow Q$). Mệnh đề chứa ký hiệu với mọi ($\\forall$) và tồn tại ($\\exists$).; Tập hợp:** Khái niệm tập hợp, tập con ($\\subset$), hai tập hợp bằng nhau. Các tập hợp số thường gặp ($\\mathbb{N}, \\mathbb{Z}, \\mathbb{Q}, \\mathbb{R}$) và các tập con của số thực (khoảng, đoạn, nửa khoảng).; Các phép toán trên tập hợp:** Phép giao ($A \\cap B$), phép hợp ($A \\cup B$), hiệu ($A \\setminus B$), và phần bù ($C_A B$).",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "edVegk01ZsA",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s1_3",
                    title: "2. Hàm số bậc hai và Đồ thị",
                    summary: "Hàm số và đồ thị:** Khái niệm hàm số, tập xác định, tập giá trị. Sự biến thiên của hàm số (đồng biến, nghịch biến trên một khoảng).; Hàm số bậc hai:** Hàm số dạng $y = ax^2 + bx + c$ ($a \\neq 0$).; Tọa độ đỉnh Parabol: $I\\left(-\\frac{b}{2a}; -\\frac{\\Delta}{4a}\\right)$.",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "XuG121zTSsE",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s1_4",
                    title: "3. Hệ phương trình bậc nhất ba ẩn",
                    summary: "Khái niệm:** Hệ phương trình gồm 3 phương trình bậc nhất có dạng tổng quát đối với 3 ẩn $x, y, z$.; Phương pháp giải:** Phương pháp Gauss (biến đổi ma trận/hệ phương trình đưa về dạng tam giác bằng cách khử dần ẩn số) hoặc sử dụng máy tính cầm tay để tìm nghiệm.",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "jXSio7pIIaQ",
                    channelName: "Tuyensinh247 - Học trực tuyến",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s1_5",
                    title: "II. Hình học trực quan và Vectơ",
                    summary: "",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "fWc2zQr5t0c",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s1_6",
                    title: "1. Vectơ và các phép toán",
                    summary: "Khái niệm vectơ:** Định nghĩa vectơ, vectơ-không ($\\vec{0}$), hai vectơ cùng phương, cùng hướng, độ dài của vectơ, hai vectơ bằng nhau.; Các phép toán vectơ:**; Tổng của hai vectơ: Quy tắc ba điểm ($\\vec{AB} + \\vec{BC} = \\vec{AC}$), quy tắc hình bình hành.",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "fWc2zQr5t0c",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s1_7",
                    title: "2. Tích vô hướng của hai vectơ và ứng dụng",
                    summary: "Giá trị lượng giác của một góc từ $0^\\circ$ đến $180^\\circ$:** Định nghĩa $s\\text{in}, cos, tan, cot$ trên nửa đường tròn đơn vị. Hệ thức lượng cơ bản giữa các giá trị lượng giác.; Tích vô hướng của hai vectơ:**; Định nghĩa: $\\vec{a} \\cdot \\vec{b} = |\\vec{a}| \\cdot |\\vec{b}| \\cdot \\cos(\\vec{a}, \\vec{b})$.",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "xjA5-1CFnVQ",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 10, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g10_s2_1",
                    title: "I. Đại số và Đại số tổ hợp (tiếp theo)",
                    summary: "",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "3aAHlso6r4E",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s2_2",
                    title: "1. Dấu của tam thức bậc hai và Phương trình quy về bậc hai",
                    summary: "Tam thức bậc hai:** Biểu thức dạng $f(x) = ax^2 + bx + c$ ($a \\neq 0$).; Định lý về dấu của tam thức bậc hai:** Dựa vào biệt thức $\\Delta$ và hệ số $a$ để xét dấu của $f(x)$ trên tập số thực.; Bất phương trình bậc hai một ẩn:** Giải bất phương trình $f(x) > 0, f(x) < 0, f(x) \\ge 0, f(x) \\le 0$ bằng cách xét dấu.",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "3aAHlso6r4E",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s2_3",
                    title: "2. Đại số tổ hợp",
                    summary: "Quy tắc đếm cơ bản:** Quy tắc cộng (các hành động độc lập) và Quy tắc nhân (các hành động liên tiếp/công đoạn).; Hoán vị, Chỉnh hợp, Tổ hợp:**; Hoán vị của $n$ phần tử: $P_n = n!$",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "_dkXdekB4oc",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s2_4",
                    title: "II. Hình học tọa độ phẳng (Phương pháp tọa độ trong mặt phẳng)",
                    summary: "",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "BWhqjT3ulto",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s2_5",
                    title: "1. Đường thẳng trong mặt phẳng tọa độ",
                    summary: "Vectơ chỉ phương (VTCP) và Vectơ pháp tuyến (VPTN)** của đường thẳng.; Các dạng phương trình đường thẳng:**; Phương trình tham số (dựa vào 1 điểm và 1 VTCP).",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "BWhqjT3ulto",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s2_6",
                    title: "2. Đường tròn trong mặt phẳng tọa độ",
                    summary: "Phương trình đường tròn:**; Dạng chính tắc: $(x - a)^2 + (y - b)^2 = R^2$ với tâm $I(a; b)$ và bán kính $R$.; Dạng tổng quát: $x^2 + y^2 - 2ax - 2by + c = 0$ với điều kiện $a^2 + b^2 - c > 0$.",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "7g0KsKuzIXc",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s2_7",
                    title: "3. Ba đường Conic",
                    summary: "Đường Elip:** Phương trình chính tắc $\\frac{x^2}{a^2} + \\frac{y^2}{b^2} = 1$ ($a > b > 0$). Xác định các yếu tố: đỉnh, tiêu điểm, tiêu cự ($2c = 2\\sqrt{a^2 - b^2}$), trục lớn, trục nhỏ.; Đường Hypebol:** Phương trình chính tắc $\\frac{x^2}{a^2} - \\frac{y^2}{b^2} = 1$ ($a > 0, b > 0$). Xác định các đỉnh, tiêu điểm, tiêu cự ($2c = 2\\sqrt{a^2 + b^2}$), trục thực, trục ảo và đường tiệm cận.; Đường Parabol:** Phương trình chính tắc $y^2 = 2px$ ($với\\ p > 0$). Xác định tiêu điểm $I\\left(\\frac{p}{2}; 0\\right)$ và phương trình đường chuẩn $x = -\\frac{p}{2}$.",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "ZRbKhSrUgdY",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g10_s2_8",
                    title: "III. Thống kê và Xác suất sơ cấp",
                    summary: "",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "2TySFp_xT6g",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 11, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g11_s1_1",
                    title: "I. Hàm số lượng giác và Phương trình lượng giác",
                    summary: "",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "zSkQ55tPuY4",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g11_s1_2",
                    title: "1. Góc lượng giác và Giá trị lượng giác",
                    summary: "Góc lượng giác:** Khái niệm góc lượng giác, đơn vị đo góc (độ và radian), độ dài cung tròn. Khái niệm đường tròn lượng giác.; Giá trị lượng giác:** Định nghĩa $\\sin \\alpha, \\cos \\alpha, \\tan \\alpha, \\cot \\alpha$. Dấu của các giá trị lượng giác theo từng góc phần tư.; Các hệ thức lượng giác cơ bản:**",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "zSkQ55tPuY4",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g11_s1_3",
                    title: "2. Hàm số lượng giác và Phương trình lượng giác cơ bản",
                    summary: "Hàm số lượng giác:** Tập xác định, tập giá trị, tính chẵn lẻ, tính tuần hoàn và đồ thị của các hàm số $y = \\sin x, y = \\cos x, y = \\tan x, y = \\cot x$.; Phương trình lượng giác cơ bản:** Công thức nghiệm của các phương trình:; $\\sin x = m$ (có nghiệm khi $|m| \\le 1$)",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "0xPgwneCusw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g11_s1_4",
                    title: "II. Dãy số, Cấp số cộng và Cấp số nhân",
                    summary: "",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "MRUp8fgsaCU",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g11_s1_5",
                    title: "III. Giới hạn và Hàm số liên tục",
                    summary: "",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "4hv5VcrQevE",
                    channelName: "VietJack TV Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g11_s1_6",
                    title: "IV. Đường thẳng và Mặt phẳng trong không gian (Hình học không gian)",
                    summary: "",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "5MDMV-eDijE",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 11, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g11_s2_1",
                    title: "I. Hàm số mũ, Hàm số lôgarit và Quan hệ vuông góc",
                    summary: "",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "z2QwEH8qqhc",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g11_s2_2",
                    title: "1. Lũy thừa, Lôgarit và Hàm số lũy thừa, mũ, lôgarit",
                    summary: "Phép tính lũy thừa:** Lũy thừa với số mũ nguyên, số mũ hữu tỉ và số mũ thực. Các tính chất của lũy thừa.; Phép tính lôgarit:** Định nghĩa $\\log_a b$ ($a > 0, a \\neq 1, b > 0$). Các tính chất, công thức đổi cơ số. Lôgarit tự nhiên ($\\ln$), lôgarit thập phân ($\\log$).; Hàm số lũy thừa, hàm số mũ, hàm số lôgarit:** Tập xác định, đồ thị và chiều biến thiên của các hàm số $y = x^\\alpha$, $y = a^x$, $y = \\log_a x$.",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "z2QwEH8qqhc",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g11_s2_3",
                    title: "2. Quan hệ vuông góc trong không gian",
                    summary: "Góc giữa hai đường thẳng** trong không gian. Hai đường thẳng vuông góc.; Đường thẳng vuông góc với mặt phẳng:**; Điều kiện: Đường thẳng vuông góc với hai đường thẳng cắt nhau nằm trong mặt phẳng.",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "Chyyi3XHm28",
                    channelName: "Tuyensinh247 - Học trực tuyến",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g11_s2_4",
                    title: "II. Đạo hàm",
                    summary: "",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "8tk9gFkQeCg",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g11_s2_5",
                    title: "III. Một số yếu tố Xác suất (Nâng cao)",
                    summary: "",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "9vHehlsajyw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 12, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g12_s1_1",
                    title: "I. Giải tích (Ứng dụng đạo hàm và Khối tròn xoay)",
                    summary: "",
                    subject: "Toán",
                    grade: 12,
                    semester: 1,
                    videoId: "990wEB5yo2k",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g12_s1_2",
                    title: "1. Ứng dụng đạo hàm để khảo sát và vẽ đồ thị hàm số",
                    summary: "Tính đơn điệu của hàm số:** Mối liên hệ giữa dấu của đạo hàm bậc nhất $f'(x)$ và tính đồng biến, nghịch biến của hàm số trên một khoảng.; Cực trị của hàm số:** Điều kiện cần và đủ để hàm số có điểm cực đại, điểm cực tiểu. Phương pháp tìm cực trị bằng dấu của $f'(x)$ (bảng biến thiên) hoặc đạo hàm cấp hai $f''(x)$.; Giá trị lớn nhất (Glnn) và Giá trị nhỏ nhất (Gtnn):** Cách tìm Glnn, Gtnn của hàm số trên một khoảng hoặc trên một đoạn $[a; b]$.",
                    subject: "Toán",
                    grade: 12,
                    semester: 1,
                    videoId: "990wEB5yo2k",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g12_s1_3",
                    title: "2. Khối tròn xoay",
                    summary: "Nón tròn xoay, Trụ tròn xoay, Cầu tròn xoay:** Khái niệm mặt tròn xoay, khối tròn xoay.; Ứng dụng thực tế:** Tính diện tích xung quanh, diện tích toàn phần và thể tích của các khối nón, khối trụ, khối cầu trong đời sống và kỹ thuật.",
                    subject: "Toán",
                    grade: 12,
                    semester: 1,
                    videoId: "Xr1SFlj5F2Q",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g12_s1_4",
                    title: "II. Hình học không gian (Thể tích khối đa diện)",
                    summary: "",
                    subject: "Toán",
                    grade: 12,
                    semester: 1,
                    videoId: "LTdQz7Xu4Pg",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 12, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_toá_g12_s2_1",
                    title: "I. Giải tích (Nguyên hàm, Tích phân và Nguyên lý xác suất)",
                    summary: "",
                    subject: "Toán",
                    grade: 12,
                    semester: 2,
                    videoId: "H8x4Cjktaq8",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g12_s2_2",
                    title: "1. Nguyên hàm và Tích phân",
                    summary: "Nguyên hàm:** Định nghĩa nguyên hàm, tính chất của nguyên hàm. Bảng nguyên hàm của các hàm số sơ cấp cơ bản. Các phương pháp tìm nguyên hàm: Phương pháp đổi biến số và phương pháp nguyên hàm từng phần.; Tích phân:** Định nghĩa tích phân dựa trên công thức Newton-Leibniz: $\\int_a^b f(x)dx = F(b) - F(a)$. Các tính chất cơ bản của tích phân. Phương pháp tính tích phân (đổi biến số, tích phân từng phần).; Ứng dụng của tích phân trong hình học:**",
                    subject: "Toán",
                    grade: 12,
                    semester: 2,
                    videoId: "H8x4Cjktaq8",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g12_s2_3",
                    title: "2. Xác suất có điều kiện và Công thức xác suất toàn phần",
                    summary: "Xác suất có điều kiện:** Khái niệm và công thức tính xác suất của biến cố $A$ với điều kiện biến cố $B$ đã xảy ra: $P(A|B) = \\frac{P(A \\cap B)}{P(B)}$ ($P(B) > 0$).; Công thức xác suất toàn phần:** Tính xác suất của một biến cố thông qua một hệ đầy đủ các biến cố xung khắc.; Công thức Bayes:** Ứng dụng cập nhật xác suất của các giả thuyết sau khi có thêm thông tin thử nghiệm.",
                    subject: "Toán",
                    grade: 12,
                    semester: 2,
                    videoId: "zSQtgAmB3lo",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_toá_g12_s2_4",
                    title: "II. Hình học tọa độ (Phương pháp tọa độ trong không gian Oxyz)",
                    summary: "",
                    subject: "Toán",
                    grade: 12,
                    semester: 2,
                    videoId: "uzN97cFH1II",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 6, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g6_s1_1",
                    title: "I. Các phép đo cơ bản",
                    summary: "",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 1,
                    videoId: "_DhVQ1IRcSw",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g6_s1_2",
                    title: "II. Lực và Chuyển động",
                    summary: "",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 1,
                    videoId: "OQb-RrZPAPE",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g6_s1_3",
                    title: "III. Các loại lực thường gặp và Khối lượng riêng",
                    summary: "",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 1,
                    videoId: "E8-doHxA-wQ",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 6, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g6_s2_1",
                    title: "I. Cơ năng và Sự truyền năng lượng",
                    summary: "",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 2,
                    videoId: "MZRb0vhmYHc",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g6_s2_2",
                    title: "II. Năng lượng hao phí và Năng lượng tái tạo",
                    summary: "",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 2,
                    videoId: "mVfwYsqZmn8",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g6_s2_3",
                    title: "III. Sơ lược về Thiên văn học (Trái Đất và bầu trời)",
                    summary: "",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 2,
                    videoId: "AxP0ckaqlDI",
                    channelName: "Thị Nghị",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 7, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g7_s1_1",
                    title: "I. Tốc độ chuyển động",
                    summary: "",
                    subject: "Vật lí",
                    grade: 7,
                    semester: 1,
                    videoId: "knLmrwxE60o",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g7_s1_2",
                    title: "II. Sóng âm (Âm thanh)",
                    summary: "",
                    subject: "Vật lí",
                    grade: 7,
                    semester: 1,
                    videoId: "gr0I_2EjIh8",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 7, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g7_s2_1",
                    title: "I. Ánh sáng",
                    summary: "",
                    subject: "Vật lí",
                    grade: 7,
                    semester: 2,
                    videoId: "lznoNl_1oks",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g7_s2_2",
                    title: "II. Từ học (Nam châm và Từ trường)",
                    summary: "",
                    subject: "Vật lí",
                    grade: 7,
                    semester: 2,
                    videoId: "T5dU40N_Fys",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 8, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g8_s1_1",
                    title: "I. Lực và Chuyển động nâng cao",
                    summary: "",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 1,
                    videoId: "t5pjnzstZ_o",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g8_s1_2",
                    title: "II. Áp suất",
                    summary: "",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 1,
                    videoId: "pNUjrUbtp_A",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g8_s1_3",
                    title: "III. Lực đẩy Ác-si-mét và Sự nổi",
                    summary: "",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 1,
                    videoId: "z4MIi6tTKY0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g8_s1_4",
                    title: "IV. Mômen lực và Đòn bẩy",
                    summary: "",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 1,
                    videoId: "8gzgxx8GmaI",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 8, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g8_s2_1",
                    title: "I. Điện học",
                    summary: "",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 2,
                    videoId: "ylvKTdwz06w",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g8_s2_2",
                    title: "II. Nhiệt học",
                    summary: "",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 2,
                    videoId: "yNLCyPOGHBY",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 9, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g9_s1_1",
                    title: "I. Điện học",
                    summary: "",
                    subject: "Vật lí",
                    grade: 9,
                    semester: 1,
                    videoId: "uf58k56ThxU",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g9_s1_2",
                    title: "II. Điện từ học",
                    summary: "",
                    subject: "Vật lí",
                    grade: 9,
                    semester: 1,
                    videoId: "AHER9q0p1Zo",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 9, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g9_s2_1",
                    title: "I. Khúc xạ ánh sáng và Quang hình học",
                    summary: "",
                    subject: "Vật lí",
                    grade: 9,
                    semester: 2,
                    videoId: "8nJ7NKXfzIs",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g9_s2_2",
                    title: "II. Các dụng cụ quang học trực quan",
                    summary: "",
                    subject: "Vật lí",
                    grade: 9,
                    semester: 2,
                    videoId: "kntRKyAJZE0",
                    channelName: "Tri Thức Nhân Loại",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g9_s2_3",
                    title: "III. Năng lượng và Phát triển bền vững",
                    summary: "",
                    subject: "Vật lí",
                    grade: 9,
                    semester: 2,
                    videoId: "t5pjnzstZ_o",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 10, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g10_s1_1",
                    title: "I. Mở đầu và Động học chất điểm",
                    summary: "",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 1,
                    videoId: "r7WKF9JkoOU",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g10_s1_2",
                    title: "II. Động lực học chất điểm",
                    summary: "",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 1,
                    videoId: "5A9Smfa-1M0",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 10, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g10_s2_1",
                    title: "I. Khối lượng riêng, Áp suất chất lỏng và Độ biến dạng của vật rắn",
                    summary: "",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 2,
                    videoId: "zKQUBcMA3Og",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g10_s2_2",
                    title: "II. Năng lượng, Công và Công suất",
                    summary: "",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 2,
                    videoId: "If0vjlR4anc",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g10_s2_3",
                    title: "III. Động lượng",
                    summary: "",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 2,
                    videoId: "z38kU0FZcUU",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g10_s2_4",
                    title: "IV. Chuyển động tròn đều và Tĩnh học",
                    summary: "",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 2,
                    videoId: "-idONiawiJw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 11, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g11_s1_1",
                    title: "I. Dao động cơ",
                    summary: "",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "QD8X0CajCBo",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s1_2",
                    title: "1. Dao động điều hòa",
                    summary: "Khái niệm:** Dao động điều hòa là dao động trong đó li độ của vật là một hàm sin hoặc cosin của thời gian.; Phương trình dao động điều hòa:**; $x$: Li độ (độ lệch khỏi vị trí cân bằng - $\\text{m}$ hoặc $\\text{cm}$).",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "QD8X0CajCBo",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s1_3",
                    title: "2. Vận tốc và gia tốc trong dao động điều hòa",
                    summary: "Phương trình vận tốc:** $v = x' = -\\omega A\\sin(\\omega t + \\phi) = \\omega A\\cos(\\omega t + \\phi + \\frac{\\pi}{2})$; Vận tốc biến thiên điều hòa cùng tần số nhưng **sớm pha $\\frac{\\pi}{2}$** so với li độ.; Vật qua vị trí cân bằng ($x = 0$): Vận tốc có độ lớn cực đại $v_{max} = \\omega A$.",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "OGSo3oZpf0M",
                    channelName: "Việt Lê Siêu Nhân",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s1_4",
                    title: "3. Năng lượng trong dao động điều hòa",
                    summary: "Động năng:** $W_đ = \\frac{1}{2}mv^2 = \\frac{1}{2}m\\omega^2 A^2\\sin^2(\\omega t + \\phi)$; Thế năng:** $W_t = \\frac{1}{2}m\\omega^2 x^2 = \\frac{1}{2}m\\omega^2 A^2\\cos^2(\\omega t + \\phi)$; Cơ năng:** $W = W_đ + W_t = \\frac{1}{2}m\\omega^2 A^2 = \\text{const}$ (được bảo toàn nếu bỏ qua mọi ma sát).",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "QD8X0CajCBo",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s1_5",
                    title: "4. Dao động tắt dần, dao động cưỡng bức và Hiện tượng cộng hưởng",
                    summary: "Dao động tắt dần:** Là dao động có biên độ và cơ năng giảm dần theo thời gian do tác dụng của lực cản môi trường. Lực cản càng lớn, dao động tắt dần càng nhanh.; Dao động duy trì:** Bằng cách cung cấp thêm năng lượng đúng bằng phần năng lượng tiêu hao sau mỗi chu kì mà không làm thay đổi chu kì riêng của hệ.; Dao động cưỡng bức:** Là dao động chịu tác dụng của một ngoại lực tuần hoàn biến đổi theo thời gian $F = F_0\\cos(\\omega t + \\phi_0)$. Dao động cưỡng bức có tần số bằng tần số của ngoại lực cưỡng bức.",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "bGUWkxmB6h8",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s1_6",
                    title: "II. Sóng cơ và Sóng âm",
                    summary: "",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "jyBtwL1z6xU",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s1_7",
                    title: "1. Sóng cơ và các đặc trưng của sóng",
                    summary: "Khái niệm:** Sóng cơ là sự lan truyền dao động cơ trong một môi trường vật chất theo thời gian. Các phần tử môi trường chỉ dao động tại chỗ chứ không truyền đi theo sóng.; Phân loại:**; Sóng ngang:* Các phần tử môi trường dao động theo phương **vuông góc** với phương truyền sóng (Truyền được trong chất rắn và bề mặt chất lỏng).",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "jyBtwL1z6xU",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s1_8",
                    title: "2. Giao thoa sóng và Sóng dừng",
                    summary: "Giao thoa sóng:** Là hiện tượng hai sóng kết hợp (cùng tần số và có độ lệch pha không đổi theo thời gian) gặp nhau tạo nên các cực đại và cực tiểu giao thoa ổn định trong không gian.; Vị trí cực đại giao thoa: $d_2 - d_1 = k\\lambda$ ($k \\in \\mathbb{Z}$).; Vị trí cực tiểu giao thoa: $d_2 - d_1 = (k + \\frac{1}{2})\\lambda$ ($k \\in \\mathbb{Z}$).",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "jyBtwL1z6xU",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 11, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g11_s2_1",
                    title: "I. Điện trường",
                    summary: "",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "bWtFC3fnN1o",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s2_2",
                    title: "1. Lực tương tác tĩnh điện (Định luật Culông)",
                    summary: "Lực hút hoặc đẩy giữa hai điện tích điểm $q_1, q_2$ đặt trong chân không tỉ lệ thuận với tích độ lớn của hai điện tích và tỉ lệ nghịch với bình phương khoảng cách giữa chúng.; Trong đó: $k = 9 \\cdot 10^9 \\, \\text{N.m}^2/\\text{C}^2$, $r$ là khoảng cách ($\\text{m}$).; Nếu đặt trong môi trường điện môi đồng tính có hằng số điện môi $\\varepsilon$: $F = k \\cdot \\frac{|q_1 \\cdot q_2|}{\\varepsilon \\cdot r^2}$.",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "bWtFC3fnN1o",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s2_3",
                    title: "2. Cường độ điện trường",
                    summary: "Khái niệm:** Là đại lượng đặc trưng cho điện trường về mặt tác dụng lực. $\\vec{E} = \\frac{\\vec{F}}{q}$ (Đơn vị: $\\text{V/m}$).; Điện trường của một điện tích điểm $Q$:**; Nếu $Q > 0$: $\\vec{E}$ hướng ra xa điện tích. Nếu $Q < 0$: $\\vec{E}$ hướng về phía điện tích.",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "qigka3yTR3Q",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s2_4",
                    title: "3. Công của lực điện, Điện thế và Hiệu điện thế",
                    summary: "Công của lực điện:** Không phụ thuộc vào hình dạng đường đi mà chỉ phụ thuộc vào vị trí điểm đầu và điểm cuối của đường đi trong điện trường.; $d$: Hình chiếu của quỹ đạo lên một đường sức điện ($\\text{m}$).; Hiệu điện thế và liên hệ với cường độ điện trường đều:**",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "h9u9G5ixLzw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s2_5",
                    title: "4. Tụ điện",
                    summary: "Khái niệm:** Là một hệ hai vật dẫn đặt gần nhau và ngăn cách nhau bằng một lớp cách điện (điện môi), dùng để tích và phóng điện.; Điện dung của tụ điện ($C$):** Đại lượng đặc trưng cho khả năng tích điện của tụ.; Năng lượng điện trường bên trong tụ điện:** $W = \\frac{1}{2}Q \\cdot U = \\frac{1}{2}C \\cdot U^2 = \\frac{1}{2}\\frac{Q^2}{C}$.",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "ePARXM3mEmQ",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s2_6",
                    title: "II. Dòng điện không đổi",
                    summary: "",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "Cxi6Ng5mO20",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s2_7",
                    title: "1. Dòng điện và Cường độ dòng điện",
                    summary: "Dòng điện:** Dòng dịch chuyển có hướng của các hạt mang điện (điện tích).; Cường độ dòng điện ($I$):** Đại lượng đặc trưng cho tác dụng mạnh hay yếu của dòng điện, đo bằng điện lượng dịch chuyển qua tiết diện thẳng của vật dẫn trong một đơn vị thời gian.; Dòng điện không đổi:* Có chiều và cường độ không thay đổi theo thời gian: $I = \\frac{q}{t}$.",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "Cxi6Ng5mO20",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s2_8",
                    title: "2. Định luật Ôm đối với toàn mạch",
                    summary: "Cường độ dòng điện chạy trong mạch điện kín tỉ lệ thuận với suất điện động của nguồn điện và tỉ lệ nghịch với điện trở toàn phần của mạch đó.; Hiệu điện thế mạch ngoài (độ sụt áp mạch ngoài):** $U = I \\cdot R_{nguài} = \\mathcal{E} - I \\cdot r$.; Hiện tượng đoản mạch:** Xảy ra khi điện trở mạch ngoài không đáng kể ($R_{nguài} \\approx 0$). Khi đó cường độ dòng điện trong mạch đạt giá trị cực đại $I_{max} = \\frac{\\mathcal{E}}{r}$, có thể gây cháy nổ, hỏng hóc nguồn điện.",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "mmNlIJ2uL-8",
                    channelName: "Thầy Hiếu Lí-CBH",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g11_s2_9",
                    title: "3. Công và Công suất của nguồn điện",
                    summary: "Công của nguồn điện:** $A_{nguồn} = q \\cdot \\mathcal{E} = \\mathcal{E} \\cdot I \\cdot t$.; Công suất của nguồn điện:** $P_{nguồn} = \\frac{A_{nguồn}}{t} = \\mathcal{E} \\cdot I$.; Hiệu suất của nguồn điện:**",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "9OAglQe-49I",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 12, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g12_s1_1",
                    title: "I. Vật lí nhiệt",
                    summary: "",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "vEVQx5lCwiw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s1_2",
                    title: "1. Mô hình động học phân tử và Cấu trúc của chất",
                    summary: "Mô hình động học phân tử:** Các chất được cấu tạo từ các hạt riêng biệt gọi là phân tử. Các phân tử chuyển động hỗn loạn không ngừng (chuyển động nhiệt). Các phân tử tương tác với nhau bằng lực hút và lực đẩy phân tử.; Cấu trúc của chất:**; Chất rắn:* Các phân tử ở rất gần nhau, dao động quanh vị trí cân bằng cố định. Có thể tích và hình dạng xác định.",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "vEVQx5lCwiw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s1_3",
                    title: "2. Định luật I nhiệt động lực học",
                    summary: "Độ biến thiên nội năng của hệ bằng tổng công và nhiệt lượng mà hệ nhận được.; Quy ước dấu:*; $Q > 0$: Hệ nhận nhiệt lượng; $Q < 0$: Hệ truyền nhiệt lượng.",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "VxzEvmMJipo",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s1_4",
                    title: "3. Sự chuyển thể của các chất",
                    summary: "Nhiệt nóng chảy riêng ($\\lambda$):** Nhiệt lượng cần cung cấp cho $1\\text{ kg}$ chất đó nóng chảy hoàn toàn ở nhiệt độ nóng chảy.; Nhiệt hóa hơi riêng ($L$):** Nhiệt lượng cần cung cấp cho $1\\text{ kg}$ chất lỏng hóa hơi hoàn toàn ở nhiệt độ sôi.",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "rupdDV0uLDc",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s1_5",
                    title: "4. Thang nhiệt độ và Nhiệt dung riêng",
                    summary: "Thang nhiệt độ Kelvin (K):** Thang nhiệt độ tuyệt đối, bắt đầu từ độ không tuyệt đối ($0\\text{ K} = -273,15^\\circ\\text{C}$).; Nhiệt dung riêng ($c$):** Nhiệt lượng cần thiết để làm cho $1\\text{ kg}$ chất đó tăng thêm $1^\\circ\\text{C}$ (hoặc $1\\text{ K}$).",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "pQ1BwAg2bto",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s1_6",
                    title: "II. Khí lí tưởng",
                    summary: "",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "3kztL19fZeI",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s1_7",
                    title: "1. Phương trình trạng thái của khí lí tưởng",
                    summary: "Khí lí tưởng:** Là chất khí trong đó các phân tử được coi là các chất điểm và chỉ tương tác với nhau khi va chạm.; Các định luật về khí lí tưởng:**; Định luật Boyle (Đẳng nhiệt):* $P \\cdot V = \\text{const} \\Rightarrow P_1V_1 = P_2V_2$",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "3kztL19fZeI",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s1_8",
                    title: "2. Áp suất khí và Động năng phân tử",
                    summary: "Áp suất khí lí tưởng tác dụng lên thành bình được giải thích do sự va chạm của các phân tử khí lên thành bình.; Công thức áp suất từ mô hình động học phân tử: $P = \\frac{1}{3}\\mu \\cdot m_0 \\cdot \\overline{v^2}$ (với $\\mu$ là mật độ phân tử, $m_0$ là khối lượng phân tử).; Động năng tịnh tiến trung bình của phân tử khí tỉ lệ thuận với nhiệt độ tuyệt đối:",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "nADFBOnsjas",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 12, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_vật_g12_s2_1",
                    title: "I. Từ trường",
                    summary: "",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "-Th489FiUO8",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s2_2",
                    title: "1. Lực từ tác dụng lên dây dẫn thẳng mang dòng điện",
                    summary: "Lực từ $\\vec{F}$ tác dụng lên một đoạn dây dẫn thẳng có chiều dài $L$, mang dòng điện $I$, đặt trong từ trường đều có cảm ứng từ $\\vec{B}$.; Độ lớn (Định luật Ampere):**; Trong đó: $\\alpha$ là góc hợp bởi vectơ cảm ứng từ $\\vec{B}$ và chiều dòng điện.",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "-Th489FiUO8",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s2_3",
                    title: "2. Cảm ứng từ của dòng điện có hình dạng đặc biệt",
                    summary: "Dòng điện thẳng dài vô hạn:** $B = 2 \\cdot 10^{-7} \\cdot \\frac{I}{r}$ ($r$ là khoảng cách từ dây dẫn đến điểm xét).; Dòng điện tròn (tại tâm):** $B = 2\\pi \\cdot 10^{-7} \\cdot N \\cdot \\frac{I}{R}$ ($N$ là số vòng dây, $R$ là bán kính vòng dây).; Ống dây dẫn thẳng:** $B = 4\\pi \\cdot 10^{-7} \\cdot n \\cdot I = 4\\pi \\cdot 10^{-7} \\cdot \\frac{N}{L} \\cdot I$ ($n$ là số vòng dây trên một đơn vị chiều dài).",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "-Th489FiUO8",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s2_4",
                    title: "3. Lực Lorentz",
                    summary: "Lực Lorentz là lực do từ trường tác dụng lên một hạt mang điện tích $q$ chuyển động với vận tốc $\\vec{v}$.; Trong đó: $\\alpha = (\\vec{v}, \\vec{B})$. Chiều lực Lorentz xác định bằng quy tắc bàn tay trái (lưu ý dấu của điện tích $q$).",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "-Th489FiUO8",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s2_5",
                    title: "II. Vật lí hạt nhân",
                    summary: "",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "TJjNtOEJjRM",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s2_6",
                    title: "1. Cấu tạo hạt nhân và Độ hụt khối",
                    summary: "Cấu tạo hạt nhân:** Kí hiệu hạt nhân là $_Z^A\\text{X}$.; Hạt nhân cấu tạo từ các nucleon bao gồm: Proton ($Z$ hạt, mang điện tích $+e$) và Neutron ($N = A - Z$ hạt, không mang điện).; $A$: Số khối (tổng số nucleon). $Z$: Điện tích hạt nhân (số hiệu nguyên tử).",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "TJjNtOEJjRM",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s2_7",
                    title: "2. Phóng xạ và Định luật phóng xạ",
                    summary: "Hiện tượng phóng xạ:** Là quá trình phân rã tự phát của một hạt nhân không bền vững thành hạt nhân khác, đồng thời phát ra các tia phóng xạ ($\\alpha, \\beta^-, \\beta^+, \\gamma$). Quá trình này hoàn toàn tự phát và không phụ thuộc vào các điều kiện bên ngoài.; Các loại tia phóng xạ:**; Phóng xạ $\\alpha$ ($_2^4\\text{He}$):* $_Z^A\\text{X} \\rightarrow _2^4\\text{He} + _{Z-2}^{A-4}\\text{Y}$",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "9J8D775y3TY",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_vật_g12_s2_8",
                    title: "3. Phản ứng hạt nhân, Phân hạch và Nhiệt hạch",
                    summary: "Phản ứng hạt nhân:** Là mọi quá trình dẫn đến sự biến đổi của các hạt nhân (gồm phản ứng tự phát như phóng xạ và phản ứng kích thích do các hạt va chạm).; Các định luật bảo toàn trong phản ứng hạt nhân:**; (Lưu ý: Không có định luật bảo toàn khối lượng nghỉ).*",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "TJjNtOEJjRM",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 6, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s1_1",
                    title: "I. Chất và các thể của chất",
                    summary: "",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "NL8sMdi9b44",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s1_2",
                    title: "1. Sự đa dạng của chất",
                    summary: "Vật thể tự nhiên:** Là những vật thể có sẵn trong tự nhiên (Ví dụ: sông, suối, cây cối, con người, đất đá).; Vật thể nhân tạo:** Là những vật thể do con người tạo ra để phục vụ cuộc sống (Ví dụ: bàn ghế, quần áo, sách vở, xe cộ).; Vật sống (vật hữu sinh):** Có các đặc trưng sống như trao đổi chất, lớn lên, sinh sản (Ví dụ: động vật, thực vật).",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "NL8sMdi9b44",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s1_3",
                    title: "2. Ba thể cơ bản của chất và đặc điểm của chúng",
                    summary: "Thể rắn:** Các hạt liên kết chặt chẽ, có hình dạng và thể tích xác định, rất khó bị nén.; Thể lỏng:** Các hạt liên kết lỏng lẻo hơn, có thể tích xác định nhưng hình dạng phụ thuộc vào vật chứa, khó bị nén.; Thể khí (hơi):** Các hạt chuyển động tự do, không có hình dạng và thể tích xác định (chiếm toàn bộ thể tích bình chứa), rất dễ bị nén.",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "DrZHr2IJVTU",
                    channelName: "Tuyensinh247 - Học trực tuyến",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s1_4",
                    title: "3. Tính chất của chất",
                    summary: "Tính chất vật lí:** Là những tính chất có thể quan sát hoặc đo đạc được mà không làm biến đổi chất này thành chất khác (Ví dụ: thể, màu sắc, mùi vị, tính tan, nhiệt độ nóng chảy, nhiệt độ sôi, tính dẫn điện, dẫn nhiệt).; Tính chất hóa học:** Là sự biến đổi của chất này thành chất khác (Ví dụ: tính chất cháy, tính chất bị phân hủy, khả năng tương tác với chất khác gây rỉ sét, ăn mòn).",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "zUyq_VAFzkk",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s1_5",
                    title: "4. Sự chuyển thể của chất",
                    summary: "Sự nóng chảy:** Chất chuyển từ thể rắn sang thể lỏng.; Sự đông đặc:** Chất chuyển từ thể lỏng sang thể rắn.; Sự bay hơi:** Chất chuyển từ thể lỏng sang thể khí/hơi (xảy ra trên bề mặt chất lỏng).",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "oy2QIwOaI2M",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s1_6",
                    title: "II. Oxygen và Không khí",
                    summary: "",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "JhfxwUU5qo0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s1_7",
                    title: "1. Oxygen (Oxi)",
                    summary: "Tính chất vật lí:** Là chất khí, không màu, không mùi, không vị, ít tan trong nước, nặng hơn không khí.; Tầm quan trọng:** Oxygen duy trì sự sống (cần cho quá trình hô hấp của con người, động vật, thực vật) và duy trì sự cháy (cần cho quá trình đốt cháy nhiên liệu).",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "JhfxwUU5qo0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s1_8",
                    title: "2. Không khí và Bảo vệ môi trường không khí",
                    summary: "Thành phần của không khí:** Không khí là một hỗn hợp khí gồm có:; $78\\%$ khí Nitrogen (nitơ).; $21\\%$ khí Oxygen (oxi).",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "1fJADq8DcV0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 6, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s2_1",
                    title: "I. Một số vật liệu, nhiên liệu, nguyên liệu, lương thực - thực phẩm thông dụng",
                    summary: "",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "qxs6psfLiE0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s2_2",
                    title: "1. Một số vật liệu thông dụng",
                    summary: "Khái niệm:** Vật liệu là chất hoặc hỗn hợp các chất được con người sử dụng làm nguyên liệu đầu vào để chế tạo ra vật thể phục vụ đời sống, sản xuất (Ví dụ: nhựa, kim loại, cao su, thủy tinh, gốm).; Tính chất và ứng dụng:** Mỗi vật liệu có tính chất riêng (kim loại dẫn điện và nhiệt tốt; nhựa dẻo và cách điện; thủy tinh trong suốt nhưng giòn). Cần sử dụng vật liệu an toàn, hiệu quả và theo mô hình 3R (Reduce - Giảm thiểu, Reuse - Tái sử dụng, Recycle - Tái chế).",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "qxs6psfLiE0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s2_3",
                    title: "2. Một số nhiên liệu thông dụng",
                    summary: "Khái niệm:** Nhiên liệu (chất đốt) là những chất khi cháy đều tỏa nhiệt và phát sáng (Ví dụ: than đá, xăng, dầu, gas, củi, cồn).; Phân loại:** Nhiên liệu hóa thạch (than đá, dầu mỏ), nhiên liệu tái tạo (củi, sinh khối), nhiên liệu sạch (khí hydrogen).; Sử dụng hiệu quả:** Phải cung cấp đủ oxygen cho quá trình cháy, tăng diện tích tiếp xúc giữa nhiên liệu và oxygen, điều chỉnh ngọn lửa phù hợp để tránh lãng phí và ô nhiễm môi trường.",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "E_96vVDizV8",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s2_4",
                    title: "3. Một số nguyên liệu và lương thực - thực phẩm thông dụng",
                    summary: "Nguyên liệu:** Là vật liệu tự nhiên (chưa qua xử lý) cần được chuyển hóa trong sản xuất để tạo ra sản phẩm (Ví dụ: quặng sắt để luyện gang thép, đá vôi để sản xuất xi măng).; Lương thực, thực phẩm:** Cung cấp các chất dinh dưỡng thiết yếu cho cơ thể (carbohydrate, chất béo, protein, vitamin, khoáng chất). Cần bảo quản đúng cách để tránh bị hư hỏng, ngộ độc.",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "M8l8AQGGjcg",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s2_5",
                    title: "II. Hỗn hợp và các phương pháp tách chất",
                    summary: "",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "zUyq_VAFzkk",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s2_6",
                    title: "1. Hỗn hợp và Chất tinh khiết",
                    summary: "Chất tinh khiết (chất nguyên chất):** Được tạo ra từ một chất duy nhất, có những tính chất vật lí và hóa học xác định, không thay đổi.; Hỗn hợp:** Được tạo ra khi hai hay nhiều chất trộn lẫn với nhau. Tính chất của hỗn hợp thay đổi tùy thuộc vào thành phần các chất có trong hỗn hợp.; Hỗn hợp đồng nhất:** Các chất phân bố đều nhau, không phân biệt được các thành phần (Ví dụ: nước muối, nước đường).",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "zUyq_VAFzkk",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s2_7",
                    title: "2. Dung dịch, Huyền phù và Nhũ tương",
                    summary: "Dung dịch:** Là hỗn hợp đồng nhất giữa chất tan và dung môi.; Dung môi:* Chất có khả năng hòa tan chất khác (thường là nước, cồn).; Chất tan:* Chất bị hòa tan trong dung môi (có thể là chất rắn, lỏng hoặc khí).",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "zUyq_VAFzkk",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g6_s2_8",
                    title: "3. Các phương pháp vật lí đơn giản để tách chất ra khỏi hỗn hợp",
                    summary: "Phương pháp lọc:** Dùng để tách chất rắn không tan ra khỏi hỗn hợp lỏng (Ví dụ: tách cát ra khỏi nước).; Phương pháp cô cạn:** Dùng để tách chất rắn tan được ra khỏi dung dịch bằng cách đun nóng cho dung môi bay hơi hết (Ví dụ: làm muối từ nước biển).; Phương pháp chiết:** Dùng để tách các chất lỏng không hòa tan vào nhau ra khỏi nhau bằng phễu chiết (Ví dụ: tách dầu ăn ra khỏi nước).",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "rkde27BKoVM",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 7, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s1_1",
                    title: "I. Nguyên tử",
                    summary: "",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "n-no-o3RfWM",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s1_2",
                    title: "1. Khái niệm và cấu tạo nguyên tử",
                    summary: "Khái niệm:** Nguyên tử là hạt cực kỳ nhỏ bé, trung hòa về điện, cấu tạo nên các chất.; Cấu tạo nguyên tử:** Gồm 2 phần chính:; Hạt nhân (ở tâm):* Gồm các hạt proton (kí hiệu là $p$, mang điện tích dương $+1$) và hạt neutron (kí hiệu là $n$, không mang điện).",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "n-no-o3RfWM",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s1_3",
                    title: "2. Nguyên tố hóa học",
                    summary: "Định nghĩa:** Nguyên tố hóa học là tập hợp những nguyên tử có cùng số proton trong hạt nhân. Các nguyên tử của cùng một nguyên tố hóa học đều có tính chất hóa học giống nhau.; Kí hiệu hóa học:** Mỗi nguyên tố được biểu diễn bằng một hoặc hai chữ cái (chữ cái đầu viết hoa, chữ cái sau viết thường). Kí hiệu này được quy định thống nhất trên toàn thế giới theo IUPAC (Ví dụ: Hydrogen là $\\text{H}$, Carbon là $\\text{C}$, Sodium là $\\text{Na}$).",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "v_CBSKC3xfw",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s1_4",
                    title: "II. Sơ lược về bảng tuần hoàn các nguyên tố hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "v_CBSKC3xfw",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s1_5",
                    title: "1. Nguyên tắc sắp xếp",
                    summary: "Các nguyên tố hóa học được sắp xếp theo chiều tăng dần của điện tích hạt nhân nguyên tử (số proton).; Các nguyên tố có cùng số lớp electron trong nguyên tử được xếp thành một hàng (chu kì).; Các nguyên tố có tính chất hóa học tương tự nhau được xếp thành một cột (nhóm).",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "v_CBSKC3xfw",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s1_6",
                    title: "2. Cấu tạo bảng tuần hoàn",
                    summary: "Ô nguyên tố:** Cho biết số hiệu nguyên tử (bằng số $p$), kí hiệu hóa học, tên nguyên tố và khối lượng nguyên tử.; Chu kì:** Là dãy các nguyên tố mà nguyên tử của chúng có cùng số lớp electron, xếp theo chiều tăng dần điện tích hạt nhân. Bảng tuần hoàn gồm 7 chu kì (chu kì 1, 2, 3 là chu kì nhỏ; chu kì 4, 5, 6, 7 là chu kì lớn).; Nhóm:** Gồm các nguyên tố có tính chất hóa học tương tự nhau, xếp thành cột theo chiều tăng dần điện tích hạt nhân. Bảng tuần hoàn gồm 8 nhóm A (kí hiệu từ IA đến VIIIA) và 8 nhóm B.",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "s9MGybD8wSE",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s1_7",
                    title: "3. Các nhóm nguyên tố chính trong bảng tuần hoàn",
                    summary: "Kim loại:** Chiếm đa số trong bảng tuần hoàn (ở góc dưới bên trái).; Phi kim:** Chiếm số lượng ít hơn (ở góc trên bên phải).; Khí hiếm:** Nằm ở nhóm VIIIA (cột cuối cùng bên phải), trơ về mặt hóa học, khó tham gia phản ứng.",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "s9MGybD8wSE",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 7, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s2_1",
                    title: "I. Phân tử - Đơn chất và Hợp chất",
                    summary: "",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "M3kP9svb86M",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s2_2",
                    title: "1. Đơn chất và Hợp chất",
                    summary: "Đơn chất:** Là những chất được tạo nên từ một nguyên tố hóa học (Ví dụ: Khí oxygen $\\text{O}_2$ tạo từ nguyên tố $\\text{O}$; lá đồng $\\text{Cu}$ tạo từ nguyên tố $\\text{Cu}$).; Hợp chất:** Là những chất được tạo nên từ hai hoặc nhiều nguyên tố hóa học hòa hợp với nhau theo một tỉ lệ xác định (Ví dụ: Nước $\\text{H}_2\\text{O}$ tạo từ nguyên tố $\\text{H}$ và $\\text{O}$; Muối ăn $\\text{NaCl}$ tạo từ nguyên tố $\\text{Na}$ và $\\text{Cl}$).",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "M3kP9svb86M",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s2_3",
                    title: "2. Phân tử và Khối lượng phân tử",
                    summary: "Phân tử:** Là hạt đại diện cho chất, gồm một số nguyên tử liên kết với nhau bằng liên kết hóa học và thể hiện đầy đủ tính chất hóa học của chất.; Khối lượng phân tử:** Bằng tổng khối lượng các nguyên tử có trong phân tử (tính theo đơn vị amu).; Ví dụ:* Khối lượng phân tử của $\\text{H}_2\\text{O} = 2 \\cdot 1\\text{ (amu)} + 1 \\cdot 16\\text{ (amu)} = 18\\text{ amu}$.",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "wrV_tID-0IA",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s2_4",
                    title: "II. Giới thiệu về liên kết hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "Exix86yUiHs",
                    channelName: "Thầy Nguyễn Chí Sơn",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s2_5",
                    title: "1. Quy tắc octet (quy tắc 8 electron)",
                    summary: "Nguyên tử của các nguyên tố có xu hướng nhường, nhận hoặc dùng chung electron để đạt được lớp electron ngoài cùng bền vững giống như khí hiếm (thường là 8 electron, riêng Hydrogen là 2 electron).",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "Exix86yUiHs",
                    channelName: "Thầy Nguyễn Chí Sơn",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s2_6",
                    title: "2. Liên kết ion",
                    summary: "Là liên kết được hình thành bởi lực hút tĩnh điện giữa các ion mang điện tích trái dấu (thường xảy ra giữa nguyên tử kim loại điển hình và phi kim điển hình).; Cơ chế:* Nguyên tử kim loại nhường electron biến thành ion dương (cation), nguyên tử phi kim nhận electron biến thành ion âm (anion). Hai ion này hút nhau tạo thành liên kết ion (Ví dụ: liên kết trong phân tử $\\text{NaCl}$).",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "D-0f3e1SAt4",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s2_7",
                    title: "3. Liên kết cộng hóa trị",
                    summary: "Là liên kết được hình thành giữa hai nguyên tử bằng một hoặc nhiều cặp electron dùng chung (thường xảy ra giữa các nguyên tử phi kim với nhau).; Phân loại:*; Chất cộng hóa trị không phân cực: Cặp electron dùng chung lệch đều về hai bên (Ví dụ: $\\text{H}_2, \\text{O}_2, \\text{N}_2$).",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "D-0f3e1SAt4",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s2_8",
                    title: "III. Hóa trị và Công thức hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "M3kP9svb86M",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s2_9",
                    title: "1. Công thức hóa học",
                    summary: "Công thức hóa học dùng để biểu diễn chữ viết của chất.; Dạng tổng quát của công thức hóa học:** $\\text{A}_x\\text{B}_y$ hoặc $\\text{A}_x\\text{B}_y\\text{C}_z$.; $\\text{A, B, C}$: Kí hiệu hóa học của các nguyên tố.",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "M3kP9svb86M",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g7_s2_10",
                    title: "2. Hóa trị và Quy tắc hóa trị",
                    summary: "Hóa trị:** Là con số biểu thị khả năng liên kết của nguyên tử nguyên tố này với nguyên tử nguyên tố khác. Quy ước chọn hóa trị của $\\text{H}$ làm đơn vị ($\\text{I}$) và hóa trị của $\\text{O}$ là $\\text{II}$.; Quy tắc hóa trị:** Trong công thức hóa học của hợp chất hai nguyên tố $\\text{A}_x^a\\text{B}_y^b$ (với $a, b$ lần lượt là hóa trị của nguyên tố $\\text{A, B}$): Tích của chỉ số và hóa trị của nguyên tố này bằng tích của chỉ số và hóa trị của nguyên tố kia.; Ứng dụng:**",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "M3kP9svb86M",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 8, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s1_1",
                    title: "I. Phản ứng hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "PtVsPixQVkU",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s1_2",
                    title: "1. Biến đổi vật lí và biến đổi hóa học",
                    summary: "Biến đổi vật lí:** Là hiện tượng chất có sự thay đổi về trạng thái, hình dạng, kích thước... nhưng vẫn giữ nguyên là chất ban đầu, không có chất mới tạo thành (Ví dụ: nước đá tan thành nước lỏng, hòa tan đường vào nước).; Biến đổi hóa học:** Là hiện tượng chất có sự biến đổi tạo thành chất khác (Ví dụ: đốt cháy củi khô thành tro than, đinh sắt để ngoài không khí bị rỉ sét).",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "PtVsPixQVkU",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s1_3",
                    title: "2. Phản ứng hóa học",
                    summary: "Khái niệm:** Phản ứng hóa học là quá trình biến đổi chất này thành chất khác.; Chất ban đầu bị biến đổi gọi là **chất phản ứng** (chất tham gia).; Chất mới sinh ra gọi là **sản phẩm** (chất tạo thành).",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "wYgS37jBV8k",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s1_4",
                    title: "3. Định luật bảo toàn khối lượng và Phương trình hóa học",
                    summary: "Định luật bảo toàn khối lượng:** Trong một phản ứng hóa học, tổng khối lượng của các chất sản phẩm bằng tổng khối lượng của các chất phản ứng.; Biểu thức:* Cho phản ứng $A + B \\rightarrow C + D$, ta có: $m_A + m_B = m_C + m_D$.; Phương trình hóa học:** Dùng để biểu diễn ngắn gọn phản ứng hóa học bằng công thức hóa học.",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "5Wj-98YFpNw",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s1_5",
                    title: "II. Mol và Tính toán hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "YRSDdiEHsWU",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s1_6",
                    title: "1. Khái niệm về Mol",
                    summary: "Mol:** Là lượng chất có chứa $6,022 \\cdot 10^{23}$ hạt vi mô (nguyên tử hoặc phân tử) của chất đó. Con số $N = 6,022 \\cdot 10^{23}$ gọi là hằng số Avogadro.; Khối lượng mol ($M$):** Là khối lượng tính bằng gam của 1 mol chất đó. Trị số của khối lượng mol bằng trị số của nguyên tử khối hoặc phân tử khối tính theo đơn vị amu (Ví dụ: $M_{O_2} = 32\\text{ g/mol}$).; Thể tích mol của chất khí:** Là thể tích chiếm bởi 1 mol chất khí đó. Ở điều kiện chuẩn (đktc: nhiệt độ $25^\\circ\\text{C}$, áp suất $1\\text{ bar}$), 1 mol của bất kỳ chất khí nào cũng đều chiếm thể tích là **$24,79\\text{ lít}$**.",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "YRSDdiEHsWU",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s1_7",
                    title: "2. Các công thức tính toán cốt lõi",
                    summary: "Tính số mol ($n$):**; Theo khối lượng: $n = \\frac{m}{M}$ (với $m$ là khối lượng tính bằng gam).; Theo thể tích khí (đktc): $n = \\frac{V}{24,79}$ (với $V$ là thể tích khí tính bằng lít).",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "lP_9Zu1K-Q0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s1_8",
                    title: "3. Nồng độ dung dịch",
                    summary: "Nồng độ phần trăm ($C\\%$):** Cho biết số gam chất tan có trong 100 gam dung dịch.; (Lưu ý: $m_{dd} = m_{ct} + m_{dm}$ với $dm$ là dung môi).*; Nồng độ mol ($C_M$):** Cho biết số mol chất tan có trong 1 lít dung dịch.",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "QeL8uqPndyA",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 8, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s2_1",
                    title: "I. Tốc độ phản ứng và Chất xúc tác",
                    summary: "",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "SrJAeKX8sgg",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s2_2",
                    title: "II. Các hợp chất vô cơ thông dụng",
                    summary: "",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "l74_07GoaCk",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s2_3",
                    title: "1. Oxide (Oxit)",
                    summary: "Khái niệm:** Là hợp chất gồm hai nguyên tố, trong đó có một nguyên tố là Oxygen.; Phân loại:**; Oxide acid (Oxit axit):* Thường là oxide của phi kim, tác dụng với base tạo thành muối và nước (Ví dụ: $CO_2, SO_2, P_2O_5$).",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "l74_07GoaCk",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s2_4",
                    title: "2. Acid (Axit)",
                    summary: "Khái niệm:** Là hợp chất mà phân tử gồm có một hay nhiều nguyên tử Hydrogen liên kết với gốc acid. Khi tan trong nước, acid tạo ra ion $H^+$.; Công thức tổng quát:** $H_n X$ ($X$ là gốc acid). Ví dụ: $HCl, H_2SO_4, HNO_3$.; Tính chất hóa học:**",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "QDVGQwxU8XA",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s2_5",
                    title: "3. Base (Bazơ)",
                    summary: "Khái niệm:** Là hợp chất mà phân tử gồm có một nguyên tử kim loại liên kết với một hay nhiều nhóm hydroxide ($-OH$). Khi tan trong nước, base tạo ra ion $OH^-$.; Công thức tổng quát:** $M(OH)_n$ ($M$ là kim loại).; Base tan (Kiềm):* $NaOH, KOH, Ca(OH)_2, Ba(OH)_2$.",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "pzjncAQjAC0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s2_6",
                    title: "4. Thang pH và Muối",
                    summary: "Thang pH:** Dùng để biểu thị độ acid hoặc độ base của một dung dịch (thường từ 1 đến 14).; $\\text{pH} < 7$: Dung dịch có tính acid (pH càng nhỏ tính acid càng mạnh).; $\\text{pH} = 7$: Dung dịch trung tính (nước tinh khiết).",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "pzjncAQjAC0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g8_s2_7",
                    title: "III. Phân bón hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "Y9FA0NC72pU",
                    channelName: "Học trực tuyến OLM",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 9, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s1_1",
                    title: "I. Tính chất hóa học của các hợp chất vô cơ (Nâng cao)",
                    summary: "",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "QeMV_vK9clw",
                    channelName: "CHUYÊN ĐỀ 1 – CÁC HỢP CHẤT VÔ CƠ - ÔN...",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s1_2",
                    title: "II. Kim loại",
                    summary: "",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "F37AeQh8JM0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s1_3",
                    title: "1. Tính chất vật lí và hóa học của kim loại",
                    summary: "Tính chất vật lí:** Có tính dẻo, tính dẫn điện, tính dẫn nhiệt và có ánh kim.; Tính chất hóa học:**; Tác dụng với phi kim (như Oxygen tạo oxide base, tác dụng với phi kim khác như Chlorine, Sulfur tạo muối).",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "F37AeQh8JM0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s1_4",
                    title: "2. Dãy hoạt động hóa học của kim loại",
                    summary: "K, Na, Ca, Mg, Al, Zn, Fe, Ni, Sn, Pb, (H), Cu, Hg, Ag, Pt, Au**; (Mẹo nhớ: Khi Nào Cần May Áo Giáp Sắt Nên Sang Phố Hỏi Cửa Hàng Bạc Bạch Kim Vàng).*; Ý nghĩa của dãy hoạt động:**",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "eoZ4ok1jp0k",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s1_5",
                    title: "3. Gang và Thép (Hợp kim của sắt)",
                    summary: "Gang:** Là hợp kim của Iron ($Fe$) với Carbon ($C$), trong đó hàm lượng Carbon chiếm từ $2 - 5\\%$, cùng một số nguyên tố khác.; Thép:** Là hợp kim của Iron ($Fe$) với Carbon ($C$), trong đó hàm lượng Carbon dưới $2\\%$. Thép có độ bền, độ dẻo và tính đàn hồi cao hơn gang.; Sự ăn mòn kim loại:** Là sự phá hủy kim loại hoặc hợp kim do tác dụng hóa học của môi trường xung quanh (nhất là nước và không khí). Biện pháp bảo vệ: sơn, mạ, bôi dầu mỡ lên bề mặt kim loại hoặc chế tạo hợp kim chống rỉ.",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "6ljsdB6t_9g",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s1_6",
                    title: "III. Phi kim",
                    summary: "",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "bo-loCo3lyk",
                    channelName: "VietJack TV Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s1_7",
                    title: "1. Tính chất của phi kim",
                    summary: "Tính chất vật lí:** Có thể ở cả 3 thể (rắn như $C, P, S$; lỏng như $Br_2$; khí như $O_2, Cl_2, N_2$), phần lớn không dẫn điện, dẫn nhiệt kém.; Tính chất hóa học:** Tác dụng với kim loại tạo thành muối hoặc oxide; tác dụng với Hydrogen tạo thành hợp chất khí; tác dụng với Oxygen tạo thành oxide acid.",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "bo-loCo3lyk",
                    channelName: "VietJack TV Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s1_8",
                    title: "2. Sơ lược về Sắt, Nhôm và một số phi kim quan trọng",
                    summary: "Aluminum ($Al$):** Có tính lưỡng tính đặc biệt, cấu tạo lớp oxide bảo vệ bền vững, tan được trong dung dịch kiềm giải phóng $H_2$.; Iron ($Fe$):** Có nhiều hóa trị ($\\text{II}$ và $\\text{III}$) tùy thuộc vào chất phản ứng mạnh hay yếu.; Chlorine ($Cl_2$):** Phi kim hoạt động hóa học mạnh, độc hại, có tính tẩy màu và sát trùng mạnh khi tan trong nước tạo thành nước Clo.",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "C_QUvPi5-B0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 9, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s2_1",
                    title: "I. Khái niệm về hợp chất hữu cơ và Hydrocarbon",
                    summary: "",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "rD_mcrpTum0",
                    channelName: "Tuyensinh247 - Học trực tuyến",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s2_2",
                    title: "1. Khái niệm về hợp chất hữu cơ",
                    summary: "Định nghĩa:** Hợp chất hữu cơ là hợp chất của Carbon (trừ các oxide của carbon như $CO, CO_2$, muối carbonate, các carbide kim loại như $CaC_2$).; Phân loại:** Gồm 2 loại chính:; Hydrocarbon:* Phân tử chỉ chứa hai nguyên tố là Carbon ($C$) và Hydrogen ($H$).",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "rD_mcrpTum0",
                    channelName: "Tuyensinh247 - Học trực tuyến",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s2_3",
                    title: "2. Methane ($CH_4$)",
                    summary: "Là thành phần chính trong khí metan, khí thiên nhiên, khí mỏ dầu, khí bùn ao. Trong phân tử chỉ có các liên kết đơn.; Tính chất hóa học:** Tham gia phản ứng cháy tỏa nhiều nhiệt và **phản ứng thế** với Chlorine khi có ánh sáng.",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "TrIpzF2C3R4",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s2_4",
                    title: "3. Ethylene ($C_2H_4$)",
                    summary: "Trong phân tử có chứa một **liên kết đôi** ($C=C$). Liên kết đôi này có một liên kết kém bền, dễ bị đứt ra trong các phản ứng hóa học.; Tính chất hóa học:** Tham gia phản ứng cháy, **phản ứng cộng** làm mất màu dung dịch Bromine ($Br_2$), và **phản ứng trùng hợp** tạo thành polyethylene (nhựa PE).",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "em4hL636dF8",
                    channelName: "Giac Cao Cu",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s2_5",
                    title: "4. Acetylene ($C_2H_2$)",
                    summary: "Trong phân tử có chứa một **liên kết ba** ($C \\equiv C$), trong đó có hai liên kết kém bền dễ bị đứt lần lượt trong các phản ứng.; Tính chất hóa học:** Tham gia phản ứng cháy (ngọn lửa đèn xì acetylen có nhiệt độ rất cao dùng để hàn cắt kim loại) và phản ứng cộng với dung dịch Bromine qua hai giai đoạn.",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "bBNUVqXdI90",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s2_6",
                    title: "II. Dẫn xuất của Hydrocarbon",
                    summary: "",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "bBNUVqXdI90",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s2_7",
                    title: "1. Ethanoic acid (Axit axetic - $CH_3COOH$)",
                    summary: "Là thành phần chính của giấm ăn (nồng độ từ $2 - 5\\%$). Trong phân tử có nhóm carboxyl ($-COOH$) gây ra tính acid.; Tính chất hóa học:**; Mang đầy đủ tính chất của một acid yếu (làm quỳ tím hóa đỏ, tác dụng với kim loại trước $H$, oxide base, base và muối carbonate).",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "bBNUVqXdI90",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s2_8",
                    title: "2. Rượu etylic (Ethanol - $C_2H_5OH$)",
                    summary: "Là chất lỏng, phân tử chứa nhóm hydroxyl ($-OH$) quyết định tính chất đặc trưng. Khái niệm độ rượu là số ml rượu nguyên chất có trong 100 ml hỗn hợp rượu với nước.; Tính chất hóa học:** Phản ứng cháy tỏa nhiệt, phản ứng với kim loại kiềm ($Na, K$) giải phóng khí $H_2$, phản ứng lên men giấm tạo thành ethanoic acid.",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "ksY2qQjHlJk",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s2_9",
                    title: "3. Chất béo, Glucose và Sucrose",
                    summary: "Chất béo:** Là hợp chất este phức tạp, thành phần chính của dầu thực vật và mỡ động vật. Tham gia phản ứng thủy phân trong môi trường acid hoặc môi trường kiềm (gọi là **phản ứng xà phòng hóa** tạo ra xà phòng và glycerol).; Glucose ($C_{6}H_{12}O_{6}$):** Có vị ngọt trong quả chín (nhất là quả nho). Tham gia phản ứng oxi hóa bởi dung dịch AgNO3 trong amoniac tạo ra lớp bạc trắng sáng (gọi là **phản ứng tráng bạc**), phản ứng lên men rượu.; Sucrose ($C_{12}H_{22}O_{11}$):** Là thành phần chính của đường mía, đường thốt nốt. Tham gia phản ứng thủy phân trong môi trường acid tạo ra glucose và fructose.",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "tfb5h3w7sJ8",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g9_s2_10",
                    title: "4. Tinh bột, Cellulose và Protein",
                    summary: "Tinh bột và Cellulose:** Là các polymer tự nhiên có công thức chung là $(C_6H_{10}O_5)_n$. Tinh bột có nhiều trong các loại hạt ngũ cốc, củ; Cellulose có nhiều trong sợi bông, tre, gỗ. Tinh bột có phản ứng đặc trưng làm **dung dịch Iodine ($I_2$) chuyển sang màu xanh tím**. Cả hai đều bị thủy phân đến cùng tạo thành Glucose.; Protein:** Là hợp chất hữu cơ cực kỳ phức tạp cấu tạo nên cơ thể sống. Có phản ứng thủy phân tạo thành các amino acid và hiện tượng đông tụ bởi nhiệt độ hoặc acid/base (Ví dụ: lòng trắng trứng đông tụ khi đun nóng).",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "acs2E3z7QIU",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 10, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s1_1",
                    title: "I. Nhập môn Hóa học và Cấu tạo nguyên tử",
                    summary: "",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "Zkt2DaBE4qI",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s1_2",
                    title: "1. Nhập môn Hóa học",
                    summary: "Đối tượng nghiên cứu của Hóa học:** Nghiên cứu về thành phần, cấu trúc, tính chất và sự biến đổi của chất, cùng với năng lượng đi kèm các quá trình biến đổi đó.; Phương pháp học tập và nghiên cứu Hóa học:** Phương pháp tìm hiểu lý thuyết, phương pháp nghiên cứu thực nghiệm (quan sát, thí nghiệm), phương pháp sử dụng mô hình hóa/mô phỏng.",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "Zkt2DaBE4qI",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s1_3",
                    title: "2. Cấu tạo hạt nhân và Vỏ nguyên tử",
                    summary: "Thành phần cấu tạo nguyên tử:**; Hạt nhân:* Gồm hạt proton ($p$, điện tích $+1$, khối lượng $\\approx 1\\text{ amu}$) và neutron ($n$, điện tích $0$, khối lượng $\\approx 1\\text{ amu}$).; Vỏ nguyên tử:* Gồm các electron ($e$, điện tích $-1$, khối lượng rất nhỏ $\\approx 0,00055\\text{ amu}$).",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "o3BFIpU2xS0",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s1_4",
                    title: "3. Cấu trúc lớp vỏ electron của nguyên tử",
                    summary: "Chuyển động của electron trong nguyên tử:** Các electron chuyển động rất nhanh trong khu vực xung quanh hạt nhân không theo những quỹ đạo xác định, tạo nên **vỏ nguyên tử (đám mây electron)**. Khái niệm orbital nguyên tử (AO) là vùng không gian xung quanh hạt nhân mà tại đó xác suất tìm thấy electron là lớn nhất ($\\ge 90\\%$). Các AO có hình dạng cơ bản: AO $s$ (hình cầu), AO $p$ (hình số 8 nổi).; Lớp và phân lớp electron:**; Lớp electron:* Gồm các electron có năng lượng gần bằng nhau. Được đánh số từ trong ra ngoài: $n = 1, 2, 3, 4, 5, 6, 7$ tương ứng với tên lớp: $K, L, M, N, O, P, Q$. Số electron tối đa trong một lớp là $2n^2$.",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "mtnZG4P1MBM",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s1_5",
                    title: "II. Bảng tuần hoàn các nguyên tố hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "t-CMW4VVqbk",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s1_6",
                    title: "1. Cấu tạo của Bảng tuần hoàn",
                    summary: "Nguyên tắc sắp xếp:** Theo chiều tăng dần của điện tích hạt nhân; Các nguyên tố có cùng số lớp electron được xếp vào một hàng; Các nguyên tố có cùng số electron hóa trị được xếp vào một cột.; Cấu trúc:**; Ô nguyên tố:* Cho biết số hiệu nguyên tử ($Z$), kí hiệu, tên nguyên tố, khối lượng nguyên tử trung bình, độ âm điện, cấu hình electron...",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "t-CMW4VVqbk",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s1_7",
                    title: "2. Xu hướng biến đổi tính chất trong Bảng tuần hoàn",
                    summary: "Trong một chu kì (từ trái sang phải theo chiều tăng $Z$):**; Bán kính nguyên tử: **Giảm dần** (do lực hút của hạt nhân tăng).; Độ âm điện: **Tăng dần**.",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "NybPsy7yu3Q",
                    channelName: "Thầy Nguyễn Chí Sơn",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 10, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s2_1",
                    title: "I. Liên kết hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "_bYtnzLU4-c",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s2_2",
                    title: "1. Liên kết ion và Liên kết cộng hóa trị",
                    summary: "Quy tắc octet:** Các nguyên tử có xu hướng nhường, nhận hoặc góp chung electron hóa trị để đạt cấu hình electron bền vững của khí hiếm gần nhất với 8 electron lớp ngoài cùng (hoặc 2 electron đối với Helium).; Liên kết ion:** Được hình thành bởi lực hút tĩnh điện giữa các ion mang điện tích trái dấu (cation kim loại và anion phi kim). Hợp chất ion có nhiệt độ nóng chảy và nhiệt độ sôi cao, dẫn điện tốt khi nóng chảy hoặc tan trong nước.; Liên kết cộng hóa trị:** Được hình thành giữa hai nguyên tử bằng một hoặc nhiều cặp electron dùng chung.",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "_bYtnzLU4-c",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s2_3",
                    title: "2. Tương tác van der Waals và Liên kết hydrogen",
                    summary: "Liên kết hydrogen:** Bản chất là lực hút tĩnh điện yếu giữa nguyên tử $\\text{H}$ đã liên kết với một nguyên tử có độ âm điện lớn (như $\\text{F, O, N}$) có cặp electron hóa trị chưa tham gia liên kết của nguyên tử có độ âm điện lớn khác. Làm tăng nhiệt độ sôi, nhiệt độ nóng chảy và tính tan của chất (Ví dụ: nước, ethanol).; Tương tác van der Waals:** Là lực tương tác tĩnh điện yếu giữa các phân tử (hoặc nguyên tử khí hiếm) do sự xuất hiện của các lưỡng cực tạm thời và lưỡng cực cảm ứng. Tương tác tăng khi khối lượng phân tử và kích thước đám mây electron tăng.",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "w5_yC8QMue0",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s2_4",
                    title: "II. Phản ứng Oxi hóa - Khử và Năng lượng hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "VHDl_jq2l6M",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s2_5",
                    title: "1. Phản ứng Oxi hóa - Khử",
                    summary: "Số oxi hóa (SOH):** Là điện tích giả định của nguyên tử trong phân tử nếu giả định rằng tất cả các liên kết trong phân tử đều là liên kết ion. Quy tắc xác định số oxi hóa (đơn chất = 0; tổng SOH trong phân tử = 0; SOH của ion bằng điện tích ion; thông thường $\\text{H} = +1, \\text{O} = -2$, kim loại nhóm IA, IIA, Al bằng số thứ tự nhóm kèm dấu $+$).; Khái niệm cốt lõi:**; Chất khử (chất bị oxi hóa):* Chất **nhường** electron $\\rightarrow$ Số oxi hóa **tăng** sau phản ứng.",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "VHDl_jq2l6M",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s2_6",
                    title: "2. Năng lượng hóa học (Nhiệt hóa học)",
                    summary: "Phản ứng tỏa nhiệt và Phản ứng thu nhiệt:**; Phản ứng tỏa nhiệt:* Giải phóng năng lượng dưới dạng nhiệt ra môi trường ($\\Delta_{r}H < 0$).; Phản ứng thu nhiệt:* Hấp thụ năng lượng dưới dạng nhiệt từ môi trường ($\\Delta_{r}H > 0$).",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "D0e2wUvZzqo",
                    channelName: "Tuyensinh247 - Học trực tuyến",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s2_7",
                    title: "III. Tốc độ phản ứng hóa học và Khái quát về nhóm Halogen",
                    summary: "",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "ycVHeHWoLEI",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g10_s2_8",
                    title: "1. Tốc độ phản ứng hóa học",
                    summary: "Khái niệm:** Là đại lượng đặc trưng cho mức độ nhanh hay chậm của một phản ứng hóa học, được xác định bằng sự biến thiên nồng độ của một trong các chất phản ứng hoặc chất sản phẩm trong một đơn vị thời gian.; Các yếu tố ảnh hưởng đến tốc độ phản ứng:**; Nồng độ:* Tăng nồng độ chất phản ứng làm tăng tần số va chạm hiệu quả $\\rightarrow$ tốc độ tăng.",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "ycVHeHWoLEI",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 11, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s1_1",
                    title: "I. Cân bằng hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "2wD8sFFjddw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s1_2",
                    title: "1. Khái niệm về phản ứng thuận nghịch và trạng thái cân bằng",
                    summary: "Phản ứng một chiều:** Phản ứng chỉ xảy ra theo một chiều từ chất phản ứng tạo thành sản phẩm.; Phản ứng thuận nghịch:** Phản ứng xảy ra theo hai chiều trái ngược nhau trong cùng một điều kiện. Chiều từ trái sang phải là chiều thuận, chiều từ phải sang trái là chiều nghịch.; Trạng thái cân bằng:** Là trạng thái của phản ứng thuận nghịch khi tốc độ phản ứng thuận bằng tốc độ phản ứng nghịch (vt = vn). Cân bằng hóa học là cân bằng động (phản ứng vẫn tiếp diễn nhưng nồng độ các chất không thay đổi).",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "2wD8sFFjddw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s1_3",
                    title: "2. Sự chuyển dịch cân bằng hóa học (Nguyên lí Le Chatelier)",
                    summary: "Nguyên lí Le Chatelier:** Khi một hệ đang ở trạng thái cân bằng chịu một tác động từ bên ngoài làm thay đổi nồng độ, nhiệt độ hoặc áp suất thì cân bằng sẽ chuyển dịch theo chiều làm giảm tác động bên ngoài đó.; Các yếu tố ảnh hưởng:**; Nồng độ:* Tăng nồng độ một chất -> cân bằng chuyển dịch theo chiều giảm nồng độ chất đó (chiều tương tác tiêu thụ chất đó).",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "nxe-gbq67PY",
                    channelName: "Thầy Hải - Dạy Hóa Online",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s1_4",
                    title: "II. Cân bằng trong dung dịch nước",
                    summary: "",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "hqFjTzASiLM",
                    channelName: "VietJack TV Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s1_5",
                    title: "1. Sự điện li",
                    summary: "Khái niệm:** Sự điện li là quá trình phân rã các chất thành ion khi tan trong nước hoặc ở trạng thái nóng chảy. Chất điện li gồm acid, base và muối.; Chất điện li mạnh:** Khi tan trong nước, các phân tử hòa tan đều phân li hoàn toàn thành ion (Ví dụ: acid mạnh HCl, HNO3, H2SO4; base mạnh NaOH, KOH, Ca(OH)2; và hầu hết các muối). Biểu diễn bằng mũi tên một chiều (->).; Chất điện li yếu:** Khi tan trong nước, chỉ có một phần số phân tử hòa tan phân li thành ion, phần còn lại vẫn tồn tại dưới dạng phân tử (Ví dụ: acid yếu CH3COOH, H2CO3, H2S; base yếu NH3, Mg(OH)2). Biểu diễn bằng mũi tên thuận nghịch (⇌).",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "hqFjTzASiLM",
                    channelName: "VietJack TV Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s1_6",
                    title: "2. Thuyết Acid - Base của Brønsted - Lowry",
                    summary: "Acid:** Là chất có khả năng nhường proton (H+).; Base:** Là chất có khả năng nhận proton (H+).; Chất lưỡng tính:** Là chất vừa có khả năng nhường, vừa có khả năng nhận proton (H+) (Ví dụ: H2O, HCO3-, Al(OH)3).",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "hqFjTzASiLM",
                    channelName: "VietJack TV Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s1_7",
                    title: "3. Khái niệm về pH và Ý nghĩa của pH trong thực tiễn",
                    summary: "Tích số ion của nước (Kw):** Ở 25°C, Kw = [H+] * [OH-] = 10^-14.; Công thức tính pH:** pH = -log[H+] -> [H+] = 10^-pH.; Môi trường dung dịch:** Môi trường acid (pH < 7); Môi trường trung tính (pH = 7); Môi trường base (pH > 7).",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "mgYEkU-StKY",
                    channelName: "Manabie Vietnam",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s1_8",
                    title: "III. Nitrogen và Sulfur",
                    summary: "",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "MrO6KFuJ5mg",
                    channelName: "TRỌNG PHẠM",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s1_9",
                    title: "1. Đơn chất Nitrogen (N2) và Ammonia (NH3)",
                    summary: "Nitrogen (N2):** Ở nhiệt độ thường khá trơ về mặt hóa học do có liên kết ba bền vững (N≡N). Ở nhiệt độ cao, thể hiện cả tính khử (tác dụng với O2) và tính oxi hóa (tác dụng với kim loại hoạt động mạnh, H2).; Ammonia (NH3):** Phân tử có cấu trúc hình chóp tam giác, phân cực mạnh. Có tính base yếu (tác dụng với nước, acid, dung dịch muối) và tính khử mạnh do số oxi hóa của N là -3 thấp nhất (tác dụng với O2, CuO).; Muối ammonium (NH4+):** Đều dễ tan, là chất điện li mạnh, dễ bị nhiệt phân hủy và tác dụng với dung dịch kiềm giải phóng khí NH3.",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "MrO6KFuJ5mg",
                    channelName: "TRỌNG PHẠM",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s1_10",
                    title: "2. Nitric acid (HNO3) và Hiện tượng phú dưỡng",
                    summary: "Nitric acid (HNO3):** Là một acid mạnh và là một chất oxi hóa cực kỳ mạnh. Tác dụng với hầu hết kim loại (trừ Pt, Au) tạo thành muối nitrate, nước và các sản phẩm khử của N (như NO2, NO, N2O, N2, NH4NO3) tùy thuộc vào độ hoạt động của kim loại và nồng độ acid. Không giải phóng khí H2.; Hiện tượng phú dưỡng (Eutrophication):** Ao, hồ nhận quá nhiều nguồn dinh dưỡng chứa hợp chất của nitrogen và phosphorus từ nước thải, phân bón dư thừa làm tảo, thực vật thủy sinh phát triển bùng phát, khi chết đi phân hủy làm cạn kiệt oxygen trong nước, gây độc cho thủy sinh vật.",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "vrqhMoau8do",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s1_11",
                    title: "3. Sulfur (S), Sulfur dioxide (SO2) và Sulfuric acid (H2SO4)",
                    summary: "Sulfur (S):** Có các dạng thù hình (tà phương, đơn tà). Thể hiện tính oxi hóa (tác dụng với kim loại, H2) và tính khử (tác dụng với phi kim mạnh hơn như O2, F2).; Sulfur dioxide (SO2):** Oxide acid độc, khí không màu, mùi hắc. Vừa có tính khử (tác dụng với O2, Cl2, KMnO4), vừa có tính oxi hóa (tác dụng với H2S). Là một trong các tác nhân chính gây mưa acid.; Sulfuric acid (H2SO4):**",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "YPQnaS7DoR0",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 11, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s2_1",
                    title: "I. Đại cương về Hóa học hữu cơ",
                    summary: "",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "fQcDkujbfrI",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s2_2",
                    title: "1. Phân loại và Phương pháp tách biệt hợp chất hữu cơ",
                    summary: "Đặc điểm chung:** Liên kết trong phân tử chủ yếu là liên kết cộng hóa trị. Các hợp chất hữu cơ thường kém bền nhiệt, dễ cháy, phản ứng hóa học xảy ra chậm, không hoàn toàn và theo nhiều hướng (tạo hỗn hợp sản phẩm).; Phương pháp tách biệt và tinh chế:**; Phương pháp chưng cất:* Tách các chất lỏng có nhiệt độ sôi khác nhau rõ rệt.",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "fQcDkujbfrI",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s2_3",
                    title: "2. Công thức phân tử và Cấu tạo hóa học",
                    summary: "Công thức đơn giản nhất (CTĐGN):** Biểu thị tỉ lệ tối giản về số nguyên tử của các nguyên tố trong phân tử.; Công thức phân tử (CTPT):** Biểu thị số lượng nguyên tử thực tế của mỗi nguyên tố trong phân tử. CTPT = (CTĐGN)n.; Thuyết cấu tạo hóa học:** Các nguyên tử liên kết với nhau theo đúng hóa trị và theo một thứ tự nhất định. Việc thay đổi thứ tự liên kết sẽ tạo ra chất mới. Carbon luôn có hóa trị IV trong hợp chất hữu cơ, có thể tạo mạch hở (không nhánh, có nhánh) hoặc mạch vòng.",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "GbGGVDoUOF8",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s2_4",
                    title: "II. Hydrocarbon",
                    summary: "",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "CYH2FW4Fe0Q",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s2_5",
                    title: "1. Alkane (Hydrocarbon no)",
                    summary: "Khái niệm:** Là những hydrocarbon mạch hở, trong phân tử chỉ chứa các liên kết đơn C-C và C-H. Công thức chung: CnH2n+2 (n >= 1).; Tính chất hóa học:** Do chỉ có liên kết sigma bền vững nên alkane tương đối trơ ở nhiệt độ thường.; Phản ứng thế Halogen:* Ưu tiên thế vào carbon bậc cao hơn (tạo sản phẩm chính).",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "CYH2FW4Fe0Q",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s2_6",
                    title: "2. Alkene và Alkyne (Hydrocarbon không no)",
                    summary: "Alkene:** Hydrocarbon mạch hở chứa 1 liên kết đôi C=C. Công thức chung: CnH2n (n >= 2). Có đồng phân hình học (cis - trans) khi các nhóm thế ở mỗi carbon mang liên kết đôi khác nhau từng đôi một.; Alkyne:** Hydrocarbon mạch hở chứa 1 liên kết ba C≡C. Công thức chung: CnH2n-2 (n >= 2).; Tính chất hóa học đặc trưng:** Do có liên kết pi kém bền.",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "xHQjSYBMFLo",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g11_s2_7",
                    title: "3. Arene (Hydrocarbon thơm)",
                    summary: "Khái niệm:** Là những hydrocarbon trong phân tử có chứa vòng benzene. Công thức chung của dãy đồng đẳng benzene: CnH2n-6 (n >= 6).; Tính chất hóa học (Tính thơm):** Dễ thế, khó cộng và bền vững với các chất oxi hóa.; Phản ứng thế (Halogen, Nitro hóa):* Benzene tham gia phản ứng thế. Đối với các alkylbenzene (như toluene), phản ứng thế vào vòng diễn ra dễ dàng hơn và ưu tiên định hướng vào vị trí ortho và para. Toluene có khả năng bị oxi hóa nhóm alkyl bởi dung dịch KMnO4 khi đun nóng tạo muối benzoate.",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "E3ps3CJkGAc",
                    channelName: "Hydrocarbon thơm... (VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 12, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s1_1",
                    title: "I. Ester và Lipid",
                    summary: "",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "hEuHcAhAwu8",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s1_2",
                    title: "1. Ester (Este)",
                    summary: "Khái niệm:** Khi thay thế nhóm -OH ở nhóm carboxyl của carboxylic acid bằng nhóm -OR' của alcohol thì ta thu được ester. Công thức chung của ester đơn chức: RCOOR'.; Tính chất vật lí:** Thường là chất lỏng hoặc chất rắn, nhẹ hơn nước, rất ít tan trong nước. Thường có mùi thơm dễ chịu của hoa quả chín (Ví dụ: isoamyl acetate có mùi chuối chín, ethyl butyrate có mùi dứa).; Tính chất hóa học:**",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "hEuHcAhAwu8",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s1_3",
                    title: "2. Lipid (Chất béo)",
                    summary: "Khái niệm:** Chất béo là triester của glycerol với các acid béo, gọi chung là triglyceride. Định dạng cấu tạo tổng quát: (RCOO)3C3H5.; Các acid béo thường gặp:**; Acid béo no: Acid palmitic (C15H31COOH), Acid stearic (C17H35COOH). -> Tạo ra chất béo rắn (mỡ động vật).",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "hEuHcAhAwu8",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s1_4",
                    title: "II. Carbohydrate (Saccarit)",
                    summary: "",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "G_N2AfqUsuw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s1_5",
                    title: "1. Monosaccharide: Glucose và Fructose (C6H12O6)",
                    summary: "Glucose:** Là hợp chất tạp chức, dạng mạch hở có 5 nhóm -OH và 1 nhóm -CH=O (aldehyde). Trong y học dùng làm thuốc tăng lực (đường huyết chiếm 0,1%).; Tính chất:* Tác dụng với Cu(OH)2 ở nhiệt độ thường tạo dung dịch màu xanh lam; Phản ứng tráng bạc với AgNO3/NH3 tạo lớp bạc sáng; Phản ứng lên men rượu tạo ra C2H5OH và CO2.; Fructose:** Là đồng phân của glucose, dạng mạch hở có 5 nhóm -OH và 1 nhóm -C=O (ketone). Có nhiều trong mật ong. Trong môi trường kiềm, fructose có thể chuyển hóa qua lại với glucose nên cũng tham gia phản ứng tráng bạc.",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "G_N2AfqUsuw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s1_6",
                    title: "2. Disaccharide: Sucrose và Maltose (C12H22O11)",
                    summary: "Sucrose (Đường mía):** Cấu tạo gồm 1 gốc glucose và 1 gốc fructose liên kết với nhau qua nguyên tử oxygen. Không có nhóm chức aldehyde nên không có tính khử (không tráng bạc).; Tính chất:* Hòa tan Cu(OH)2 tạo dung dịch xanh lam; Phản ứng thủy phân trong môi trường acid tạo ra hỗn hợp glucose và fructose.",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "G_N2AfqUsuw",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s1_7",
                    title: "3. Polysaccharide: Tinh bột và Cellulose ((C6H10O5)n)",
                    summary: "Tinh bột:** Gồm hai dạng cấu trúc là amylose (mạch không phân nhánh) và amylopectin (mạch phân nhánh).; Tính chất:* Phản ứng thủy phân nhờ acid hoặc enzyme tạo ra glucose; Phản ứng màu đặc trưng với iodine (I2) tạo hợp chất màu xanh tím (biến mất khi đun nóng, hiện lại khi để nguội).; Cellulose:** Mạch không phân nhánh, cấu tạo từ các gốc glucose. Là thành phần chính cấu tạo nên màng tế bào thực vật (gỗ, bông).",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "QY_EJ0hXsv0",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s1_8",
                    title: "III. Hợp chất chứa Nitrogen: Amine, Amino acid và Protein",
                    summary: "",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "5nPfKxoNEGE",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s1_9",
                    title: "1. Amine",
                    summary: "Khái niệm:** Khi thay thế một hoặc nhiều nguyên tử hydrogen trong phân tử NH3 bằng một hoặc nhiều gốc hydrocarbon, ta thu được amine (Phân loại bậc 1, bậc 2, bậc 3).; Aniline (C6H5NH3):** Là amine thơm điển hình, chất lỏng không màu, độc, rất ít tan trong nước.; Tính chất hóa học:** Có tính base yếu (tương tự NH3). Amine mạch hở làm quỳ tím hóa xanh. Aniline có tính base rất yếu không làm đổi màu quỳ tím, nhưng có phản ứng đặc trưng tác dụng với nước bromine tạo kết tủa trắng.",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "5nPfKxoNEGE",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s1_10",
                    title: "2. Amino acid và Peptide",
                    summary: "Amino acid:** Hợp chất hữu cơ tạp chức, phân tử chứa đồng thời nhóm amino (-NH2) và nhóm carboxyl (-COOH). Tồn tại chủ yếu ở dạng ion lưỡng cực, là chất rắn kết tinh, dễ tan trong nước. (Ví dụ: Glycine, Alanine, Valine, Glutamic acid, Lysine).; Peptide:** Là hợp chất chứa từ 2 đến 50 gốc alpha-amino acid liên kết với nhau bằng các liên kết peptide (-CO-NH-).; Tính chất:* Phản ứng thủy phân hoàn toàn hoặc không hoàn toàn; Phản ứng màu biuret với Cu(OH)2 trong môi trường kiềm tạo hợp chất màu tím đặc trưng (chỉ áp dụng cho tripeptide trở lên).",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "c1MyZSe2H3Y",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s1_11",
                    title: "3. Protein (Chất đạm)",
                    summary: "Khái niệm:** Là những polypeptide cao phân tử có khối lượng phân tử lớn từ vài vạn đến vài triệu. Gồm protein đơn giản và protein phức tạp.; Tính chất:** Có sự đông tụ bởi nhiệt độ hoặc acid/base (Ví dụ: hiện tượng luộc trứng, riêu cua); Phản ứng thủy phân tạo các alpha-amino acid; Tham gia phản ứng màu biuret tạo màu tím.",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "G3Yu1986BtA",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 12, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s2_1",
                    title: "I. Vật liệu Polymer",
                    summary: "",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "iYpVgMWlkg0",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s2_2",
                    title: "II. Đại cương về kim loại",
                    summary: "",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "D5OosK53G6E",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s2_3",
                    title: "1. Tính chất của kim loại và Cặp oxi hóa - khử",
                    summary: "Tính chất vật lí chung:** Tính dẻo, tính dẫn điện, tính dẫn nhiệt và có ánh kim. Gây ra bởi sự dịch chuyển tự do của các electron trong mạng tinh thể kim loại.; Tính chất hóa học chung:** **Tính khử** (M -> M^n+ + ne). Tác dụng với phi kim, dung dịch acid, dung dịch muối, nước.; Dãy điện hóa của kim loại:** Sắp xếp các cặp oxi hóa - khử theo chiều tính oxi hóa của ion kim loại tăng dần và tính khử của kim loại giảm dần.",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "D5OosK53G6E",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s2_4",
                    title: "2. Sự ăn mòn kim loại",
                    summary: "Ăn mòn hóa học:** Là quá trình oxi hóa - khử, trong đó các electron của kim loại được chuyển trực tiếp đến các chất trong môi trường (Ví dụ: thanh sắt trong lò đốt bị ăn mòn bởi khí O2, nước chứa acid). Không phát sinh dòng điện.; Ăn mòn điện hóa học:** Là sự phá hủy kim loại do hợp kim tiếp xúc với dung dịch chất điện li và phát sinh dòng điện.; Điều kiện:* Có hai cực khác nhau về bản chất (kim loại - kim loại, kim loại - phi kim); Hai cực tiếp xúc trực tiếp hoặc gián tiếp qua dây dẫn; Cùng nhúng vào dung dịch chất điện li.",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "a0p1rzZYwoY",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s2_5",
                    title: "3. Điều chế kim loại",
                    summary: "Nguyên tắc chung:** Khử ion kim loại thành nguyên tử (M^n+ + ne -> M).; Các phương pháp điều chế:**; Phương pháp thủy luyện:* Dùng kim loại mạnh đẩy kim loại yếu ra khỏi dung dịch muối (Điều chế kim loại đứng sau Mg).",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "S-qjSLCBMAA",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_hóa_g12_s2_6",
                    title: "III. Sơ lược về một số kim loại chuyển tiếp dãy thứ nhất (Iron - Sắt)",
                    summary: "",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "C9dQAxBpEgM",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 6, 1):
            return [
            ]
        case ("sinh học", 6, 2):
            return [
            ]
        case ("sinh học", 7, 1):
            return [
            ]
        case ("sinh học", 7, 2):
            return [
            ]
        case ("sinh học", 8, 1):
            return [
            ]
        case ("sinh học", 8, 2):
            return [
            ]
        case ("sinh học", 9, 1):
            return [
            ]
        case ("sinh học", 9, 2):
            return [
            ]
        case ("sinh học", 10, 1):
            return [
            ]
        case ("sinh học", 10, 2):
            return [
            ]
        case ("sinh học", 11, 1):
            return [
            ]
        case ("sinh học", 11, 2):
            return [
            ]
        case ("sinh học", 12, 1):
            return [
            ]
        case ("sinh học", 12, 2):
            return [
            ]
        case ("lịch sử", 6, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s1_1",
                    title: "I. Nhập môn Lịch sử",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 1,
                    videoId: "b-p_HJx77Wg",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s1_2",
                    title: "II. Xã hội nguyên thủy",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 1,
                    videoId: "UxA5VOsO7Qw",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s1_3",
                    title: "III. Lịch sử thế giới cổ đại",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 1,
                    videoId: "w_GPWYW62yk",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s1_4",
                    title: "1. Các quốc gia cổ đại phương Đông (Ai Cập, Lưỡng Hà, Ấn Độ, Trung Quốc)",
                    summary: "Điều kiện tự nhiên:** Hình thành ở lưu vực các con sông lớn (Sông Nile ở Ai Cập; Sông Tigris và Euphrates ở Lưỡng Hà; Sông Ấn và Sông Hằng ở Ấn Độ; Sông Hoàng Hà và Trường Giang ở Trung Quốc). Đất đai phù sa màu mỡ, thuận lợi cho nông nghiệp trồng lúa nước nhưng dễ bị lũ lụt.; Chế độ chính trị:** Chế độ quân chủ chuyên chế trung ương tập quyền (Vua đứng đầu và nắm mọi quyền hành tối cao, gọi là Pharaon ở Ai Cập, Thiên tử ở Trung Quốc).; Thành tựu văn hóa tiêu biểu:** Phát minh ra lịch pháp và thiên văn học; sáng tạo chữ viết cổ (chữ tượng hình); toán học ứng dụng (phép đếm, hình học); các công trình kiến trúc kỳ vĩ (Kim tự tháp Ai Cập, Vạn Lý Trường Thành Trung Quốc).",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 1,
                    videoId: "w_GPWYW62yk",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s1_5",
                    title: "2. Các quốc gia cổ đại phương Tây (Hy Lạp và La Mã)",
                    summary: "Điều kiện tự nhiên:** Hình thành ở vùng ven biển Địa Trung Hải, địa hình nhiều đồi núi, đất đai khô cằn. Thuận lợi phát triển thủ công nghiệp (làm gốm, đúc đồng) và thương nghiệp đường biển (hàng hải, buôn bán).; Chế độ chính trị:** Chế độ chiếm nô, tổ chức theo mô hình nhà nước thành bang (Hy Lạp) hoặc đế chế (La Mã). Hình thành các hình thức dân chủ sơ khai (đại hội công dân, viện nguyên lão), coi trọng quyền công dân (nhưng chỉ áp dụng cho chủ nô và công dân tự do, không áp dụng cho nô lệ).; Thành tựu văn hóa tiêu biểu:** Hệ thống chữ cái La-tinh (A, B, C...) và chữ số La Mã; các ngành khoa học cơ bản phát triển rực rỡ (tên tuổi các vĩ nhân như Thales, Pythagoras, Aristotle); kiến trúc và điêu khắc đỉnh cao (Đấu trường Colosseum, đền Parthenon).",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 1,
                    videoId: "IzFwMKhyfiA",
                    channelName: "VietJack THPT Official",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 6, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s2_1",
                    title: "I. Nước Văn Lang và Âu Lạc",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "iFnOADSAgi0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s2_2",
                    title: "1. Nước Văn Lang (Khoảng thế kỷ VII TCN - 208 TCN)",
                    summary: "Cơ sở hình thành:** Sự phát triển của văn hóa Đông Sơn và nghề trồng lúa nước; nhu cầu trị thủy (đắp đê chống lũ) và chống giặc ngoại xâm.; Tổ chức nhà nước:** Kinh đô đặt tại Phong Châu (Phú Thọ). Đứng đầu nhà nước là Hùng Vương (cha truyền con nối), giúp việc có Lạc hầu, Lạc tướng. Cả nước chia làm 15 bộ, đứng đầu các bộ là Lạc tướng. Đứng đầu các làng xã (chiềng, chạ) là Bồ chính. Nhà nước còn sơ khai, chưa có luật pháp và quân đội thường trực.; Đời sống vật chất và tinh thần:**",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "nGDnoy9cuQw",
                    channelName: "800 TC... (Sử Lược - Tóm Tắt Lịch Sử",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s2_3",
                    title: "2. Nước Âu Lạc (208 TCN - 179 TCN)",
                    summary: "Sự thành lập:** Thục Phán hợp nhất người Tây Âu và Lạc Việt sau cuộc kháng chiến chống quân xâm lược Tần thành công, lên ngôi lấy hiệu là An Dương Vương, lập ra nước Âu Lạc, dời đô về Cổ Loa (Đông Anh, Hà Nội).; Sự phát triển:** Tổ chức nhà nước chặt chẽ hơn, quyền lực nhà nước tập trung vào tay vua nhiều hơn. Có quân đội mạnh, chế tạo được nỏ liên châu (nỏ thần bắn một lần được nhiều mũi tên). Xây dựng thành Cổ Loa kiên cố với kiến trúc 3 vòng thành xoáy ốc vừa là căn cứ quân sự, vừa là trung tâm chính trị.; Sụp đổ:** Năm 179 TCN, do chủ quan và mất cảnh giác, An Dương Vương bị Triệu Đà (nhà Triệu) đánh bại. Nước Âu Lạc rơi vào tay phong kiến phương Bắc, mở đầu thời kỳ Bắc thuộc.",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "nGDnoy9cuQw",
                    channelName: "800 TC... (Sử Lược - Tóm Tắt Lịch Sử",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s2_4",
                    title: "II. Thời kỳ Bắc thuộc và cuộc đấu tranh giành độc lập dân tộc (Từ thế kỷ II TCN đến thế kỷ X)",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "lOeq8pMtMsc",
                    channelName: "Sử Lược - Tóm Tắt Lịch Sử",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s2_5",
                    title: "1. Chính sách cai trị của phong kiến phương Bắc",
                    summary: "Về hành chính:** Sáp nhập lãnh thổ nước ta vào bản đồ Trung Quốc, chia thành các quận, huyện, cử quan lại người Hán sang cai trị trực tiếp tới tận cấp huyện.; Về kinh tế:** Áp đặt chính sách vơ vét, bóc lột thuế khóa nặng nề; độc quyền muối và sắt; bắt nhân dân ta cống nạp sản vật quý hiếm (ngọc trai, ngà voi, sừng tê giác) và đi lao dịch khổ sai.; Về văn hóa (Chính sách đồng hóa):** Bắt nhân dân ta phải theo phong tục tập quán, luật pháp, học chữ Hán và tiếp thu Nho giáo của Trung Quốc nhằm xóa bỏ văn hóa bản địa của người Việt.",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "EbpbPlqMm1Y",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s2_6",
                    title: "2. Các cuộc khởi nghĩa tiêu biểu trong thời kỳ Bắc thuộc",
                    summary: "Khởi nghĩa Hai Bà Trưng (Năm 40):** Chống lại ách cai trị của nhà Đông Hán (Thái thú Tô Định). Cuộc khởi nghĩa bùng nổ ở Hát Môn, nhanh chóng làm chủ các quận, lật đổ chính quyền đô hộ. Trưng Trắc lên ngôi vua (Trưng Vương), đóng đô ở Mê Linh. Đây là cuộc khởi nghĩa mở đầu cho kỷ nguyên đấu tranh giành độc lập của người Việt.; Khởi nghĩa Bà Triệu (Năm 248):** Chống nhà Ngô. Bà Triệu (Triệu Thị Trinh) nổi dậy ở căn cứ Phú Điền (Thanh Hóa) với câu nói nổi tiếng: *\"Tôi muốn cưỡi cơn gió mạnh, đạp luồng sóng dữ, chém cá kình ở biển Đông...\"*. Cuộc khởi nghĩa thất bại nhưng để lại tấm gương kiên cường bất khuất.; Khởi nghĩa Lý Bí và nước Vạn Xuân (Năm 542 - 602):** Chống nhà Lương. Năm 542, Lý Bí nổi dậy khởi nghĩa, quét sạch chính quyền đô hộ. Năm 544, Lý Bí lên ngôi hoàng đế (Lý Nam Đế), đặt tên nước là Vạn Xuân (mong muốn đất nước yên bình vạn mùa xuân), dựng kinh đô ở vùng cửa sông Tô Lịch. Sau này, Triệu Quang Phục tiếp tục kháng chiến chống Lương thành công trước khi nước Vạn Xuân bị nhà Tùy xâm lược vào năm 602.",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "DgD55v_zTG8",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g6_s2_7",
                    title: "3. Bước ngoặt lịch sử đầu thế kỷ X",
                    summary: "Cuộc tự chủ của họ Khúc và họ Dương:**; Năm 905, Khúc Thừa Dụ nhân lúc nhà Đường suy yếu đã nổi dậy chiếm tống bình, tự xưng Tiết độ sứ, đặt nền móng cho quyền tự chủ.; Năm 931, Dương Đình Nghệ đánh bại quân Nam Hán xâm lược lần thứ nhất, tiếp tục giữ vững nền độc lập tự chủ.",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "5xUOj80URW0",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 7, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_lịc_g7_s1_1",
                    title: "I. Lịch sử thế giới trung đại",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "NI2bOHk87SU",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g7_s1_2",
                    title: "1. Quá trình hình thành và phát triển của chế độ phong kiến Tây Âu",
                    summary: "Sự hình thành:** Từ thế kỷ V, các bộ tộc người Germain tràn vào xâm chiếm lãnh thổ của đế quốc La Mã, thành lập các vương quốc mới. Họ phong chức tước, chia ruộng đất cho các tướng lĩnh quân sự và quý tộc, hình thành các giai cấp mới: Lãnh chúa phong kiến và Nông nô. Chế độ phong kiến Tây Âu chính thức hình thành.; Lãnh địa phong kiến:** Là vùng đất rộng lớn thuộc sở hữu cá nhân của lãnh chúa, bao gồm đất trồng trọt, đồng cỏ, rừng rậm và lâu đài. Kính tế lãnh địa mang tính chất tự cấp, tự túc, đóng kín, ít có sự trao đổi với bên ngoài. Lãnh chúa có quyền lực tuyệt đối trong lãnh địa, bóc lột nông nô bằng địa tô và các loại thuế.; Sự xuất hiện của các thành thị trung đại:** Từ thế kỷ XI, do sản xuất phát triển, hàng hóa dư thừa, các thợ thủ công và thương nhân tập hợp tại các đầu mối giao thông để buôn bán, lập ra các thành thị. Thành thị phá vỡ kinh tế tự cấp tự túc của lãnh địa, thúc đẩy kinh tế hàng hóa phát triển và góp phần xóa bỏ chế độ phong kiến phân quyền.",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "CxqZgzKyIZE",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g7_s1_3",
                    title: "2. Các cuộc phát kiến địa lí và sự hình thành quan hệ sản xuất tư bản chủ nghĩa",
                    summary: "Các cuộc phát kiến địa lí lớn (Thế kỷ XV - XVI):**; B. Dias (1487):* Đi đến mũi Hảo Vọng (cực Nam châu Phi).; C. Columbus (1492):* Tìm ra châu Mỹ (nhưng ông lầm tưởng là Ấn Độ).",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "fiSsxtZwJco",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g7_s1_4",
                    title: "3. Phong trào Văn hóa Phục hưng và Cải cách tôn giáo",
                    summary: "Phong trào Văn hóa Phục hưng (Thế kỷ XIV - XVII):** Xuất hiện đầu tiên ở Ý, nhằm khôi phục và phát triển những giá trị tinh hoa của văn hóa cổ đại Hy Lạp - La Mã. Tư tưởng chủ đạo là chủ nghĩa nhân văn, đề cao giá trị con người, đả kích giáo hội Thiên Chúa giáo và chế độ phong kiến. Xuất hiện nhiều vĩ nhân như Leonardo da Vinci, William Shakespeare, Galileo Galilei.; Phong trào Cải cách tôn giáo:** Khởi xướng bởi Martin Luther (Đức) và Jean Calvin (Thụy Sĩ). Phong trào phê phán những hành vi tham nhũng, độc đoán của Giáo hội Phê-rô, đòi bãi bỏ các nghi lễ phiền toái, thúc đẩy sự ra đời của đạo Tin Lành (Protestantism).",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "mkmjVRtBzo8",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g7_s1_5",
                    title: "4. Lịch sử Trung Quốc và Ấn Độ thời phong kiến",
                    summary: "Trung Quốc:** Phát triển rực rỡ qua các triều đại Đường, Tống, Nguyên, Minh, Thanh. Bộ máy nhà nước quân chủ chuyên chế ngày càng hoàn thiện và tập quyền sâu sắc. Nền kinh tế phát triển mạnh, xuất hiện mầm mống tư bản chủ nghĩa thời Minh - Thanh. Văn hóa phát triển đỉnh cao với tứ đại phát minh (giấy, in, la bàn, thuốc súng) và kho tàng văn học đồ sộ (Thủy hử, Tam quốc diễn nghĩa, Tây du ký).; Ấn Độ:** Trải qua các thời kỳ vương triều Gupta, vương triều Hồi giáo Delhi và đế quốc Mughal. Nền kinh tế nông nghiệp kết hợp thủ công nghiệp truyền thống sắc sảo. Văn hóa Ấn Độ đa dạng, là nơi giao thoa giữa đạo Hindu, đạo Phật và đạo Hồi; kiến trúc tiêu biểu có đền Taj Mahal.",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "NI2bOHk87SU",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g7_s1_6",
                    title: "II. Lịch sử Việt Nam từ thế kỷ X đến đầu thế kỷ XI",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "_JiQiu9mMhE",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g7_s1_7",
                    title: "1. Thời kỳ Ngô - Đinh - Tiền Lê (939 - 1009)",
                    summary: "Nhà Ngô (939 - 965):** Ngô Quyền lên ngôi vua, chọn Cổ Loa làm kinh đô, xây dựng chính quyền độc lập bước đầu ổn định. Sau khi Ngô Quyền mất, đất nước rơi vào thời kỳ **\"Loạn 12 sứ quân\"**.; Nhà Đinh (968 - 980):** Đinh Bộ Lĩnh có công dẹp loạn 12 sứ quân, thống nhất đất nước, lên ngôi Hoàng đế (Đinh Tiên Hoàng), đặt tên nước là **Đại Cồ Việt**, đóng đô ở Hoa Lư (Ninh Bình). Nhà Đinh củng cố bộ máy hành chính, xây dựng quân đội và đúc tiền đồng đầu tiên (Thái Bình hưng bảo).; Nhà Tiền Lê (980 - 1009):** Lê Hoàn được suy tôn lên ngôi vua (Lê Đại Hành) để tổ chức lãnh đạo cuộc kháng chiến chống quân xâm lược Tống lần thứ nhất (năm 981). Quân ta giành thắng lợi vang dội trên sông Bạch Đằng và chi lăng, bảo vệ vững chắc nền độc lập.",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "O__ADZZg-tM",
                    channelName: "THẦY LIÊM",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 7, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_lịc_g7_s2_1",
                    title: "I. Nước Đại Việt thời Lý (1009 - 1225)",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 2,
                    videoId: "yDYgOuCMPqQ",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g7_s2_2",
                    title: "II. Nước Đại Việt thời Trần (1226 - 1400)",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 2,
                    videoId: "Alut71_wxow",
                    channelName: "... (VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_lịc_g7_s2_3",
                    title: "III. Nước Đại Việt thời Hồ (1400 - 1407)",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 2,
                    videoId: "BHvYjKgRlos",
                    channelName: "VietJack Tiểu học & THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 8, 1):
            return [
            ]
        case ("lịch sử", 8, 2):
            return [
            ]
        case ("lịch sử", 9, 1):
            return [
            ]
        case ("lịch sử", 9, 2):
            return [
            ]
        case ("lịch sử", 10, 1):
            return [
            ]
        case ("lịch sử", 10, 2):
            return [
            ]
        case ("lịch sử", 11, 1):
            return [
            ]
        case ("lịch sử", 11, 2):
            return [
            ]
        case ("lịch sử", 12, 1):
            return [
            ]
        case ("lịch sử", 12, 2):
            return [
            ]
        case ("địa lí", 6, 1):
            return [
            ]
        case ("địa lí", 6, 2):
            return [
            ]
        case ("địa lí", 7, 1):
            return [
            ]
        case ("địa lí", 7, 2):
            return [
            ]
        case ("địa lí", 8, 1):
            return [
            ]
        case ("địa lí", 8, 2):
            return [
            ]
        case ("địa lí", 9, 1):
            return [
            ]
        case ("địa lí", 9, 2):
            return [
            ]
        case ("địa lí", 10, 1):
            return [
            ]
        case ("địa lí", 10, 2):
            return [
            ]
        case ("địa lí", 11, 1):
            return [
            ]
        case ("địa lí", 11, 2):
            return [
            ]
        case ("địa lí", 12, 1):
            return [
            ]
        case ("địa lí", 12, 2):
            return [
            ]
        default:
            return []
        }
    }
}
