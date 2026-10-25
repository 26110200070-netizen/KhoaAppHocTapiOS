import Foundation

/// Kho dữ liệu chương trình học chuẩn hóa cho 6 môn học (Toán, Vật lí, Hóa học, Sinh học, Lịch sử, Địa lí) từ tài liệu trithucAI
struct SubjectCurriculumStore {
    static let shared = SubjectCurriculumStore()
    private init() {}

    func getTopics(subject: String, grade: Int, semester: Int) -> [TheoryTopicItem] {
        let s = subject.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch (s, grade, semester) {
        case ("toán", 6, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s1_1",
                    title: "Số học và Đại số",
                    summary: "",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Tập Hợp & Số Tự Nhiên 6",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_2",
                    title: "1. Tập hợp và Số tự nhiên",
                    summary: "**Tập hợp và phần tử:** Ký hiệu thuộc ($\\in$) và không thuộc ($\\notin$). Cách viết một tập hợp bằng cách liệt kê phần tử hoặc chỉ ra tính chất đặc trưng.; **Tập hợp các số tự nhiên:** Tập $\\mathbb{N}$ (từ số 0) và tập $\\",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Tập Hợp & Số Tự Nhiên 6",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_3",
                    title: "2. Tính chất chia hết trong tập hợp số tự nhiên",
                    summary: "**Quan hệ chia hết:** Khái niệm ước và bội. Cách tìm tập hợp các ước Ư($a$) và tập hợp các bội B($a$).; **Tính chất chia hết của một tổng:** Nếu tất cả các số hạng đều chia hết cho $m$ thì tổng chia hết cho $m$. Nếu có đ",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Tập Hợp & Số Tự Nhiên 6",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_4",
                    title: "3. Số nguyên",
                    summary: "**Tập hợp số nguyên ($\\mathbb{Z}$):** Trục số nguyên, số đối của một số nguyên. Khái niệm số nguyên âm, số nguyên dương và số 0. So sánh hai số nguyên.; **Các phép tính trong tập hợp số nguyên:**",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Tập Hợp & Số Tự Nhiên 6",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_5",
                    title: "Hình học trực quan (Hình học phẳng cơ bản)",
                    summary: "**Tam giác đều, Hình vuông, Hình lục giác đều:** Nhận biết các đặc điểm cơ bản về cạnh, góc, đường chéo và cách vẽ bằng dụng cụ học tập.; **Hình chữ nhật, Hình thoi, Hình bình hành, Hình thang cân:**",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Tập Hợp & Số Tự Nhiên 6",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 6, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s2_1",
                    title: "Số học và Đại số (tiếp theo)",
                    summary: "",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Tập Hợp & Số Tự Nhiên 6",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_2",
                    title: "1. Phân số",
                    summary: "**Khái niệm phân số:** Mở rộng phân số với tử và mẫu là các số nguyên ($\\frac{a}{b}$ với $a, b \\in \\mathbb{Z}, b \\neq 0$). Hai phân số bằng nhau.; **Tính chất cơ bản của phân số:** Nhân hoặc chia cả tử và mẫu với cùng mộ",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Tập Hợp & Số Tự Nhiên 6",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_3",
                    title: "2. Số thập phân",
                    summary: "**Khái niệm số thập phân:** Số thập phân âm, số thập phân dương. Số đối của số thập phân.; **Các phép tính với số thập phân:** Cộng, trừ, nhân, chia số thập phân (tuân theo quy tắc đặt tính và quy tắc dấu tương tự số ngu",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Tập Hợp & Số Tự Nhiên 6",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_4",
                    title: "Hình học phẳng (Điểm, Đường thẳng, Góc)",
                    summary: "**Điểm, Đường thẳng:** Điểm thuộc đường thẳng, điểm không thuộc đường thẳng. Ba điểm thẳng hàng, ba điểm không thẳng hàng. Hai đường thẳng cắt nhau, hai đường thẳng song song.; **Tia:** Khái niệm tia, hai tia đối nhau, h",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Tập Hợp & Số Tự Nhiên 6",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_5",
                    title: "Một số yếu tố Thống kê và Xác suất",
                    summary: "**Thu thập và phân loại dữ liệu:** Cách thu thập dữ liệu (quan sát, lập bảng hỏi). Dữ liệu là số (số liệu) và dữ liệu không phải là số.; **Biểu diễn dữ liệu:**",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Tập Hợp & Số Tự Nhiên 6",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 7, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s1_1",
                    title: "Số học và Đại số",
                    summary: "",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_2",
                    title: "1. Số hữu tỉ",
                    summary: "**Tập hợp số hữu tỉ ($\\mathbb{Q}$):** Định nghĩa số hữu tỉ là số viết được dưới dạng phân số $\\frac{a}{b}$ với $a, b \\in \\mathbb{Z}, b \\neq 0$. Biểu diễn số hữu tỉ trên trục số và so sánh các số hữu tỉ.; **Các phép tính",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_3",
                    title: "2. Số thực",
                    summary: "**Số thập phân hữu hạn và số thập phân vô hạn tuần hoàn:** Cách nhận biết và viết một phân số dưới dạng số thập phân.; **Số vô tỉ:** Định nghĩa số vô tỉ là số viết được dưới dạng số thập phân vô hạn không tuần hoàn. Khái",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_4",
                    title: "3. Tỉ lệ thức và Đại lượng tỉ lệ",
                    summary: "**Tỉ lệ thức:** Định nghĩa $\\frac{a}{b} = \\frac{c}{d}$. Tính chất cơ bản của tỉ lệ thức ($a \\cdot d = b \\cdot c$).; **Tính chất của dãy tỉ số bằng nhau:** $\\frac{a}{b} = \\frac{c}{d} = \\frac{e}{f} = \\frac{a+c+e}{b+d+f} =",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_5",
                    title: "Hình học trực quan và Hình học phẳng cơ bản",
                    summary: "",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_6",
                    title: "1. Hình khối trong thực tiễn",
                    summary: "**Hình lăng trụ đứng tam giác, Hình lăng trụ đứng tứ giác:**",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_7",
                    title: "2. Góc và Đường thẳng song song",
                    summary: "**Góc ở vị trí đặc biệt:** Hai góc kề bù (có tổng bằng $180^\\circ$), hai góc đối đỉnh (thì bằng nhau). Tia phân giác của một góc.; **Hai đường thẳng song song:**",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 7, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s2_1",
                    title: "Số học và Đại số (tiếp theo)",
                    summary: "",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_2",
                    title: "1. Biểu thức đại số và Đa thức một biến",
                    summary: "**Biểu thức đại số:** Khái niệm biểu thức đại số, tính giá trị của một biểu thức đại số tại giá trị cho trước của biến.; **Đa thức một biến:**",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_3",
                    title: "Hình học phẳng (Tam giác)",
                    summary: "",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_4",
                    title: "1. Tam giác và Các trường hợp bằng nhau",
                    summary: "**Tổng các góc trong một tam giác:** Bằng $180^\\circ$.; **Hai tam giác bằng nhau:** Định nghĩa hai tam giác bằng nhau.",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_5",
                    title: "2. Quan hệ giữa các yếu tố trong tam giác",
                    summary: "**Quan hệ giữa góc và cạnh đối diện:** Trong một tam giác, góc đối diện với cạnh lớn hơn là góc lớn hơn và ngược lại.; **Quan hệ giữa đường vuông góc và đường xiên:** Đường vuông góc là đường ngắn nhất trong các đường kẻ",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_6",
                    title: "3. Các đường đồng quy trong tam giác",
                    summary: "**Đường trung tuyến:** Ba đường trung tuyến đồng quy tại một điểm gọi là **Trọng tâm**. Trọng tâm cách mỗi đỉnh một khoảng bằng $\\frac{2}{3}$ độ dài đường trung tuyến đi qua đỉnh đó.; **Đường phân giác:** Ba đường phân g",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_7",
                    title: "Thống kê và Xác suất",
                    summary: "",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_8",
                    title: "1. Thu thập, biểu diễn và phân tích dữ liệu",
                    summary: "**Biểu đồ đoạn thẳng:** Đọc, phân tích thông tin và vẽ biểu đồ đoạn thẳng biểu diễn xu hướng thay đổi của dữ liệu theo thời gian.; **Biểu đồ hình quạt tròn:** Đọc, phân tích thông tin và hiểu ý nghĩa biểu diễn tỉ lệ phần",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_9",
                    title: "2. Biến cố và Xác suất của biến cố",
                    summary: "**Làm quen với biến cố:** Khái niệm biến cố chắc chắn, biến cố không thể và biến cố ngẫu nhiên.; **Xác suất của biến cố ngẫu nhiên:** Tính xác suất của một số biến cố ngẫu nhiên đơn giản trong các trò chơi (tung đồng xu,",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Thầy Kenka • Số Hữu Tỉ & Tam Giác 7",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 8, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s1_1",
                    title: "Đa thức và Hằng đẳng thức",
                    summary: "",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_2",
                    title: "1. Đa thức nhiều biến",
                    summary: "**Đơn thức và đa thức nhiều biến:** Khái niệm đơn thức, đa thức nhiều biến. Đơn thức đồng dạng. Thu gọn và tìm bậc của đa thức.; **Các phép tính với đa thức:**",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_3",
                    title: "2. Hằng đẳng thức đáng nhớ",
                    summary: "**7 Hằng đẳng thức đáng nhớ:**; **Phân tích đa thức thành nhân tử:** Các phương pháp cơ bản gồm đặt nhân tử chung, dùng hằng đẳng thức, nhóm hạng tử, và phối hợp nhiều phương pháp.",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_4",
                    title: "Phân thức đại số",
                    summary: "**Khái niệm phân thức đại số:** Biểu thức có dạng $\\frac{A}{B}$ với $A, B$ là các đa thức và $B$ khác đa thức 0. Điều kiện xác định và giá trị của phân thức.; **Tính chất cơ bản:** Khái niệm hai phân thức bằng nhau. Rút",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_5",
                    title: "Hình học trực quan và Hình học phẳng",
                    summary: "",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_6",
                    title: "1. Hình khối trong thực tiễn",
                    summary: "**Hình chóp tam giác đều và Hình chóp tứ giác đều:**",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_7",
                    title: "2. Tứ giác",
                    summary: "**Tứ giác:** Định nghĩa tứ giác lồi. Tổng các góc của một tứ giác bằng $360^\\circ$.; **Các hình tứ giác đặc biệt:** Định nghĩa, tính chất và dấu hiệu nhận biết của:",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 8, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s2_1",
                    title: "Hàm số và Đồ thị",
                    summary: "**Khái niệm hàm số:** Định nghĩa hàm số, biến số. Giá trị của hàm số $y = f(x)$ tại một điểm.; **Tọa độ phẳng:** Hệ trục tọa độ Oxy, tọa độ của một điểm $(x; y)$.",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_2",
                    title: "Phương trình bậc nhất một ẩn",
                    summary: "**Khái niệm phương trình bậc nhất một ẩn:** Phương trình có dạng $ax + b = 0$ ($a \\neq 0$).; **Cách giải phương trình:** Vận dụng quy tắc chuyển vế và quy tắc nhân với một số để tìm nghiệm.",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_3",
                    title: "Hình học phẳng (Định lý Thales và Tam giác đồng dạng)",
                    summary: "",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_4",
                    title: "1. Định lý Thales trong tam giác",
                    summary: "**Định lý Thales (Thuận và Đảo):** Nếu một đường thẳng song song với một cạnh của tam giác và cắt hai cạnh còn lại thì nó định ra trên hai cạnh đó những đoạn thẳng tương ứng tỉ lệ.; **Đường trung bình của tam giác:** Địn",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_5",
                    title: "2. Tam giác đồng dạng",
                    summary: "**Khái niệm:** Định nghĩa hai tam giác đồng dạng, tỉ số đồng dạng $k$.; **Các trường hợp đồng dạng của hai tam giác thường:**",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_6",
                    title: "Một số yếu tố Thống kê và Xác suất",
                    summary: "",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_7",
                    title: "1. Thống kê",
                    summary: "**Thu thập và lựa chọn dữ liệu:** Lựa chọn phương pháp thu thập dữ liệu thích hợp. Biểu diễn dữ liệu bằng các dạng biểu đồ đã học.; **Biểu đồ đoạn thẳng và Biểu đồ hình quạt tròn:** Phân tích và xử lý số liệu thu được từ",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_8",
                    title: "2. Xác suất",
                    summary: "**Xác suất của biến cố ngẫu nhiên:** Định nghĩa xác suất của biến cố trong các mô hình đồng khả năng:",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "VietJack • Hằng Đẳng Thức & Đa Thức 8",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 9, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s1_1",
                    title: "Căn thức",
                    summary: "",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "VietJack • Căn Bậc Hai & Ba 9",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_2",
                    title: "1. Căn bậc hai và Căn bậc ba",
                    summary: "**Căn bậc hai số học:** Định nghĩa căn bậc hai số học của số không âm $a$ là số không âm $x$ sao cho $x^2 = a$ (Ký hiệu: $\\sqrt{a}$).; **Điều kiện xác định:** Căn thức bậc hai $\\sqrt{A}$ xác định (có nghĩa) khi và chỉ kh",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "VietJack • Căn Bậc Hai & Ba 9",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_3",
                    title: "2. Các phép biến đổi căn thức bậc hai",
                    summary: "**Khai phương một tích và Nhân các căn thức bậc hai:** $\\sqrt{A \\cdot B} = \\sqrt{A} \\cdot \\sqrt{B}$ (với $A \\ge 0, B \\ge 0$).; **Khai phương một thương và Chia các căn thức bậc hai:** $\\sqrt{\\frac{A}{B}} = \\frac{\\sqrt{A}",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "VietJack • Căn Bậc Hai & Ba 9",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_4",
                    title: "Phương trình và Hệ phương trình",
                    summary: "",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "Tuyensinh247 • Hệ Phương Trình & Bậc Hai 9",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_5",
                    title: "1. Phương trình quy về phương trình bậc nhất một ẩn",
                    summary: "**Phương trình tích:** Phương trình dạng $A(x) \\cdot B(x) = 0 \\Leftrightarrow A(x) = 0$ hoặc $B(x) = 0$.; **Phương trình chứa ẩn ở mẫu:** Các bước giải bao gồm tìm điều kiện xác định (ĐKXH), quy đồng mẫu thức hai vế và k",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "Tuyensinh247 • Hệ Phương Trình & Bậc Hai 9",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_6",
                    title: "2. Hệ hai phương trình bậc nhất hai ẩn",
                    summary: "**Khái niệm:** Hệ có dạng $\\begin{cases} ax + by = c \\\\ a'x + b'y = c' \\end{cases}$; **Phương pháp giải:**",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "Tuyensinh247 • Hệ Phương Trình & Bậc Hai 9",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_7",
                    title: "Hình học phẳng và Hệ thức lượng",
                    summary: "",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Toán 9 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_8",
                    title: "1. Hệ thức lượng trong tam giác vuông",
                    summary: "**Các hệ thức về cạnh và đường cao:** Cho tam giác $ABC$ vuông tại $A$, đường cao $AH$, gọi b, c là 2 cạnh góc vuông; a là cạnh huyền; b', c' là hình chiếu của b, c trên cạnh huyền; h là đường cao:; **Tỉ số lượng giác củ",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Toán 9 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_9",
                    title: "2. Đường tròn (Phần cơ bản)",
                    summary: "**Khái niệm đường tròn:** Định nghĩa, sự xác định đường tròn, tính chất đối xứng của đường tròn.; **Quan hệ đường kính và dây cung:** Đường kính vuông góc với một dây thì đi qua trung điểm của dây ấy và ngược lại.",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Toán 9 SGK Mới",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 9, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s2_1",
                    title: "Đại số (Hàm số và Phương trình bậc hai)",
                    summary: "",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "Tuyensinh247 • Hệ Phương Trình & Bậc Hai 9",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_2",
                    title: "1. Hàm số $y = ax^2$ ($a \\neq 0$) và Phương trình bậc hai một ẩn",
                    summary: "**Hàm số $y = ax^2$:** Tính chất đồng biến, nghịch biến tùy thuộc vào dấu của hệ số $a$. Đồ thị hàm số là một đường Parabol nhận trục Oy làm trục đối xứng.; **Phương trình bậc hai một ẩn:** Phương trình có dạng $ax^2 + b",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "Tuyensinh247 • Hệ Phương Trình & Bậc Hai 9",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_3",
                    title: "Hình học phẳng và Hình khối (Đường tròn & Hình không gian)",
                    summary: "",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Toán 9 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_4",
                    title: "1. Góc với đường tròn",
                    summary: "**Góc ở tâm:** Số đo của góc ở tâm bằng số đo của cung bị chắn.; **Góc nội tiếp:** Số đo của góc nội tiếp bằng nửa số đo của cung bị chắn. Góc nội tiếp chắn nửa đường tròn là góc vuông.",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Toán 9 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_5",
                    title: "2. Hình trụ - Hình nón - Hình cầu",
                    summary: "**Hình trụ:** Công thức tính Diện tích xung quanh ($S_{xq} = 2\\pi Rh$) và Thể tích ($V = \\pi R^2h$).; **Hình nón:** Công thức tính Diện tích xung quanh ($S_{xq} = \\pi Rl$) với $l$ là đường sinh và Thể tích ($V = \\frac{1}",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Toán 9 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_6",
                    title: "Tần suất và Xác suất nâng cao",
                    summary: "**Bảng tần suất và Tần suất tương đối:** Phân tích sâu hơn số liệu thống kê.; **Xác suất bằng sơ đồ hình cây:** Sử dụng sơ đồ hình cây để liệt kê toàn bộ các kết quả có thể xảy ra của một phép thử nghiệm nhiều giai đoạn,",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Toán 9 SGK Mới",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 10, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s1_1",
                    title: "Đại số và Đại số tổ hợp",
                    summary: "",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Toán 10 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_2",
                    title: "1. Mệnh đề và Tập hợp",
                    summary: "**Mệnh đề toán học:** Khái niệm mệnh đề, mệnh đề phủ định ($\\overline{P}$), mệnh đề kéo theo ($P \\Rightarrow Q$), mệnh đề tương đương ($P \\Leftrightarrow Q$). Mệnh đề chứa ký hiệu với mọi ($\\forall$) và tồn tại ($\\exists",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Thầy Phan Tiến • Mệnh Đề & Tập Hợp 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_3",
                    title: "2. Hàm số bậc hai và Đồ thị",
                    summary: "**Hàm số và đồ thị:** Khái niệm hàm số, tập xác định, tập giá trị. Sự biến thiên của hàm số (đồng biến, nghịch biến trên một khoảng).; **Hàm số bậc hai:** Hàm số dạng $y = ax^2 + bx + c$ ($a \\neq 0$).",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Toán 10 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_4",
                    title: "3. Hệ phương trình bậc nhất ba ẩn",
                    summary: "**Khái niệm:** Hệ phương trình gồm 3 phương trình bậc nhất có dạng tổng quát đối với 3 ẩn $x, y, z$.; **Phương pháp giải:** Phương pháp Gauss (biến đổi ma trận/hệ phương trình đưa về dạng tam giác bằng cách khử dần ẩn số",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Toán 10 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_5",
                    title: "Hình học trực quan và Vectơ",
                    summary: "",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "FvWfHa8QOiI",
                    channelName: "Tuyensinh247 • Vectơ Hình Học 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_6",
                    title: "1. Vectơ và các phép toán",
                    summary: "**Khái niệm vectơ:** Định nghĩa vectơ, vectơ-không ($\\vec{0}$), hai vectơ cùng phương, cùng hướng, độ dài của vectơ, hai vectơ bằng nhau.; **Các phép toán vectơ:**",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "FvWfHa8QOiI",
                    channelName: "Tuyensinh247 • Vectơ Hình Học 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_7",
                    title: "2. Tích vô hướng của hai vectơ và ứng dụng",
                    summary: "**Giá trị lượng giác của một góc từ $0^\\circ$ đến $180^\\circ$:** Định nghĩa $s\\text{in}, cos, tan, cot$ trên nửa đường tròn đơn vị. Hệ thức lượng cơ bản giữa các giá trị lượng giác.; **Tích vô hướng của hai vectơ:**",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "FvWfHa8QOiI",
                    channelName: "Tuyensinh247 • Vectơ Hình Học 10",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 10, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s2_1",
                    title: "Đại số và Đại số tổ hợp (tiếp theo)",
                    summary: "",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Toán 10 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_2",
                    title: "1. Dấu của tam thức bậc hai và Phương trình quy về bậc hai",
                    summary: "**Tam thức bậc hai:** Biểu thức dạng $f(x) = ax^2 + bx + c$ ($a \\neq 0$).; **Định lý về dấu của tam thức bậc hai:** Dựa vào biệt thức $\\Delta$ và hệ số $a$ để xét dấu của $f(x)$ trên tập số thực.",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Toán 10 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_3",
                    title: "2. Đại số tổ hợp",
                    summary: "**Quy tắc đếm cơ bản:** Quy tắc cộng (các hành động độc lập) và Quy tắc nhân (các hành động liên tiếp/công đoạn).; **Hoán vị, Chỉnh hợp, Tổ hợp:**",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Toán 10 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_4",
                    title: "Hình học tọa độ phẳng (Phương pháp tọa độ trong mặt phẳng)",
                    summary: "",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Toán 10 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_5",
                    title: "1. Đường thẳng trong mặt phẳng tọa độ",
                    summary: "**Vectơ chỉ phương (VTCP) và Vectơ pháp tuyến (VPTN)** của đường thẳng.; **Các dạng phương trình đường thẳng:**",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Toán 10 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_6",
                    title: "2. Đường tròn trong mặt phẳng tọa độ",
                    summary: "**Phương trình đường tròn:**; **Phương trình tiếp tuyến của đường tròn:** Viết phương trình tiếp tuyến của đường tròn tại một điểm cho trước thuộc đường tròn.",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Toán 10 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_7",
                    title: "3. Ba đường Conic",
                    summary: "**Đường Elip:** Phương trình chính tắc $\\frac{x^2}{a^2} + \\frac{y^2}{b^2} = 1$ ($a > b > 0$). Xác định các yếu tố: đỉnh, tiêu điểm, tiêu cự ($2c = 2\\sqrt{a^2 - b^2}$), trục lớn, trục nhỏ.; **Đường Hypebol:** Phương trình",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Toán 10 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_8",
                    title: "Thống kê và Xác suất sơ cấp",
                    summary: "**Tính xác suất theo định nghĩa cổ điển:** Sử dụng các công cụ của đại số tổ hợp (quy tắc đếm, hoán vị, chỉnh hợp, tổ hợp) để xác định số phần tử của không gian mẫu $\\Omega$ và số phần tử của biến cố $A$. Tính xác suất:",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Toán 10 SGK Mới",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 11, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s1_1",
                    title: "Hàm số lượng giác và Phương trình lượng giác",
                    summary: "",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "HASSGfzkLCc",
                    channelName: "Thầy Kenka • Hàm Số Lượng Giác 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_2",
                    title: "1. Góc lượng giác và Giá trị lượng giác",
                    summary: "**Góc lượng giác:** Khái niệm góc lượng giác, đơn vị đo góc (độ và radian), độ dài cung tròn. Khái niệm đường tròn lượng giác.; **Giá trị lượng giác:** Định nghĩa $\\sin \\alpha, \\cos \\alpha, \\tan \\alpha, \\cot \\alpha$. Dấu",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "HASSGfzkLCc",
                    channelName: "Thầy Kenka • Hàm Số Lượng Giác 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_3",
                    title: "2. Hàm số lượng giác và Phương trình lượng giác cơ bản",
                    summary: "**Hàm số lượng giác:** Tập xác định, tập giá trị, tính chẵn lẻ, tính tuần hoàn và đồ thị của các hàm số $y = \\sin x, y = \\cos x, y = \\tan x, y = \\cot x$.; **Phương trình lượng giác cơ bản:** Công thức nghiệm của các phươ",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "HASSGfzkLCc",
                    channelName: "Thầy Kenka • Hàm Số Lượng Giác 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_4",
                    title: "Dãy số, Cấp số cộng và Cấp số nhân",
                    summary: "**Dãy số:** Khái niệm dãy số (dãy số hữu hạn, dãy số vô hạn). Các cách cho một dãy số. Dãy số tăng, dãy số giảm, dãy số bị chặn.; **Cấp số cộng (CSC):**",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "ko6QriFQfEk",
                    channelName: "VietJack • Cấp Số Cộng & Nhân 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_5",
                    title: "Giới hạn và Hàm số liên tục",
                    summary: "**Giới hạn của dãy số:** Khái niệm giới hạn hữu hạn, giới hạn vô cực. Một số giới hạn đặc biệt. Định lý về giới hạn hữu hạn (tổng, hiệu, tích, thương). Tổng của một cấp số nhân lùi vô hạn ($S = \\frac{u_1}{1 - q}$ với $|q",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "60Kg5b_mSZQ",
                    channelName: "Tuyensinh247 • Giới Hạn & Đạo Hàm 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_6",
                    title: "Đường thẳng và Mặt phẳng trong không gian (Hình học không gian)",
                    summary: "**Đường thẳng và mặt phẳng:** Khái niệm điểm, đường thẳng, mặt phẳng trong không gian. Các hình thức xác định một mặt phẳng. Hình chóp và hình lăng trụ.; **Vị trí tương đối:**",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "FvWfHa8QOiI",
                    channelName: "Hocmai THPT • Hình Học Không Gian 11",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 11, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s2_1",
                    title: "Hàm số mũ, Hàm số lôgarit và Quan hệ vuông góc",
                    summary: "",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "FvWfHa8QOiI",
                    channelName: "Hocmai THPT • Hình Học Không Gian 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_2",
                    title: "1. Lũy thừa, Lôgarit và Hàm số lũy thừa, mũ, lôgarit",
                    summary: "**Phép tính lũy thừa:** Lũy thừa với số mũ nguyên, số mũ hữu tỉ và số mũ thực. Các tính chất của lũy thừa.; **Phép tính lôgarit:** Định nghĩa $\\log_a b$ ($a > 0, a \\neq 1, b > 0$). Các tính chất, công thức đổi cơ số. Lôg",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "60Kg5b_mSZQ",
                    channelName: "Thầy Phan Tiến • Toán 11 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_3",
                    title: "2. Quan hệ vuông góc trong không gian",
                    summary: "**Góc giữa hai đường thẳng** trong không gian. Hai đường thẳng vuông góc.; **Đường thẳng vuông góc với mặt phẳng:**",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "FvWfHa8QOiI",
                    channelName: "Hocmai THPT • Hình Học Không Gian 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_4",
                    title: "Đạo hàm",
                    summary: "**Khái niệm đạo hàm:** Định nghĩa đạo hàm tại một điểm (ý nghĩa hình học là hệ số góc của tiếp tuyến, ý nghĩa vật lý là vận tốc tức thời, gia tốc). Định nghĩa đạo hàm trên một khoảng.; **Các quy tắc tính đạo hàm:**",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "60Kg5b_mSZQ",
                    channelName: "Tuyensinh247 • Giới Hạn & Đạo Hàm 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_5",
                    title: "Một số yếu tố Xác suất (Nâng cao)",
                    summary: "**Biến cố giao và Biến cố xung khắc:** Khái niệm và quy tắc cộng xác suất cho hai biến cố xung khắc: $P(A \\cup B) = P(A) + P(B)$.; **Biến cố độc lập:** Khái niệm hai biến cố độc lập và quy tắc nhân xác suất cho hai biến",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "60Kg5b_mSZQ",
                    channelName: "Thầy Phan Tiến • Toán 11 SGK Mới",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 12, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s1_1",
                    title: "Giải tích (Ứng dụng đạo hàm và Khối tròn xoay)",
                    summary: "",
                    subject: "Toán",
                    grade: 12,
                    semester: 1,
                    videoId: "990wEB5yo2k",
                    channelName: "Thầy Đỗ Văn Đức • Toán 12 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_2",
                    title: "1. Ứng dụng đạo hàm để khảo sát và vẽ đồ thị hàm số",
                    summary: "**Tính đơn điệu của hàm số:** Mối liên hệ giữa dấu của đạo hàm bậc nhất $f'(x)$ và tính đồng biến, nghịch biến của hàm số trên một khoảng.; **Cực trị của hàm số:** Điều kiện cần và đủ để hàm số có điểm cực đại, điểm cực",
                    subject: "Toán",
                    grade: 12,
                    semester: 1,
                    videoId: "990wEB5yo2k",
                    channelName: "Thầy Đỗ Văn Đức • Khảo Sát Hàm Số 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_3",
                    title: "2. Khối tròn xoay",
                    summary: "**Nón tròn xoay, Trụ tròn xoay, Cầu tròn xoay:** Khái niệm mặt tròn xoay, khối tròn xoay.; **Ứng dụng thực tế:** Tính diện tích xung quanh, diện tích toàn phần và thể tích của các khối nón, khối trụ, khối cầu trong đời s",
                    subject: "Toán",
                    grade: 12,
                    semester: 1,
                    videoId: "990wEB5yo2k",
                    channelName: "Thầy Đỗ Văn Đức • Toán 12 SGK Mới",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_4",
                    title: "Hình học không gian (Thể tích khối đa diện)",
                    summary: "**Khái niệm về khối đa diện:** Định nghĩa hình đa diện, khối đa diện. Phép dời hình và sự bằng nhau giữa các khối đa diện. Phân chia và lắp ghép các khối đa diện. Khối đa diện đều (5 loại khối đa diện đều).; **Thể tích k",
                    subject: "Toán",
                    grade: 12,
                    semester: 1,
                    videoId: "phvpqxLNTUQ",
                    channelName: "Hocmai THPT • Phương Pháp Toạ Độ Oxyz 12",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("toán", 12, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s2_1",
                    title: "Giải tích (Nguyên hàm, Tích phân và Nguyên lý xác suất)",
                    summary: "",
                    subject: "Toán",
                    grade: 12,
                    semester: 2,
                    videoId: "j615s9znk4U",
                    channelName: "Thầy Nguyễn Phan Tiến • Nguyên Hàm Tích Phân 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_2",
                    title: "1. Nguyên hàm và Tích phân",
                    summary: "**Nguyên hàm:** Định nghĩa nguyên hàm, tính chất của nguyên hàm. Bảng nguyên hàm của các hàm số sơ cấp cơ bản. Các phương pháp tìm nguyên hàm: Phương pháp đổi biến số và phương pháp nguyên hàm từng phần.; **Tích phân:**",
                    subject: "Toán",
                    grade: 12,
                    semester: 2,
                    videoId: "j615s9znk4U",
                    channelName: "Thầy Nguyễn Phan Tiến • Nguyên Hàm Tích Phân 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_3",
                    title: "2. Xác suất có điều kiện và Công thức xác suất toàn phần",
                    summary: "**Xác suất có điều kiện:** Khái niệm và công thức tính xác suất của biến cố $A$ với điều kiện biến cố $B$ đã xảy ra: $P(A|B) = \\frac{P(A \\cap B)}{P(B)}$ ($P(B) > 0$).; **Công thức xác suất toàn phần:** Tính xác suất của",
                    subject: "Toán",
                    grade: 12,
                    semester: 2,
                    videoId: "w3vX-9m8Y1z",
                    channelName: "Tuyensinh247 • Xác Suất Thống Kê 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_4",
                    title: "Hình học tọa độ (Phương pháp tọa độ trong không gian Oxyz)",
                    summary: "**Hệ tọa độ trong không gian:** Định nghĩa hệ trục tọa độ Oxyz, tọa độ của điểm, tọa độ của vectơ. Biểu thức tọa độ của các phép toán vectơ (cộng, trừ, nhân với một số, tích vô hướng). Độ dài vectơ, khoảng cách giữa hai",
                    subject: "Toán",
                    grade: 12,
                    semester: 2,
                    videoId: "phvpqxLNTUQ",
                    channelName: "Hocmai THPT • Phương Pháp Toạ Độ Oxyz 12",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 6, 1), ("vật lý", 6, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s1_1",
                    title: "Các phép đo cơ bản",
                    summary: "**Đo chiều dài:**; **Đo khối lượng:**",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_2",
                    title: "Lực và Chuyển động",
                    summary: "**Khái niệm về lực:**; **Kết quả tác dụng của lực:** Lực tác dụng lên một vật có thể làm thay đổi tốc độ, thay đổi hướng chuyển động (biến đổi chuyển động) của vật đó, hoặc làm vật bị biến dạng (hoặc xảy ra cả hai cùng l",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_3",
                    title: "Các loại lực thường gặp và Khối lượng riêng",
                    summary: "**Trọng lực và Trọng lượng:**; **Lực đàn hồi:** Xuất hiện khi một vật bị biến dạng đàn hồi (như lò xo bị kéo dãn hoặc nén). Lực đàn hồi có xu hướng đưa vật trở lại hình dạng ban đầu. Độ dãn của lò xo treo thẳng đứng tỉ l",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 6, 2), ("vật lý", 6, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s2_1",
                    title: "Cơ năng và Sự truyền năng lượng",
                    summary: "**Khái niệm năng lượng:** Mọi chuyển động và biến đổi trong tự nhiên đều cần năng lượng. Đơn vị của năng lượng là Jun ($\\text{J}$).; **Các dạng năng lượng:**",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_2",
                    title: "Năng lượng hao phí và Năng lượng tái tạo",
                    summary: "**Năng lượng hao phí:** Trong mọi quá trình chuyển hóa và truyền năng lượng, luôn có một phần năng lượng bị hao phí (không phục vụ mục đích sử dụng ban đầu), phần lớn thường chuyển hóa thành nhiệt năng hoặc năng lượng âm",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_3",
                    title: "Sơ lược về Thiên văn học (Trái Đất và bầu trời)",
                    summary: "**Chuyển động nhìn thấy của Mặt Trời:** Mặt Trời mọc ở hướng Đông và lặn ở hướng Tây do Trái Đất tự quay quanh trục của nó từ Tây sang Đông.; **Hiện tượng Ngày và Đêm:** Do Trái Đất có hình cầu và tự quay quanh trục, nên",
                    subject: "Vật lí",
                    grade: 6,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 7, 1), ("vật lý", 7, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s1_1",
                    title: "Tốc độ chuyển động",
                    summary: "**Khái niệm tốc độ:** Là đại lượng cho biết mức độ nhanh hay chậm của chuyển động. Ký hiệu là $v$.; **Công thức tính tốc độ:**",
                    subject: "Vật lí",
                    grade: 7,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_2",
                    title: "Sóng âm (Âm thanh)",
                    summary: "**Sự tạo thành âm thanh:** Âm thanh được tạo ra bởi các vật dao động. Vật phát ra âm thanh gọi là nguồn âm (Ví dụ: dây đàn rung động, mặt trống rung lên khi gõ).; **Sự truyền âm:**",
                    subject: "Vật lí",
                    grade: 7,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 7, 2), ("vật lý", 7, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s2_1",
                    title: "Ánh sáng",
                    summary: "**Nguồn sáng và Vật sáng:** Nguồn sáng là vật tự nó phát ra ánh sáng (Ví dụ: Mặt Trời, ngọn nến đang cháy, bóng đèn đang bật). Vật sáng bao gồm nguồn sáng và những vật hắt lại ánh sáng chiếu vào nó (Ví dụ: Mặt Trăng, bàn",
                    subject: "Vật lí",
                    grade: 7,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_2",
                    title: "Từ học (Nam châm và Từ trường)",
                    summary: "**Nam châm:** Là những vật có đặc tính hút được các chất từ (sắt, thép, niken, coban...). Mỗi nam châm luôn có hai cực: Cực Bắc (N - màu đỏ) và Cực Nam (S - màu xanh/tối). Hai cực cùng tên thì đẩy nhau, khác tên thì hút",
                    subject: "Vật lí",
                    grade: 7,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 8, 1), ("vật lý", 8, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s1_1",
                    title: "Lực và Chuyển động nâng cao",
                    summary: "**Biểu diễn lực:** Lực là một đại lượng vectơ, được biểu diễn bằng một mũi tên có: Gốc (điểm đặt của lực), Phương và chiều (trùng với phương và chiều của lực), Độ dài (biểu diễn độ lớn của lực theo một tỉ xích cho trước)",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_2",
                    title: "Áp suất",
                    summary: "**Áp lực:** Là lực ép có phương vuông góc với mặt bị ép.; **Áp suất (chất rắn):** Là độ lớn của áp lực trên một đơn vị diện tích bị ép.",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_3",
                    title: "Lực đẩy Ác-si-mét và Sự nổi",
                    summary: "**Lực đẩy Ác-si-mét:** Một vật nhúng trong chất lỏng bị chất lỏng tác dụng một lực đẩy hướng thẳng đứng từ dưới lên trên.; **Sự nổi của các vật:** Nhúng một vật vào chất lỏng, gọi $P$ là trọng lượng của vật, $F_A$ là lực",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_4",
                    title: "Mômen lực và Đòn bẩy",
                    summary: "**Tác dụng làm quay của lực:** Khi lực tác dụng vào một vật có trục quay cố định mà giá của lực không đi qua trục quay thì sẽ làm vật quay.; **Mômen lực:** Là đại lượng đặc trưng cho tác dụng làm quay của lực.",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 8, 2), ("vật lý", 8, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s2_1",
                    title: "Điện học",
                    summary: "**Sự nhiễm điện:** Có thể làm nhiễm điện nhiều vật bằng cách cọ xát. Vật nhiễm điện (vật mang điện tích) có khả năng hút các vật khác hoặc phóng điện qua vật khác.; **Hai loại điện tích:** Có hai loại điện tích là điện t",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_2",
                    title: "Nhiệt học",
                    summary: "**Năng lượng nhiệt và Nhiệt độ:**; **Các hình thức truyền nhiệt:**",
                    subject: "Vật lí",
                    grade: 8,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 9, 1), ("vật lý", 9, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s1_1",
                    title: "Điện học",
                    summary: "**Định luật Ôm:** Cường độ dòng điện chạy qua một dây dẫn tỉ lệ thuận với hiệu điện thế đặt vào hai đầu dây và tỉ lệ nghịch với điện trở của dây.; **Đoạn mạch nối tiếp:**",
                    subject: "Vật lí",
                    grade: 9,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_2",
                    title: "Điện từ học",
                    summary: "**Lực từ tác dụng lên dây dẫn mang dòng điện:** Dây dẫn thẳng có dòng điện chạy qua đặt trong từ trường và không song song với các đường sức từ thì chịu tác dụng của lực từ.; **Hiện tượng cảm ứng điện từ:** Khi số đường",
                    subject: "Vật lí",
                    grade: 9,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 9, 2), ("vật lý", 9, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s2_1",
                    title: "Khúc xạ ánh sáng và Quang hình học",
                    summary: "**Hiện tượng khúc xạ ánh sáng:** Là hiện tượng tia sáng truyền từ môi trường trong suốt này sang môi trường trong suốt khác bị gãy khúc tại mặt phân cách giữa hai môi trường.; **Thấu kính hội tụ (TKHT):** Có phần rìa mỏn",
                    subject: "Vật lí",
                    grade: 9,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_2",
                    title: "Các dụng cụ quang học trực quan",
                    summary: "**Mắt về phương diện quang học:** Thể thủy tinh đóng vai trò như một thấu kính hội tụ (có thể co dãn để thay đổi tiêu cự - sự điều tiết), màng lưới (võng mạc) đóng vai trò như màn hứng ảnh. Ảnh của vật hiện rõ trên màng",
                    subject: "Vật lí",
                    grade: 9,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_3",
                    title: "Năng lượng và Phát triển bền vững",
                    summary: "**Định luật bảo toàn năng lượng trong các hiện tượng cơ - nhiệt - điện:** Năng lượng có thể chuyển hóa qua lại giữa các dạng: cơ năng, nhiệt năng, điện năng, hóa năng, quang năng. Tổng năng lượng của một hệ cô lập luôn đ",
                    subject: "Vật lí",
                    grade: 9,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "KHTN Vật Lí THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 10, 1), ("vật lý", 10, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s1_1",
                    title: "Mở đầu và Động học chất điểm",
                    summary: "**Sai số trong phép đo các đại lượng vật lí:** Khái niệm sai số hệ thống, sai số ngẫu nhiên. Cách viết kết quả đo đại lượng vật lí: $A = \\bar{A} \\pm \\Delta A$. Tính sai số tuyệt đối và sai số tỉ đối.; **Chuyển động thẳng",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "Thầy Vũ Ngọc Anh • Động Lực Học 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_2",
                    title: "Động lực học chất điểm",
                    summary: "**Tổng hợp và phân tích lực:** Tổng hợp lực là thay thế nhiều lực tác dụng đồng thời vào một vật bằng một lực duy nhất (lực tổng hợp) theo quy tắc hình bình hành. Phân tích lực là phép làm ngược lại.; **Ba định luật Niut",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 1,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "Thầy Vũ Ngọc Anh • Động Lực Học 10",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 10, 2), ("vật lý", 10, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s2_1",
                    title: "Khối lượng riêng, Áp suất chất lỏng và Độ biến dạng của vật rắn",
                    summary: "**Khối lượng riêng:** $D = \\frac{m}{V}$ (Đơn vị: $\\text{kg/m}^3$).; **Áp suất chất lỏng nâng cao:** Khái niệm áp suất tĩnh. $p = p_0 + \\rho \\cdot g \\cdot h$ (với $p_0$ là áp suất khí quyển, $\\rho$ là khối lượng riêng của",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "Thầy Vũ Ngọc Anh • Động Lực Học 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_2",
                    title: "Năng lượng, Công và Công suất",
                    summary: "**Công cơ học ($A$):** Đại lượng đại số đặc trưng cho tác dụng lực làm vật dịch chuyển.; **Công suất ($P$):** Đại lượng đặc trưng cho tốc độ sinh công.",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "Thầy Vũ Ngọc Anh • Động Lực Học 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_3",
                    title: "Động lượng",
                    summary: "**Động lượng ($\\vec{p}$):** Đại lượng vectơ đặc trưng cho sự truyền chuyển động của vật.; **Xung lượng của lực:** Độ biến thiên động lượng của một vật trong một khoảng thời gian bằng xung lượng của tổng hợp lực tác dụng",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "Thầy Vũ Ngọc Anh • Động Lực Học 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_4",
                    title: "Chuyển động tròn đều và Tĩnh học",
                    summary: "**Chuyển động tròn đều:** Chuyển động có quỹ đạo tròn và tốc độ không đổi.; **Cân bằng của vật rắn và Ngẫu lực:**",
                    subject: "Vật lí",
                    grade: 10,
                    semester: 2,
                    videoId: "Z-qX1s1H_k0",
                    channelName: "Thầy Vũ Ngọc Anh • Động Lực Học 10",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 11, 1), ("vật lý", 11, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s1_1",
                    title: "Dao động cơ",
                    summary: "",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_2",
                    title: "1. Dao động điều hòa",
                    summary: "**Khái niệm:** Dao động điều hòa là dao động trong đó li độ của vật là một hàm sin hoặc cosin của thời gian.; **Phương trình dao động điều hòa:**",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_3",
                    title: "2. Vận tốc và gia tốc trong dao động điều hòa",
                    summary: "**Phương trình vận tốc:** $v = x' = -\\omega A\\sin(\\omega t + \\phi) = \\omega A\\cos(\\omega t + \\phi + \\frac{\\pi}{2})$; **Phương trình gia tốc:** $a = v' = x'' = -\\omega^2 A\\cos(\\omega t + \\phi) = -\\omega^2 x$",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_4",
                    title: "3. Năng lượng trong dao động điều hòa",
                    summary: "**Động năng:** $W_đ = \\frac{1}{2}mv^2 = \\frac{1}{2}m\\omega^2 A^2\\sin^2(\\omega t + \\phi)$; **Thế năng:** $W_t = \\frac{1}{2}m\\omega^2 x^2 = \\frac{1}{2}m\\omega^2 A^2\\cos^2(\\omega t + \\phi)$",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_5",
                    title: "4. Dao động tắt dần, dao động cưỡng bức và Hiện tượng cộng hưởng",
                    summary: "**Dao động tắt dần:** Là dao động có biên độ và cơ năng giảm dần theo thời gian do tác dụng của lực cản môi trường. Lực cản càng lớn, dao động tắt dần càng nhanh.; **Dao động duy trì:** Bằng cách cung cấp thêm năng lượng",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_6",
                    title: "Sóng cơ và Sóng âm",
                    summary: "",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_7",
                    title: "1. Sóng cơ và các đặc trưng của sóng",
                    summary: "**Khái niệm:** Sóng cơ là sự lan truyền dao động cơ trong một môi trường vật chất theo thời gian. Các phần tử môi trường chỉ dao động tại chỗ chứ không truyền đi theo sóng.; **Phân loại:**",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_8",
                    title: "2. Giao thoa sóng và Sóng dừng",
                    summary: "**Giao thoa sóng:** Là hiện tượng hai sóng kết hợp (cùng tần số và có độ lệch pha không đổi theo thời gian) gặp nhau tạo nên các cực đại và cực tiểu giao thoa ổn định trong không gian.; **Sóng dừng:** Là sóng có các nút",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 1,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 11, 2), ("vật lý", 11, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s2_1",
                    title: "Điện trường",
                    summary: "",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_2",
                    title: "1. Lực tương tác tĩnh điện (Định luật Culông)",
                    summary: "Lực hút hoặc đẩy giữa hai điện tích điểm $q_1, q_2$ đặt trong chân không tỉ lệ thuận với tích độ lớn của hai điện tích và tỉ lệ nghịch với bình phương khoảng cách giữa chúng.",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_3",
                    title: "2. Cường độ điện trường",
                    summary: "**Khái niệm:** Là đại lượng đặc trưng cho điện trường về mặt tác dụng lực. $\\vec{E} = \\frac{\\vec{F}}{q}$ (Đơn vị: $\\text{V/m}$).; **Điện trường của một điện tích điểm $Q$:**",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_4",
                    title: "3. Công của lực điện, Điện thế và Hiệu điện thế",
                    summary: "**Công của lực điện:** Không phụ thuộc vào hình dạng đường đi mà chỉ phụ thuộc vào vị trí điểm đầu và điểm cuối của đường đi trong điện trường.; **Hiệu điện thế và liên hệ với cường độ điện trường đều:**",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_5",
                    title: "4. Tụ điện",
                    summary: "**Khái niệm:** Là một hệ hai vật dẫn đặt gần nhau và ngăn cách nhau bằng một lớp cách điện (điện môi), dùng để tích và phóng điện.; **Điện dung của tụ điện ($C$):** Đại lượng đặc trưng cho khả năng tích điện của tụ.",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_6",
                    title: "Dòng điện không đổi",
                    summary: "",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_7",
                    title: "1. Dòng điện và Cường độ dòng điện",
                    summary: "**Dòng điện:** Dòng dịch chuyển có hướng của các hạt mang điện (điện tích).; **Cường độ dòng điện ($I$):** Đại lượng đặc trưng cho tác dụng mạnh hay yếu của dòng điện, đo bằng điện lượng dịch chuyển qua tiết diện thẳng c",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_8",
                    title: "2. Định luật Ôm đối với toàn mạch",
                    summary: "Cường độ dòng điện chạy trong mạch điện kín tỉ lệ thuận với suất điện động của nguồn điện và tỉ lệ nghịch với điện trở toàn phần của mạch đó.; **Hiệu điện thế mạch ngoài (độ sụt áp mạch ngoài):** $U = I \\cdot R_{nguài} =",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_9",
                    title: "3. Công và Công suất của nguồn điện",
                    summary: "**Công của nguồn điện:** $A_{nguồn} = q \\cdot \\mathcal{E} = \\mathcal{E} \\cdot I \\cdot t$.; **Công suất của nguồn điện:** $P_{nguồn} = \\frac{A_{nguồn}}{t} = \\mathcal{E} \\cdot I$.",
                    subject: "Vật lí",
                    grade: 11,
                    semester: 2,
                    videoId: "kP1q8z_Y4x0",
                    channelName: "Thầy Chu Văn Biên • Điện Trường & Sóng 11",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 12, 1), ("vật lý", 12, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s1_1",
                    title: "Vật lí nhiệt",
                    summary: "",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_2",
                    title: "1. Mô hình động học phân tử và Cấu trúc của chất",
                    summary: "**Mô hình động học phân tử:** Các chất được cấu tạo từ các hạt riêng biệt gọi là phân tử. Các phân tử chuyển động hỗn loạn không ngừng (chuyển động nhiệt). Các phân tử tương tác với nhau bằng lực hút và lực đẩy phân tử.;",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_3",
                    title: "2. Định luật I nhiệt động lực học",
                    summary: "Độ biến thiên nội năng của hệ bằng tổng công và nhiệt lượng mà hệ nhận được.",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_4",
                    title: "3. Sự chuyển thể của các chất",
                    summary: "**Nhiệt nóng chảy riêng ($\\lambda$):** Nhiệt lượng cần cung cấp cho $1\\text{ kg}$ chất đó nóng chảy hoàn toàn ở nhiệt độ nóng chảy.; **Nhiệt hóa hơi riêng ($L$):** Nhiệt lượng cần cung cấp cho $1\\text{ kg}$ chất lỏng hóa",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_5",
                    title: "4. Thang nhiệt độ và Nhiệt dung riêng",
                    summary: "**Thang nhiệt độ Kelvin (K):** Thang nhiệt độ tuyệt đối, bắt đầu từ độ không tuyệt đối ($0\\text{ K} = -273,15^\\circ\\text{C}$).; **Nhiệt dung riêng ($c$):** Nhiệt lượng cần thiết để làm cho $1\\text{ kg}$ chất đó tăng thêm",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_6",
                    title: "Khí lí tưởng",
                    summary: "",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_7",
                    title: "1. Phương trình trạng thái của khí lí tưởng",
                    summary: "**Khí lí tưởng:** Là chất khí trong đó các phân tử được coi là các chất điểm và chỉ tương tác với nhau khi va chạm.; **Các định luật về khí lí tưởng:**",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_8",
                    title: "2. Áp suất khí và Động năng phân tử",
                    summary: "Áp suất khí lí tưởng tác dụng lên thành bình được giải thích do sự va chạm của các phân tử khí lên thành bình.; Công thức áp suất từ mô hình động học phân tử: $P = \\frac{1}{3}\\mu \\cdot m_0 \\cdot \\overline{v^2}$ (với $\\mu",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 1,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("vật lí", 12, 2), ("vật lý", 12, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s2_1",
                    title: "Từ trường",
                    summary: "",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_2",
                    title: "1. Lực từ tác dụng lên dây dẫn thẳng mang dòng điện",
                    summary: "Lực từ $\\vec{F}$ tác dụng lên một đoạn dây dẫn thẳng có chiều dài $L$, mang dòng điện $I$, đặt trong từ trường đều có cảm ứng từ $\\vec{B}$.; **Độ lớn (Định luật Ampere):**",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_3",
                    title: "2. Cảm ứng từ của dòng điện có hình dạng đặc biệt",
                    summary: "**Dòng điện thẳng dài vô hạn:** $B = 2 \\cdot 10^{-7} \\cdot \\frac{I}{r}$ ($r$ là khoảng cách từ dây dẫn đến điểm xét).; **Dòng điện tròn (tại tâm):** $B = 2\\pi \\cdot 10^{-7} \\cdot N \\cdot \\frac{I}{R}$ ($N$ là số vòng dây,",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_4",
                    title: "3. Lực Lorentz",
                    summary: "Lực Lorentz là lực do từ trường tác dụng lên một hạt mang điện tích $q$ chuyển động với vận tốc $\\vec{v}$.",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_5",
                    title: "Vật lí hạt nhân",
                    summary: "",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_6",
                    title: "1. Cấu tạo hạt nhân và Độ hụt khối",
                    summary: "**Cấu tạo hạt nhân:** Kí hiệu hạt nhân là $_Z^A\\text{X}$.; **Độ hụt khối ($\\Delta m$):** Khối lượng của một hạt nhân luôn nhỏ hơn tổng khối lượng của các nucleon riêng rẽ cấu tạo nên nó.",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_7",
                    title: "2. Phóng xạ và Định luật phóng xạ",
                    summary: "**Hiện tượng phóng xạ:** Là quá trình phân rã tự phát của một hạt nhân không bền vững thành hạt nhân khác, đồng thời phát ra các tia phóng xạ ($\\alpha, \\beta^-, \\beta^+, \\gamma$). Quá trình này hoàn toàn tự phát và không",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_8",
                    title: "3. Phản ứng hạt nhân, Phân hạch và Nhiệt hạch",
                    summary: "**Phản ứng hạt nhân:** Là mọi quá trình dẫn đến sự biến đổi của các hạt nhân (gồm phản ứng tự phát như phóng xạ và phản ứng kích thích do các hạt va chạm).; **Các định luật bảo toàn trong phản ứng hạt nhân:**",
                    subject: "Vật lí",
                    grade: 12,
                    semester: 2,
                    videoId: "4TXYs2e_Q0o",
                    channelName: "VNA Physics • Dao Động & Sóng 12",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 6, 1), ("hóa", 6, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s1_1",
                    title: "Chất và các thể của chất",
                    summary: "",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_2",
                    title: "1. Sự đa dạng của chất",
                    summary: "**Vật thể tự nhiên:** Là những vật thể có sẵn trong tự nhiên (Ví dụ: sông, suối, cây cối, con người, đất đá).; **Vật thể nhân tạo:** Là những vật thể do con người tạo ra để phục vụ cuộc sống (Ví dụ: bàn ghế, quần áo, sác",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_3",
                    title: "2. Ba thể cơ bản của chất và đặc điểm của chúng",
                    summary: "**Thể rắn:** Các hạt liên kết chặt chẽ, có hình dạng và thể tích xác định, rất khó bị nén.; **Thể lỏng:** Các hạt liên kết lỏng lẻo hơn, có thể tích xác định nhưng hình dạng phụ thuộc vào vật chứa, khó bị nén.",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_4",
                    title: "3. Tính chất của chất",
                    summary: "**Tính chất vật lí:** Là những tính chất có thể quan sát hoặc đo đạc được mà không làm biến đổi chất này thành chất khác (Ví dụ: thể, màu sắc, mùi vị, tính tan, nhiệt độ nóng chảy, nhiệt độ sôi, tính dẫn điện, dẫn nhiệt)",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_5",
                    title: "4. Sự chuyển thể của chất",
                    summary: "**Sự nóng chảy:** Chất chuyển từ thể rắn sang thể lỏng.; **Sự đông đặc:** Chất chuyển từ thể lỏng sang thể rắn.",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_6",
                    title: "Oxygen và Không khí",
                    summary: "",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_7",
                    title: "1. Oxygen (Oxi)",
                    summary: "**Tính chất vật lí:** Là chất khí, không màu, không mùi, không vị, ít tan trong nước, nặng hơn không khí.; **Tầm quan trọng:** Oxygen duy trì sự sống (cần cho quá trình hô hấp của con người, động vật, thực vật) và duy tr",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_8",
                    title: "2. Không khí và Bảo vệ môi trường không khí",
                    summary: "**Thành phần của không khí:** Không khí là một hỗn hợp khí gồm có:; **Ô nhiễm không khí:** Là sự thay đổi thành phần của không khí do khói, bụi, khí độc (như $SO_2, CO, NO_x$).",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 6, 2), ("hóa", 6, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s2_1",
                    title: "Một số vật liệu, nhiên liệu, nguyên liệu, lương thực - thực phẩm thông dụng",
                    summary: "",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_2",
                    title: "1. Một số vật liệu thông dụng",
                    summary: "**Khái niệm:** Vật liệu là chất hoặc hỗn hợp các chất được con người sử dụng làm nguyên liệu đầu vào để chế tạo ra vật thể phục vụ đời sống, sản xuất (Ví dụ: nhựa, kim loại, cao su, thủy tinh, gốm).; **Tính chất và ứng d",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_3",
                    title: "2. Một số nhiên liệu thông dụng",
                    summary: "**Khái niệm:** Nhiên liệu (chất đốt) là những chất khi cháy đều tỏa nhiệt và phát sáng (Ví dụ: than đá, xăng, dầu, gas, củi, cồn).; **Phân loại:** Nhiên liệu hóa thạch (than đá, dầu mỏ), nhiên liệu tái tạo (củi, sinh khố",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_4",
                    title: "3. Một số nguyên liệu và lương thực - thực phẩm thông dụng",
                    summary: "**Nguyên liệu:** Là vật liệu tự nhiên (chưa qua xử lý) cần được chuyển hóa trong sản xuất để tạo ra sản phẩm (Ví dụ: quặng sắt để luyện gang thép, đá vôi để sản xuất xi măng).; **Lương thực, thực phẩm:** Cung cấp các chấ",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_5",
                    title: "Hỗn hợp và các phương pháp tách chất",
                    summary: "",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_6",
                    title: "1. Hỗn hợp và Chất tinh khiết",
                    summary: "**Chất tinh khiết (chất nguyên chất):** Được tạo ra từ một chất duy nhất, có những tính chất vật lí và hóa học xác định, không thay đổi.; **Hỗn hợp:** Được tạo ra khi hai hay nhiều chất trộn lẫn với nhau. Tính chất của h",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_7",
                    title: "2. Dung dịch, Huyền phù và Nhũ tương",
                    summary: "**Dung dịch:** Là hỗn hợp đồng nhất giữa chất tan và dung môi.; **Huyền phù:** Là hỗn hợp không đồng nhất gồm các hạt chất rắn lơ lửng trong chất lỏng (Ví dụ: nước sông phù sa, nước bột sắn dây). Để yên một thời gian chấ",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_8",
                    title: "3. Các phương pháp vật lí đơn giản để tách chất ra khỏi hỗn hợp",
                    summary: "**Phương pháp lọc:** Dùng để tách chất rắn không tan ra khỏi hỗn hợp lỏng (Ví dụ: tách cát ra khỏi nước).; **Phương pháp cô cạn:** Dùng để tách chất rắn tan được ra khỏi dung dịch bằng cách đun nóng cho dung môi bay hơi",
                    subject: "Hóa học",
                    grade: 6,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 7, 1), ("hóa", 7, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s1_1",
                    title: "Nguyên tử",
                    summary: "",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_2",
                    title: "1. Khái niệm và cấu tạo nguyên tử",
                    summary: "**Khái niệm:** Nguyên tử là hạt cực kỳ nhỏ bé, trung hòa về điện, cấu tạo nên các chất.; **Cấu tạo nguyên tử:** Gồm 2 phần chính:",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_3",
                    title: "2. Nguyên tố hóa học",
                    summary: "**Định nghĩa:** Nguyên tố hóa học là tập hợp những nguyên tử có cùng số proton trong hạt nhân. Các nguyên tử của cùng một nguyên tố hóa học đều có tính chất hóa học giống nhau.; **Kí hiệu hóa học:** Mỗi nguyên tố được bi",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_4",
                    title: "Sơ lược về bảng tuần hoàn các nguyên tố hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_5",
                    title: "1. Nguyên tắc sắp xếp",
                    summary: "Các nguyên tố hóa học được sắp xếp theo chiều tăng dần của điện tích hạt nhân nguyên tử (số proton).; Các nguyên tố có cùng số lớp electron trong nguyên tử được xếp thành một hàng (chu kì).",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_6",
                    title: "2. Cấu tạo bảng tuần hoàn",
                    summary: "**Ô nguyên tố:** Cho biết số hiệu nguyên tử (bằng số $p$), kí hiệu hóa học, tên nguyên tố và khối lượng nguyên tử.; **Chu kì:** Là dãy các nguyên tố mà nguyên tử của chúng có cùng số lớp electron, xếp theo chiều tăng dần",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_7",
                    title: "3. Các nhóm nguyên tố chính trong bảng tuần hoàn",
                    summary: "**Kim loại:** Chiếm đa số trong bảng tuần hoàn (ở góc dưới bên trái).; **Phi kim:** Chiếm số lượng ít hơn (ở góc trên bên phải).",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 7, 2), ("hóa", 7, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s2_1",
                    title: "Phân tử - Đơn chất và Hợp chất",
                    summary: "",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_2",
                    title: "1. Đơn chất và Hợp chất",
                    summary: "**Đơn chất:** Là những chất được tạo nên từ một nguyên tố hóa học (Ví dụ: Khí oxygen $\\text{O}_2$ tạo từ nguyên tố $\\text{O}$; lá đồng $\\text{Cu}$ tạo từ nguyên tố $\\text{Cu}$).; **Hợp chất:** Là những chất được tạo nên",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_3",
                    title: "2. Phân tử và Khối lượng phân tử",
                    summary: "**Phân tử:** Là hạt đại diện cho chất, gồm một số nguyên tử liên kết với nhau bằng liên kết hóa học và thể hiện đầy đủ tính chất hóa học của chất.; **Khối lượng phân tử:** Bằng tổng khối lượng các nguyên tử có trong phân",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_4",
                    title: "Giới thiệu về liên kết hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_5",
                    title: "1. Quy tắc octet (quy tắc 8 electron)",
                    summary: "Nguyên tử của các nguyên tố có xu hướng nhường, nhận hoặc dùng chung electron để đạt được lớp electron ngoài cùng bền vững giống như khí hiếm (thường là 8 electron, riêng Hydrogen là 2 electron).",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_6",
                    title: "2. Liên kết ion",
                    summary: "Là liên kết được hình thành bởi lực hút tĩnh điện giữa các ion mang điện tích trái dấu (thường xảy ra giữa nguyên tử kim loại điển hình và phi kim điển hình).; *Cơ chế:* Nguyên tử kim loại nhường electron biến thành ion",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_7",
                    title: "3. Liên kết cộng hóa trị",
                    summary: "Là liên kết được hình thành giữa hai nguyên tử bằng một hoặc nhiều cặp electron dùng chung (thường xảy ra giữa các nguyên tử phi kim với nhau).; *Phân loại:*",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_8",
                    title: "Hóa trị và Công thức hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_9",
                    title: "1. Công thức hóa học",
                    summary: "Công thức hóa học dùng để biểu diễn chữ viết của chất.; **Dạng tổng quát của công thức hóa học:** $\\text{A}_x\\text{B}_y$ hoặc $\\text{A}_x\\text{B}_y\\text{C}_z$.",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_10",
                    title: "2. Hóa trị và Quy tắc hóa trị",
                    summary: "**Hóa trị:** Là con số biểu thị khả năng liên kết của nguyên tử nguyên tố này với nguyên tử nguyên tố khác. Quy ước chọn hóa trị của $\\text{H}$ làm đơn vị ($\\text{I}$) và hóa trị của $\\text{O}$ là $\\text{II}$.; **Quy tắc",
                    subject: "Hóa học",
                    grade: 7,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 8, 1), ("hóa", 8, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s1_1",
                    title: "Phản ứng hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_2",
                    title: "1. Biến đổi vật lí và biến đổi hóa học",
                    summary: "**Biến đổi vật lí:** Là hiện tượng chất có sự thay đổi về trạng thái, hình dạng, kích thước... nhưng vẫn giữ nguyên là chất ban đầu, không có chất mới tạo thành (Ví dụ: nước đá tan thành nước lỏng, hòa tan đường vào nước",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_3",
                    title: "2. Phản ứng hóa học",
                    summary: "**Khái niệm:** Phản ứng hóa học là quá trình biến đổi chất này thành chất khác.; **Diễn biến của phản ứng hóa học:** Trong phản ứng hóa học, chỉ có liên kết giữa các nguyên tử thay đổi làm cho phân tử này biến đổi thành",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_4",
                    title: "3. Định luật bảo toàn khối lượng và Phương trình hóa học",
                    summary: "**Định luật bảo toàn khối lượng:** Trong một phản ứng hóa học, tổng khối lượng của các chất sản phẩm bằng tổng khối lượng của các chất phản ứng.; **Phương trình hóa học:** Dùng để biểu diễn ngắn gọn phản ứng hóa học bằng",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_5",
                    title: "Mol và Tính toán hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_6",
                    title: "1. Khái niệm về Mol",
                    summary: "**Mol:** Là lượng chất có chứa $6,022 \\cdot 10^{23}$ hạt vi mô (nguyên tử hoặc phân tử) của chất đó. Con số $N = 6,022 \\cdot 10^{23}$ gọi là hằng số Avogadro.; **Khối lượng mol ($M$):** Là khối lượng tính bằng gam của 1",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_7",
                    title: "2. Các công thức tính toán cốt lõi",
                    summary: "**Tính số mol ($n$):**; **Tỉ khối của chất khí ($d$):** Cho biết khí này nặng hay nhẹ hơn khí kia bao nhiêu lần.",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_8",
                    title: "3. Nồng độ dung dịch",
                    summary: "**Nồng độ phần trăm ($C\\%$):** Cho biết số gam chất tan có trong 100 gam dung dịch.; **Nồng độ mol ($C_M$):** Cho biết số mol chất tan có trong 1 lít dung dịch.",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 8, 2), ("hóa", 8, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s2_1",
                    title: "Tốc độ phản ứng và Chất xúc tác",
                    summary: "**Tốc độ phản ứng:** Là đại lượng đặc trưng cho mức độ nhanh hay chậm của một phản ứng hóa học.; **Các yếu tố ảnh hưởng đến tốc độ phản ứng:** Nhiệt độ (tăng nhiệt độ làm tăng tốc độ), nồng độ (nồng độ chất phản ứng càng",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_2",
                    title: "Các hợp chất vô cơ thông dụng",
                    summary: "",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_3",
                    title: "1. Oxide (Oxit)",
                    summary: "**Khái niệm:** Là hợp chất gồm hai nguyên tố, trong đó có một nguyên tố là Oxygen.; **Phân loại:**",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_4",
                    title: "2. Acid (Axit)",
                    summary: "**Khái niệm:** Là hợp chất mà phân tử gồm có một hay nhiều nguyên tử Hydrogen liên kết với gốc acid. Khi tan trong nước, acid tạo ra ion $H^+$.; **Công thức tổng quát:** $H_n X$ ($X$ là gốc acid). Ví dụ: $HCl, H_2SO_4, H",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_5",
                    title: "3. Base (Bazơ)",
                    summary: "**Khái niệm:** Là hợp chất mà phân tử gồm có một nguyên tử kim loại liên kết với một hay nhiều nhóm hydroxide ($-OH$). Khi tan trong nước, base tạo ra ion $OH^-$.; **Công thức tổng quát:** $M(OH)_n$ ($M$ là kim loại).",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_6",
                    title: "4. Thang pH và Muối",
                    summary: "**Thang pH:** Dùng để biểu thị độ acid hoặc độ base của một dung dịch (thường từ 1 đến 14).; **Muối:** Là hợp chất mà phân tử gồm có nguyên tử kim loại (hoặc ion ammonium $NH_4^+$) liên kết với gốc acid (Ví dụ: $NaCl, Cu",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_7",
                    title: "Phân bón hóa học",
                    summary: "**Khái niệm:** Là những hóa chất có chứa các nguyên tố dinh dưỡng thiết yếu, được bón cho cây trồng nhằm nâng cao năng suất.; **Các loại phân bón chính:**",
                    subject: "Hóa học",
                    grade: 8,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 9, 1), ("hóa", 9, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s1_1",
                    title: "Tính chất hóa học của các hợp chất vô cơ (Nâng cao)",
                    summary: "**Mối quan hệ giữa các loại hợp chất vô cơ:** Sự chuyển hóa qua lại giữa Oxide $\\leftrightarrow$ Acid $\\leftrightarrow$ Base $\\leftrightarrow$ Muối thông qua các chuỗi phản ứng hóa học.; **Điều kiện xảy ra phản ứng trao",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_2",
                    title: "Kim loại",
                    summary: "",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_3",
                    title: "1. Tính chất vật lí và hóa học của kim loại",
                    summary: "**Tính chất vật lí:** Có tính dẻo, tính dẫn điện, tính dẫn nhiệt và có ánh kim.; **Tính chất hóa học:**",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_4",
                    title: "2. Dãy hoạt động hóa học của kim loại",
                    summary: "**K, Na, Ca, Mg, Al, Zn, Fe, Ni, Sn, Pb, (H), Cu, Hg, Ag, Pt, Au**; **Ý nghĩa của dãy hoạt động:**",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_5",
                    title: "3. Gang và Thép (Hợp kim của sắt)",
                    summary: "**Gang:** Là hợp kim của Iron ($Fe$) với Carbon ($C$), trong đó hàm lượng Carbon chiếm từ $2 - 5\\%$, cùng một số nguyên tố khác.; **Thép:** Là hợp kim của Iron ($Fe$) với Carbon ($C$), trong đó hàm lượng Carbon dưới $2\\%",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_6",
                    title: "Phi kim",
                    summary: "",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_7",
                    title: "1. Tính chất của phi kim",
                    summary: "**Tính chất vật lí:** Có thể ở cả 3 thể (rắn như $C, P, S$; lỏng như $Br_2$; khí như $O_2, Cl_2, N_2$), phần lớn không dẫn điện, dẫn nhiệt kém.; **Tính chất hóa học:** Tác dụng với kim loại tạo thành muối hoặc oxide; tác",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_8",
                    title: "2. Sơ lược về Sắt, Nhôm và một số phi kim quan trọng",
                    summary: "**Aluminum ($Al$):** Có tính lưỡng tính đặc biệt, cấu tạo lớp oxide bảo vệ bền vững, tan được trong dung dịch kiềm giải phóng $H_2$.; **Iron ($Fe$):** Có nhiều hóa trị ($\\text{II}$ và $\\text{III}$) tùy thuộc vào chất phả",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 9, 2), ("hóa", 9, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s2_1",
                    title: "Khái niệm về hợp chất hữu cơ và Hydrocarbon",
                    summary: "",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_2",
                    title: "1. Khái niệm về hợp chất hữu cơ",
                    summary: "**Định nghĩa:** Hợp chất hữu cơ là hợp chất của Carbon (trừ các oxide của carbon như $CO, CO_2$, muối carbonate, các carbide kim loại như $CaC_2$).; **Phân loại:** Gồm 2 loại chính:",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_3",
                    title: "2. Methane ($CH_4$)",
                    summary: "Là thành phần chính trong khí metan, khí thiên nhiên, khí mỏ dầu, khí bùn ao. Trong phân tử chỉ có các liên kết đơn.; **Tính chất hóa học:** Tham gia phản ứng cháy tỏa nhiều nhiệt và **phản ứng thế** với Chlorine khi có",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_4",
                    title: "3. Ethylene ($C_2H_4$)",
                    summary: "Trong phân tử có chứa một **liên kết đôi** ($C=C$). Liên kết đôi này có một liên kết kém bền, dễ bị đứt ra trong các phản ứng hóa học.; **Tính chất hóa học:** Tham gia phản ứng cháy, **phản ứng cộng** làm mất màu dung dị",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_5",
                    title: "4. Acetylene ($C_2H_2$)",
                    summary: "Trong phân tử có chứa một **liên kết ba** ($C \\equiv C$), trong đó có hai liên kết kém bền dễ bị đứt lần lượt trong các phản ứng.; **Tính chất hóa học:** Tham gia phản ứng cháy (ngọn lửa đèn xì acetylen có nhiệt độ rất c",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_6",
                    title: "Dẫn xuất của Hydrocarbon",
                    summary: "",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_7",
                    title: "1. Ethanoic acid (Axit axetic - $CH_3COOH$)",
                    summary: "Là thành phần chính của giấm ăn (nồng độ từ $2 - 5\\%$). Trong phân tử có nhóm carboxyl ($-COOH$) gây ra tính acid.; **Tính chất hóa học:**",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_8",
                    title: "2. Rượu etylic (Ethanol - $C_2H_5OH$)",
                    summary: "Là chất lỏng, phân tử chứa nhóm hydroxyl ($-OH$) quyết định tính chất đặc trưng. Khái niệm độ rượu là số ml rượu nguyên chất có trong 100 ml hỗn hợp rượu với nước.; **Tính chất hóa học:** Phản ứng cháy tỏa nhiệt, phản ứn",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_9",
                    title: "3. Chất béo, Glucose và Sucrose",
                    summary: "**Chất béo:** Là hợp chất este phức tạp, thành phần chính của dầu thực vật và mỡ động vật. Tham gia phản ứng thủy phân trong môi trường acid hoặc môi trường kiềm (gọi là **phản ứng xà phòng hóa** tạo ra xà phòng và glyce",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_10",
                    title: "4. Tinh bột, Cellulose và Protein",
                    summary: "**Tinh bột và Cellulose:** Là các polymer tự nhiên có công thức chung là $(C_6H_{10}O_5)_n$. Tinh bột có nhiều trong các loại hạt ngũ cốc, củ; Cellulose có nhiều trong sợi bông, tre, gỗ. Tinh bột có phản ứng đặc trưng là",
                    subject: "Hóa học",
                    grade: 9,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "KHTN Hóa Học THCS",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 10, 1), ("hóa", 10, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s1_1",
                    title: "Nhập môn Hóa học và Cấu tạo nguyên tử",
                    summary: "",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_2",
                    title: "1. Nhập môn Hóa học",
                    summary: "**Đối tượng nghiên cứu của Hóa học:** Nghiên cứu về thành phần, cấu trúc, tính chất và sự biến đổi của chất, cùng với năng lượng đi kèm các quá trình biến đổi đó.; **Phương pháp học tập và nghiên cứu Hóa học:** Phương ph",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_3",
                    title: "2. Cấu tạo hạt nhân và Vỏ nguyên tử",
                    summary: "**Thành phần cấu tạo nguyên tử:**; **Hạt nhân nguyên tử:**",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_4",
                    title: "3. Cấu trúc lớp vỏ electron của nguyên tử",
                    summary: "**Chuyển động của electron trong nguyên tử:** Các electron chuyển động rất nhanh trong khu vực xung quanh hạt nhân không theo những quỹ đạo xác định, tạo nên **vỏ nguyên tử (đám mây electron)**. Khái niệm orbital nguyên",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_5",
                    title: "Bảng tuần hoàn các nguyên tố hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_6",
                    title: "1. Cấu tạo của Bảng tuần hoàn",
                    summary: "**Nguyên tắc sắp xếp:** Theo chiều tăng dần của điện tích hạt nhân; Các nguyên tố có cùng số lớp electron được xếp vào một hàng; Các nguyên tố có cùng số electron hóa trị được xếp vào một cột.; **Cấu trúc:**",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_7",
                    title: "2. Xu hướng biến đổi tính chất trong Bảng tuần hoàn",
                    summary: "**Trong một chu kì (từ trái sang phải theo chiều tăng $Z$):**; **Trong một nhóm A (từ trên xuống dưới theo chiều tăng $Z$):**",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 10, 2), ("hóa", 10, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s2_1",
                    title: "Liên kết hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_2",
                    title: "1. Liên kết ion và Liên kết cộng hóa trị",
                    summary: "**Quy tắc octet:** Các nguyên tử có xu hướng nhường, nhận hoặc góp chung electron hóa trị để đạt cấu hình electron bền vững của khí hiếm gần nhất với 8 electron lớp ngoài cùng (hoặc 2 electron đối với Helium).; **Liên kế",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_3",
                    title: "2. Tương tác van der Waals và Liên kết hydrogen",
                    summary: "**Liên kết hydrogen:** Bản chất là lực hút tĩnh điện yếu giữa nguyên tử $\\text{H}$ đã liên kết với một nguyên tử có độ âm điện lớn (như $\\text{F, O, N}$) có cặp electron hóa trị chưa tham gia liên kết của nguyên tử có độ",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_4",
                    title: "Phản ứng Oxi hóa - Khử và Năng lượng hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_5",
                    title: "1. Phản ứng Oxi hóa - Khử",
                    summary: "**Số oxi hóa (SOH):** Là điện tích giả định của nguyên tử trong phân tử nếu giả định rằng tất cả các liên kết trong phân tử đều là liên kết ion. Quy tắc xác định số oxi hóa (đơn chất = 0; tổng SOH trong phân tử = 0; SOH",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_6",
                    title: "2. Năng lượng hóa học (Nhiệt hóa học)",
                    summary: "**Phản ứng tỏa nhiệt và Phản ứng thu nhiệt:**; **Biến thiên enthalpy tiêu chuẩn của phản ứng ($\\Delta_{r}H^\\circ_{298}$):** Là nhiệt tỏa ra hay thu vào của phản ứng hóa học được đo ở điều kiện chuẩn (áp suất $1\\text{ bar",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_7",
                    title: "Tốc độ phản ứng hóa học và Khái quát về nhóm Halogen",
                    summary: "",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_8",
                    title: "1. Tốc độ phản ứng hóa học",
                    summary: "**Khái niệm:** Là đại lượng đặc trưng cho mức độ nhanh hay chậm của một phản ứng hóa học, được xác định bằng sự biến thiên nồng độ của một trong các chất phản ứng hoặc chất sản phẩm trong một đơn vị thời gian.; **Các yếu",
                    subject: "Hóa học",
                    grade: 10,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Học Hóa Official • Cấu Tạo Nguyên Tử 10",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 11, 1), ("hóa", 11, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s1_1",
                    title: "Cân bằng hóa học",
                    summary: "",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_2",
                    title: "1. Khái niệm về phản ứng thuận nghịch và trạng thái cân bằng",
                    summary: "**Phản ứng một chiều:** Phản ứng chỉ xảy ra theo một chiều từ chất phản ứng tạo thành sản phẩm.; **Phản ứng thuận nghịch:** Phản ứng xảy ra theo hai chiều trái ngược nhau trong cùng một điều kiện. Chiều từ trái sang phải",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_3",
                    title: "2. Sự chuyển dịch cân bằng hóa học (Nguyên lí Le Chatelier)",
                    summary: "**Nguyên lí Le Chatelier:** Khi một hệ đang ở trạng thái cân bằng chịu một tác động từ bên ngoài làm thay đổi nồng độ, nhiệt độ hoặc áp suất thì cân bằng sẽ chuyển dịch theo chiều làm giảm tác động bên ngoài đó.; **Các y",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_4",
                    title: "Cân bằng trong dung dịch nước",
                    summary: "",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_5",
                    title: "1. Sự điện li",
                    summary: "**Khái niệm:** Sự điện li là quá trình phân rã các chất thành ion khi tan trong nước hoặc ở trạng thái nóng chảy. Chất điện li gồm acid, base và muối.; **Chất điện li mạnh:** Khi tan trong nước, các phân tử hòa tan đều p",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_6",
                    title: "2. Thuyết Acid - Base của Brønsted - Lowry",
                    summary: "**Acid:** Là chất có khả năng nhường proton (H+).; **Base:** Là chất có khả năng nhận proton (H+).",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_7",
                    title: "3. Khái niệm về pH và Ý nghĩa của pH trong thực tiễn",
                    summary: "**Tích số ion của nước (Kw):** Ở 25°C, Kw = [H+] * [OH-] = 10^-14.; **Công thức tính pH:** pH = -log[H+] -> [H+] = 10^-pH.",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_8",
                    title: "Nitrogen và Sulfur",
                    summary: "",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_9",
                    title: "1. Đơn chất Nitrogen (N2) và Ammonia (NH3)",
                    summary: "**Nitrogen (N2):** Ở nhiệt độ thường khá trơ về mặt hóa học do có liên kết ba bền vững (N≡N). Ở nhiệt độ cao, thể hiện cả tính khử (tác dụng với O2) và tính oxi hóa (tác dụng với kim loại hoạt động mạnh, H2).; **Ammonia",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_10",
                    title: "2. Nitric acid (HNO3) và Hiện tượng phú dưỡng",
                    summary: "**Nitric acid (HNO3):** Là một acid mạnh và là một chất oxi hóa cực kỳ mạnh. Tác dụng với hầu hết kim loại (trừ Pt, Au) tạo thành muối nitrate, nước và các sản phẩm khử của N (như NO2, NO, N2O, N2, NH4NO3) tùy thuộc vào",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_11",
                    title: "3. Sulfur (S), Sulfur dioxide (SO2) và Sulfuric acid (H2SO4)",
                    summary: "**Sulfur (S):** Có các dạng thù hình (tà phương, đơn tà). Thể hiện tính oxi hóa (tác dụng với kim loại, H2) và tính khử (tác dụng với phi kim mạnh hơn như O2, F2).; **Sulfur dioxide (SO2):** Oxide acid độc, khí không màu",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 1,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 11, 2), ("hóa", 11, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s2_1",
                    title: "Đại cương về Hóa học hữu cơ",
                    summary: "",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_2",
                    title: "1. Phân loại và Phương pháp tách biệt hợp chất hữu cơ",
                    summary: "**Đặc điểm chung:** Liên kết trong phân tử chủ yếu là liên kết cộng hóa trị. Các hợp chất hữu cơ thường kém bền nhiệt, dễ cháy, phản ứng hóa học xảy ra chậm, không hoàn toàn và theo nhiều hướng (tạo hỗn hợp sản phẩm).; *",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_3",
                    title: "2. Công thức phân tử và Cấu tạo hóa học",
                    summary: "**Công thức đơn giản nhất (CTĐGN):** Biểu thị tỉ lệ tối giản về số nguyên tử của các nguyên tố trong phân tử.; **Công thức phân tử (CTPT):** Biểu thị số lượng nguyên tử thực tế của mỗi nguyên tố trong phân tử. CTPT = (CT",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_4",
                    title: "Hydrocarbon",
                    summary: "",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_5",
                    title: "1. Alkane (Hydrocarbon no)",
                    summary: "**Khái niệm:** Là những hydrocarbon mạch hở, trong phân tử chỉ chứa các liên kết đơn C-C và C-H. Công thức chung: CnH2n+2 (n >= 1).; **Tính chất hóa học:** Do chỉ có liên kết sigma bền vững nên alkane tương đối trơ ở nhi",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_6",
                    title: "2. Alkene và Alkyne (Hydrocarbon không no)",
                    summary: "**Alkene:** Hydrocarbon mạch hở chứa 1 liên kết đôi C=C. Công thức chung: CnH2n (n >= 2). Có đồng phân hình học (cis - trans) khi các nhóm thế ở mỗi carbon mang liên kết đôi khác nhau từng đôi một.; **Alkyne:** Hydrocarb",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_7",
                    title: "3. Arene (Hydrocarbon thơm)",
                    summary: "**Khái niệm:** Là những hydrocarbon trong phân tử có chứa vòng benzene. Công thức chung của dãy đồng đẳng benzene: CnH2n-6 (n >= 6).; **Tính chất hóa học (Tính thơm):** Dễ thế, khó cộng và bền vững với các chất oxi hóa.",
                    subject: "Hóa học",
                    grade: 11,
                    semester: 2,
                    videoId: "614i3Gf3E6g",
                    channelName: "VietJack • Cân Bằng Hóa Học 11",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 12, 1), ("hóa", 12, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s1_1",
                    title: "Ester và Lipid",
                    summary: "",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_2",
                    title: "1. Ester (Este)",
                    summary: "**Khái niệm:** Khi thay thế nhóm -OH ở nhóm carboxyl của carboxylic acid bằng nhóm -OR' của alcohol thì ta thu được ester. Công thức chung của ester đơn chức: RCOOR'.; **Tính chất vật lí:** Thường là chất lỏng hoặc chất",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_3",
                    title: "2. Lipid (Chất béo)",
                    summary: "**Khái niệm:** Chất béo là triester của glycerol với các acid béo, gọi chung là triglyceride. Định dạng cấu tạo tổng quát: (RCOO)3C3H5.; **Các acid béo thường gặp:**",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_4",
                    title: "Carbohydrate (Saccarit)",
                    summary: "",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_5",
                    title: "1. Monosaccharide: Glucose và Fructose (C6H12O6)",
                    summary: "**Glucose:** Là hợp chất tạp chức, dạng mạch hở có 5 nhóm -OH và 1 nhóm -CH=O (aldehyde). Trong y học dùng làm thuốc tăng lực (đường huyết chiếm 0,1%).; **Fructose:** Là đồng phân của glucose, dạng mạch hở có 5 nhóm -OH",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_6",
                    title: "2. Disaccharide: Sucrose và Maltose (C12H22O11)",
                    summary: "**Sucrose (Đường mía):** Cấu tạo gồm 1 gốc glucose và 1 gốc fructose liên kết với nhau qua nguyên tử oxygen. Không có nhóm chức aldehyde nên không có tính khử (không tráng bạc).",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_7",
                    title: "3. Polysaccharide: Tinh bột và Cellulose ((C6H10O5)n)",
                    summary: "**Tinh bột:** Gồm hai dạng cấu trúc là amylose (mạch không phân nhánh) và amylopectin (mạch phân nhánh).; **Cellulose:** Mạch không phân nhánh, cấu tạo từ các gốc glucose. Là thành phần chính cấu tạo nên màng tế bào thực",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_8",
                    title: "Hợp chất chứa Nitrogen: Amine, Amino acid và Protein",
                    summary: "",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_9",
                    title: "1. Amine",
                    summary: "**Khái niệm:** Khi thay thế một hoặc nhiều nguyên tử hydrogen trong phân tử NH3 bằng một hoặc nhiều gốc hydrocarbon, ta thu được amine (Phân loại bậc 1, bậc 2, bậc 3).; **Aniline (C6H5NH3):** Là amine thơm điển hình, chấ",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_10",
                    title: "2. Amino acid và Peptide",
                    summary: "**Amino acid:** Hợp chất hữu cơ tạp chức, phân tử chứa đồng thời nhóm amino (-NH2) và nhóm carboxyl (-COOH). Tồn tại chủ yếu ở dạng ion lưỡng cực, là chất rắn kết tinh, dễ tan trong nước. (Ví dụ: Glycine, Alanine, Valine",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_11",
                    title: "3. Protein (Chất đạm)",
                    summary: "**Khái niệm:** Là những polypeptide cao phân tử có khối lượng phân tử lớn từ vài vạn đến vài triệu. Gồm protein đơn giản và protein phức tạp.; **Tính chất:** Có sự đông tụ bởi nhiệt độ hoặc acid/base (Ví dụ: hiện tượng l",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 1,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("hóa học", 12, 2), ("hóa", 12, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s2_1",
                    title: "Vật liệu Polymer",
                    summary: "**Khái niệm:** Polymer là những hợp chất có khối lượng phân tử rất lớn do nhiều đơn vị nhỏ (gọi là mắt xích) liên kết với nhau tạo nên.; **Phân loại:** Polymer thiên nhiên (bông, tơ tằm, cao su tự nhiên), Polymer tổng hợ",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_2",
                    title: "Đại cương về kim loại",
                    summary: "",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_3",
                    title: "1. Tính chất của kim loại và Cặp oxi hóa - khử",
                    summary: "**Tính chất vật lí chung:** Tính dẻo, tính dẫn điện, tính dẫn nhiệt và có ánh kim. Gây ra bởi sự dịch chuyển tự do của các electron trong mạng tinh thể kim loại.; **Tính chất hóa học chung:** **Tính khử** (M -> M^n+ + ne",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_4",
                    title: "2. Sự ăn mòn kim loại",
                    summary: "**Ăn mòn hóa học:** Là quá trình oxi hóa - khử, trong đó các electron của kim loại được chuyển trực tiếp đến các chất trong môi trường (Ví dụ: thanh sắt trong lò đốt bị ăn mòn bởi khí O2, nước chứa acid). Không phát sinh",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_5",
                    title: "3. Điều chế kim loại",
                    summary: "**Nguyên tắc chung:** Khử ion kim loại thành nguyên tử (M^n+ + ne -> M).; **Các phương pháp điều chế:**",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_6",
                    title: "Sơ lược về một số kim loại chuyển tiếp dãy thứ nhất (Iron - Sắt)",
                    summary: "**Vị trí và Cấu hình electron của Sắt (Fe):** Số hiệu Z = 26. Cấu hình e: [Ar] 3d6 4s2. Khi tham gia phản ứng dễ nhường 2e hoặc 3e để đạt số oxi hóa +2 hoặc +3.; **Hợp chất của Sắt:**",
                    subject: "Hóa học",
                    grade: 12,
                    semester: 2,
                    videoId: "8nfiPbueiPI",
                    channelName: "Thầy Phạm Thắng • Este & Lipit 12",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 6, 1), ("sinh", 6, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s1_1",
                    title: "Chủ đề: Giới thiệu về Khoa học tự nhiên",
                    summary: "Các lĩnh vực của Khoa học tự nhiên; Kính lúp và Kính hiển vi quang học. - - Lĩnh vực: Sinh học là một nhánh của Khoa học tự nhiên, chuyên nghiên cứu về các sinh vật sống, mối quan hệ giữa chúng và với môi trường.; - Dụng",
                    subject: "Sinh học",
                    grade: 6,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_2",
                    title: "Chủ đề: Tế bào - Đơn vị cơ sở của sự sống",
                    summary: "Khái niệm, cấu tạo và chức năng của tế bào; Sự lớn lên và phân chia của tế bào. - - Khái niệm: Tế bào là đơn vị cấu trúc và chức năng cơ bản của mọi sinh vật sống.; - Cấu tạo: Gồm 3 thành phần chính: Màng sinh chất (bảo",
                    subject: "Sinh học",
                    grade: 6,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_3",
                    title: "Chủ đề: Từ tế bào đến cơ thể",
                    summary: "Cơ thể đơn bào và cơ thể đa bào; Các cấp độ tổ chức của cơ thể đa bào. - - Phân loại: Cơ thể đơn bào chỉ cấu tạo từ 1 tế bào (trùng roi, vi khuẩn). Cơ thể đa bào cấu tạo từ nhiều tế bào (con người, cây ngô).; - Cấp độ tổ",
                    subject: "Sinh học",
                    grade: 6,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 6, 2), ("sinh", 6, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s2_1",
                    title: "Chủ đề: Đa dạng thế giới sống (Virus và Vi khuẩn)",
                    summary: "Virus; Vi khuẩn. - - Virus: Chưa có cấu tạo tế bào, kích thước siêu nhỏ, ký sinh bắt buộc trong tế bào chủ. Gây ra các bệnh nguy hiểm (AIDS, cúm, sốt xuất huyết, Covid-19).; - Vi khuẩn: Là sinh vật nhân sơ, đơn bào, có m",
                    subject: "Sinh học",
                    grade: 6,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_2",
                    title: "Chủ đề: Đa dạng thế giới sống (Nấm và Thực vật)",
                    summary: "Đa dạng các nhóm Nấm; Đa dạng các nhóm Thực vật và vai trò của thực vật. - - Nấm: Không có chất diệp lục, sống dị dưỡng (nấm men, nấm mốc, nấm ăn). Tránh xa các loại nấm độc gây chết người.; - Thực vật: Tự dưỡng nhờ quá",
                    subject: "Sinh học",
                    grade: 6,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_3",
                    title: "Chủ đề: Đa dạng thế giới sống (Động vật)",
                    summary: "Động vật không xương sống; Động vật có xương sống. - - Động vật không xương sống: Chiếm đa số, không có xương sống bên trong. Gồm các ngành: Ruột khoang (thủy tức, sứa), Giun (giun đất, sán), Thân mềm (ốc, mực), Chân khớ",
                    subject: "Sinh học",
                    grade: 6,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_4",
                    title: "Chủ đề: Tìm hiểu sinh vật ngoài thiên nhiên",
                    summary: "Các phương pháp quan sát, thu thập và định danh sinh vật ngoài thiên nhiên. - - Thực hành sử dụng khóa lưỡng phân để phân loại các nhóm sinh vật; xây dựng ý thức bảo vệ các loài sinh vật và môi trường tự nhiên xung quanh",
                    subject: "Sinh học",
                    grade: 6,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 7, 1), ("sinh", 7, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s1_1",
                    title: "Chủ đề: Trao đổi chất và chuyển hóa năng lượng ở sinh vật",
                    summary: "Khái niệm trao đổi chất và chuyển hóa năng lượng; Quang hợp ở thực vật. - - Khái niệm: Là đặc tính cơ bản của sự sống, giúp sinh vật lấy các chất từ môi trường, biến đổi chúng thành chất dinh dưỡng và năng lượng để nuôi",
                    subject: "Sinh học",
                    grade: 7,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 7, 2), ("sinh", 7, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s2_1",
                    title: "Chủ đề: Cảm ứng ở sinh vật",
                    summary: "Cảm ứng ở thực vật; Cảm ứng ở động vật. - - Khái niệm: Là khả năng tiếp nhận và phản ứng lại các kích thích từ môi trường của sinh vật để tồn tại và phát triển.; - Ở thực vật: Phản ứng chậm, khó nhận thấy. Gồm tính hướng",
                    subject: "Sinh học",
                    grade: 7,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_2",
                    title: "Chủ đề: Sinh trưởng và phát triển ở sinh vật",
                    summary: "Khái niệm sinh trưởng, phát triển; Các nhân tố ảnh hưởng; Sinh trưởng và phát triển ở thực vật, động vật. - - Khái niệm: Sinh trưởng là sự tăng lên về kích thước và khối lượng cơ thể. Phát triển là quá trình biến đổi bao",
                    subject: "Sinh học",
                    grade: 7,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_3",
                    title: "Chủ đề: Sinh sản ở sinh vật",
                    summary: "Khái niệm sinh sản; Sinh sản vô tính và sinh sản hữu tính ở sinh vật. - - Sinh sản vô tính: Không có sự kết hợp của giao tử đực và cái, con non sinh ra giống hệt mẹ. (Thực vật: giâm cành, chiết cành, ghép cành; Động vật:",
                    subject: "Sinh học",
                    grade: 7,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_4",
                    title: "Chủ đề: Cơ thể sinh vật là một thể thống nhất",
                    summary: "Mối quan hệ giữa các hoạt động sống trong cơ thể sinh vật. - - Tất cả các quá trình: Trao đổi chất - chuyển hóa năng lượng, Cảm ứng, Sinh trưởng - Phát triển và Sinh sản có mối quan hệ qua lại chặt chẽ, phối hợp nhịp nhà",
                    subject: "Sinh học",
                    grade: 7,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 8, 1), ("sinh", 8, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s1_1",
                    title: "Chương I: Khái quát về cơ thể người",
                    summary: "- Cấu tạo cơ thể người; - Cấu tạo và chức năng của tế bào; - Các loại mô chính; - Phản xạ và cung phản xạ - - Cơ thể gồm 3 phần: Đầu, thân, tứ chi. Khoang thân chứa các cơ quan nội tạng.; - Tế bào là đơn vị chức năng và",
                    subject: "Sinh học",
                    grade: 8,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_2",
                    title: "Chương II: Vận động",
                    summary: "- Cấu tạo và tính chất của xương; - Cấu tạo và tính chất của cơ; - Tiến hóa của hệ vận động; - Vệ sinh hệ vận động - - Bộ xương chia làm 3 phần: Xương đầu, xương thân (cột sống, lồng ngực), xương chi.; - Khớp xương: Khớp",
                    subject: "Sinh học",
                    grade: 8,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_3",
                    title: "Chương III: Tuần hoàn",
                    summary: "- Thành phần của máu và môi trường trong; - Bạch cầu và miễn dịch; - Đông máu và truyền máu; - Hệ tuần hoàn và lưu thông máu - - Máu gồm: Huyết tương (55%) và các tế bào máu (45% - hồng cầu, bạch cầu, tiểu cầu).; - Môi t",
                    subject: "Sinh học",
                    grade: 8,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_4",
                    title: "Chương IV: Hô hấp",
                    summary: "- Khái niệm hô hấp; - Cấu tạo hệ hô hấp; - Thông khí ở phổi và trao đổi khí; - Vệ sinh hệ hô hấp - - Hô hấp là quá trình cung cấp $O_2$ cho tế bào và loại bỏ $CO_2$ ra khỏi cơ thể.; - Hệ hô hấp gồm: Đường dẫn khí (mũi, h",
                    subject: "Sinh học",
                    grade: 8,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_5",
                    title: "Chương V: Tiêu hóa",
                    summary: "- Khái niệm tiêu hóa; - Tiêu hóa ở khoang miệng, dạ dày, ruột non; - Hấp thụ chất dinh dưỡng; - Vệ sinh hệ tiêu hóa - - Quá trình tiêu hóa gồm: Biến đổi lý học (nhai, nghiền, co bóp) và Biến đổi hóa học (nhờ các enzyme c",
                    subject: "Sinh học",
                    grade: 8,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 8, 2), ("sinh", 8, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s2_1",
                    title: "Chương VI: Trao đổi chất và Năng lượng",
                    summary: "- Trao đổi chất giữa cơ thể và môi trường; - Chuyển hóa vật chất và năng lượng; - Cân bằng thân nhiệt; - Vitamin và muối khoáng - - Trao đổi chất ở cấp độ cơ thể (lấy thức ăn, $O_2$ $\\rightarrow$ thải chất bã, $CO_2$) và",
                    subject: "Sinh học",
                    grade: 8,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_2",
                    title: "Chương VII: Bài tiết",
                    summary: "- Khái niệm bài tiết; - Cấu tạo hệ bài tiết nước tiểu; - Quá trình tạo thành nước tiểu; - Vệ sinh hệ bài tiết - - Các cơ quan bài tiết: Phổi ($CO_2$), da (mồ hôi), thận (nước tiểu - chủ yếu chiếm 90%).; - Thận gồm các đơ",
                    subject: "Sinh học",
                    grade: 8,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_3",
                    title: "Chương VIII: Da",
                    summary: "- Cấu tạo của da; - Chức năng của da; - Vệ sinh và bảo vệ da - - Cấu tạo da gồm 3 lớp: Lớp biểu bì (tầng sừng, tầng tế bào sống), lớp bì (thụ quan, tuyến mồ hôi, mạch máu, cơ co chân lông), lớp mỡ dưới da.; - Chức năng:",
                    subject: "Sinh học",
                    grade: 8,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_4",
                    title: "Chương IX: Thần kinh và Giác quan",
                    summary: "- Cấu tạo hệ thần kinh; - Cấu tạo và chức năng của não bộ, tủy sống; - Phản xạ có điều kiện (PXCĐK) và Phản xạ không điều kiện (PXKĐK); - Cơ quan phân tích thị giác và thính giác - - Hệ thần kinh cấu tạo gồm: Bộ phận tru",
                    subject: "Sinh học",
                    grade: 8,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_5",
                    title: "Chương X: Nội tiết",
                    summary: "- Khái niệm tuyến nội tiết; - Tuyến yên, tuyến giáp, tuyến tụy, tuyến trên thận, tuyến sinh dục; - Điều hòa và phối hợp hoạt động của các tuyến - - Tuyến nội tiết tiết hormone ngấm thẳng vào máu để điều hòa các quá trình",
                    subject: "Sinh học",
                    grade: 8,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_6",
                    title: "Chương XI: Sinh sản",
                    summary: "- Cấu tạo cơ quan sinh sản nam và nữ; - Quá trình thụ tinh và thụ thai; - Cơ sở khoa học của các biện pháp tránh thai; - Các bệnh lây qua đường tình dục - - Cơ quan sinh sản nam: Tinh hoàn (sản xuất tinh trùng), ống dẫn",
                    subject: "Sinh học",
                    grade: 8,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 9, 1), ("sinh", 9, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s1_1",
                    title: "Chương I: Các quy luật di truyền",
                    summary: "- Các thí nghiệm của Menđen; - Lai một cặp tính trạng; - Lai hai cặp tính trạng; - Lai phân tích - - Tính trạng trội/lặn, kiểu gen, kiểu hình, dòng thuần chủng.; - Quy luật phân ly (Lai 1 cặp): F2 thu được tỉ lệ 3 trội :",
                    subject: "Sinh học",
                    grade: 9,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_2",
                    title: "Chương II: Nhiễm sắc thể (NST)",
                    summary: "- Tính đặc trưng của bộ NST; - Nguyên phân; - Giảm phân; - Thụ tinh; - Di truyền liên kết - - Bộ NST đặc trưng về số lượng, hình dạng (Đơn bội $n$, Lưỡng bội $2n$).; - Nguyên phân: Từ 1 tế bào mẹ ($2n$) $\\rightarrow$ 2 t",
                    subject: "Sinh học",
                    grade: 9,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_3",
                    title: "Chương III: ADN và Gen",
                    summary: "- Cấu tạo và cơ chế tự sao của ADN; - Mối quan hệ giữa ADN và ARN; - Quá trình tổng hợp Prôtêin; - Mã di truyền - - ADN cấu tạo theo nguyên tắc đa phân (đơn phân là 4 loại Nu: A, T, G, X) và nguyên tắc bổ sung (A-T, G-X)",
                    subject: "Sinh học",
                    grade: 9,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_4",
                    title: "Chương IV: Biến dị",
                    summary: "- Đột biến gen; - Đột biến cấu trúc và số lượng NST; - Thường biến - - Đột biến gen: Thay đổi cấu trúc gen (mất, thêm, thay thế 1 cặp Nu).; - Đột biến cấu trúc NST: Mất đoạn, lặp đoạn, đảo đoạn.; - Đột biến số lượng NST:",
                    subject: "Sinh học",
                    grade: 9,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_5",
                    title: "Chương V: Di truyền học người",
                    summary: "- Phương pháp nghiên cứu di truyền người; - Bệnh và tật di truyền ở người; - Di truyền y học tư vấn - - Hai phương pháp chính: Nghiên cứu phả hệ và nghiên cứu trẻ đồng sinh.; - Bệnh di truyền: Đao (3 NST 21), Tơnnơ (OX),",
                    subject: "Sinh học",
                    grade: 9,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 9, 2), ("sinh", 9, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s2_1",
                    title: "Chương VI: Ứng dụng Di truyền học",
                    summary: "- Công nghệ tế bào; - Công nghệ gen; - Chọn giống vật nuôi, cây trồng; - Ưu thế lai - - Công nghệ tế bào: Nuôi cấy mô, nhân bản vô tính Động vật.; - Công nghệ gen: Kỹ thuật gen tạo ra các sinh vật biến đổi gen (GMO).; -",
                    subject: "Sinh học",
                    grade: 9,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_2",
                    title: "Chương VII: Sinh vật và Môi trường",
                    summary: "- Môi trường và các nhân tố sinh thái; - Ảnh hưởng của Ánh sáng, Nhiệt độ, Độ ẩm lên đời sống sinh vật; - Mối quan hệ cùng loài và khác loài - - 4 môi trường chính: Đất, nước, không khí (trên cạn), sinh vật.; - Nhân tố s",
                    subject: "Sinh học",
                    grade: 9,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_3",
                    title: "Chương VIII: Hệ sinh thái",
                    summary: "- Quần thể sinh vật; - Quần thể người; - Quần xã sinh vật; - Hệ sinh thái; - Chuỗi và lưới thức ăn - - Quần thể: Tập hợp các cá thể cùng loài, cùng sống trong một không gian, thời gian xác định, có khả năng sinh sản.; -",
                    subject: "Sinh học",
                    grade: 9,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_4",
                    title: "Chương IX: Con người, Môi trường và Hệ sinh thái",
                    summary: "- Tác động của con người tới môi trường; - Ô nhiễm môi trường; - Sử dụng hợp lý tài nguyên thiên nhiên; - Bảo vệ đa dạng sinh học - - Hoạt động của con người gây suy thoái môi trường tự nhiên (chặt phá rừng, khí thải từ",
                    subject: "Sinh học",
                    grade: 9,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 10, 1), ("sinh", 10, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s1_1",
                    title: "Chương I: Giới thiệu khái quát chương trình môn Sinh học và các cấp độ tổ chức của thế giới sống",
                    summary: "- Đối tượng, mục đích, vai trò của Sinh học; - Các cấp độ tổ chức sống; - Đặc điểm chung của các cấp độ tổ chức sống - - Sinh học nghiên cứu sự sống ở nhiều cấp độ khác nhau.; - Các cấp độ tổ chức sống cơ bản: Phân tử $\\",
                    subject: "Sinh học",
                    grade: 10,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_2",
                    title: "Chương II: Thành phần hóa học của tế bào",
                    summary: "- Các nguyên tố hóa học trong tế bào; - Nước và vai trò sinh học của nước; - Các phân tử sinh học trong tế bào - - Nguyên tố đa lượng (C, H, O, N... chiếm $\\ge$ 0,01%): Cấu tạo nên các đại phân tử hữu cơ. Cacbon là nguyê",
                    subject: "Sinh học",
                    grade: 10,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_3",
                    title: "Chương III: Cấu trúc tế bào",
                    summary: "- Tế bào nhân sơ (Prokaryote); - Tế bào nhân thực (Eukaryote); - Cấu tạo và chức năng các bào quan - - Tế bào nhân sơ (Vi khuẩn): Chưa có nhân hoàn chỉnh, không có màng nhân và các bào quan có màng.; - Tế bào nhân thực (",
                    subject: "Sinh học",
                    grade: 10,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_4",
                    title: "Chương IV: Trao đổi chất và chuyển hóa năng lượng ở tế bào",
                    summary: "- Vận chuyển các chất qua màng sinh chất; - Enzyme và vai trò của enzyme; - Quang hợp và Hô hấp tế bào - - Vận chuyển: Thụ động (không tốn ATP, theo chiều gradient), Chủ động (tốn ATP, ngược chiều gradient), Xuất - nhập",
                    subject: "Sinh học",
                    grade: 10,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 10, 2), ("sinh", 10, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s2_1",
                    title: "Chương V: Chu kỳ tế bào, phân bào và công nghệ tế bào",
                    summary: "- Chu kỳ tế bào và quá trình Nguyên phân; - Quá trình Giảm phân; - Công nghệ tế bào thực vật và động vật - - Chu kỳ tế bào gồm: Kỳ trung gian (Pha G1, S, G2 - nhân đôi ADN, lớn lên) và Quá trình phân bào (M).; - Nguyên p",
                    subject: "Sinh học",
                    grade: 10,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_2",
                    title: "Chương VI: Sinh học vi sinh vật",
                    summary: "- Khái niệm và đặc điểm vi sinh vật; - Các hình thức sinh trưởng và sinh sản của vi sinh vật; - Quá trình phân giải và tổng hợp ở vi sinh vật; - Ứng dụng của vi sinh vật - - Vi sinh vật có kích thước nhỏ bé, hấp thụ và c",
                    subject: "Sinh học",
                    grade: 10,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_3",
                    title: "Chương VII: Virus và ứng dụng",
                    summary: "- Khái niệm và cấu tạo của virus; - Chu kỳ nhân lên của virus trong tế bào chủ; - Các bệnh do virus và phương pháp phòng chống - - Virus là thực thể chưa có cấu tạo tế bào, sống ký sinh nội bào bắt buộc. Cấu tạo gồm: Lõi",
                    subject: "Sinh học",
                    grade: 10,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 11, 1), ("sinh", 11, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s1_1",
                    title: "Chủ đề 1: Trao đổi chất và chuyển hóa năng lượng ở thực vật",
                    summary: "- Trao đổi nước và khoáng ở thực vật; - Quang hợp ở thực vật; - Hô hấp ở thực vật - - Nước và ion khoáng được hấp thụ qua lông hút của rễ, vận chuyển qua mạch gỗ (dòng đi lên) và mạch rây (dòng đi xuống). Thoát hơi nước",
                    subject: "Sinh học",
                    grade: 11,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_2",
                    title: "Chủ đề 2: Trao đổi chất và chuyển hóa năng lượng ở động vật",
                    summary: "- Dinh dưỡng và tiêu hóa ở động vật; - Hô hấp ở động vật; - Hệ tuần hoàn ở động vật; - Miễn dịch ở người và động vật; - Bài tiết và cân bằng nội môi - - Tiêu hóa: Động vật đơn bào (tiêu hóa nội bào), động vật có túi tiêu",
                    subject: "Sinh học",
                    grade: 11,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 11, 2), ("sinh", 11, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s2_1",
                    title: "Chủ đề 3: Cảm ứng ở sinh vật",
                    summary: "- Cảm ứng ở thực vật; - Cảm ứng ở động vật - - Thực vật: Hướng động (hướng sáng, hướng nước, hướng trọng lực, hướng hóa, hướng tiếp xúc) và Ứng động (vận động quấn vòng, ứng động sức trương nước, ứng động sinh trưởng).;",
                    subject: "Sinh học",
                    grade: 11,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_2",
                    title: "Chủ đề 4: Sinh trưởng và phát triển ở sinh vật",
                    summary: "- Sinh trưởng và phát triển ở thực vật; - Sinh trưởng và phát triển ở động vật - - Thực vật: Mô phân sinh (đỉnh, bên, lóng) giúp cây dài ra và to ra. Hormone thực vật gồm nhóm kích thích (Auxin, Gibberellin, Cytokinin) v",
                    subject: "Sinh học",
                    grade: 11,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_3",
                    title: "Chủ đề 5: Sinh sản ở sinh vật",
                    summary: "- Sinh sản ở thực vật; - Sinh sản ở động vật - - Thực vật: Sinh sản vô tính (bào tử, sinh dưỡng như giâm, chiết, ghép) và Sinh sản hữu tính (thụ phấn, thụ tinh kép tạo hợp tử $2n$ và nội nhũ $3n$).; - Động vật: Sinh sản",
                    subject: "Sinh học",
                    grade: 11,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_4",
                    title: "Chủ đề 6: Mối quan hệ giữa các quá trình sinh lý trong cơ thể sinh vật",
                    summary: "- Sự thống nhất giữa các hệ cơ quan trong cơ thể - - Mối quan hệ qua lại và hữu cơ giữa trao đổi chất - năng lượng, cảm ứng, sinh trưởng, phát triển và sinh sản giúp sinh vật tồn tại và thích nghi như một thể thống nhất.",
                    subject: "Sinh học",
                    grade: 11,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 12, 1), ("sinh", 12, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s1_1",
                    title: "Chương I: Di truyền học phân tử và tế bào",
                    summary: "- Hệ gen, mã di truyền và quá trình nhân đôi ADN; - Biểu hiện thông tin di truyền (Phiên mã, Dịch mã); - Điều hòa biểu hiện gen; - Đột biến gen và Đột biến nhiễm sắc thể (NST); - Công nghệ di truyền - - Hệ gen là toàn bộ",
                    subject: "Sinh học",
                    grade: 12,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_2",
                    title: "Chương II: Tính quy luật của hiện tượng di truyền",
                    summary: "- Các quy luật di truyền của Mendel; - Mở rộng học thuyết Mendel (Tương tác gen, Đa hiệu); - Di truyền liên kết gen và Hoán vị gen; - Di truyền liên kết giới tính và Di truyền ngoài nhân; - Tương tác giữa kiểu gen và môi",
                    subject: "Sinh học",
                    grade: 12,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_3",
                    title: "Chương III: Di truyền học quần thể và Di truyền học người",
                    summary: "- Di truyền học quần thể (Tự phối, Ngẫu phối); - Di truyền y học và Bản đồ di truyền người - - Quần thể tự thụ phấn/giao phối gần: Tần số allele không đổi, tỉ lệ dị hợp giảm dần, đồng hợp tăng dần. Quần thể ngẫu phối đạt",
                    subject: "Sinh học",
                    grade: 12,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_4",
                    title: "Chương IV: Tiến hóa",
                    summary: "- Các bằng chứng tiến hóa; - Các học thuyết tiến hóa (Lamarck, Darwin, Tổng hợp hiện đại); - Các nhân tố tiến hóa; - Cơ chế hình thành loài mới; - Nguồn gốc và sự phát triển của sự sống - - Bằng chứng: Giải phẫu so sánh",
                    subject: "Sinh học",
                    grade: 12,
                    semester: 1,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("sinh học", 12, 2), ("sinh", 12, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s2_1",
                    title: "Chương V: Môi trường và Các nhân tố sinh thái",
                    summary: "- Môi trường sống và các nhân tố sinh thái; - Giới hạn sinh thái và Ổ sinh thái - - Nhân tố sinh thái gồm nhóm vô sinh (nhiệt độ, ánh sáng...) và hữu sinh (sinh vật, con người).; - Giới hạn sinh thái có khoảng thuận lợi",
                    subject: "Sinh học",
                    grade: 12,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_2",
                    title: "Chương VI: Sinh thái học quần thể",
                    summary: "- Đặc trưng cơ bản của quần thể; - Biến động số lượng cá thể của quần thể - - Các đặc trưng: Kích thước quần thể, mật độ, tỉ lệ giới tính, nhóm tuổi, kiểu phân bố (đồng đều, ngẫu nhiên, theo nhóm).; - Tăng trưởng quần th",
                    subject: "Sinh học",
                    grade: 12,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_3",
                    title: "Chương VII: Sinh thái học quần xã",
                    summary: "- Cấu trúc và đặc trưng của quần xã; - Các mối quan hệ trong quần xã; - Diễn thế sinh thái - - Đặc trưng: Độ đa dạng (số lượng loài và số cá thể mỗi loài), loài ưu thế, loài đặc trưng.; - Quan hệ hỗ trợ (cộng sinh, hợp t",
                    subject: "Sinh học",
                    grade: 12,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_4",
                    title: "Chương VIII: Hệ sinh thái và Sinh quyển",
                    summary: "- Cấu trúc của hệ sinh thái; - Trao đổi chất và chuyển hóa năng lượng trong hệ sinh thái; - Các chu trình sinh địa hóa và Dòng năng lượng - - Hệ sinh thái = Quần xã sinh vật + Sinh cảnh. Thành phần cấu trúc gồm: Sinh vật",
                    subject: "Sinh học",
                    grade: 12,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_5",
                    title: "Chương IX: Sinh học phát triển bền vững và Bảo vệ môi trường",
                    summary: "- Sinh học trong mối quan hệ với xã hội; - Phát triển bền vững và bảo tồn đa dạng sinh học; - Quản lý tài nguyên thiên nhiên và Biến đổi khí hậu - - Ứng dụng sinh học trong y học, nông nghiệp và công nghệ sạch.; - Phát t",
                    subject: "Sinh học",
                    grade: 12,
                    semester: 2,
                    videoId: "3Wp9_d4X0Fw",
                    channelName: "Thầy Phan Khắc Nghệ • Sinh Học",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 6, 1), ("sử", 6, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s1_1",
                    title: "Nhập môn Lịch sử",
                    summary: "**Lịch sử và môn Lịch sử:** Lịch sử là những gì đã xảy ra trong quá khứ. Môn Lịch sử là môn học tìm hiểu về quá khứ của con người và xã hội loài người.; **Vì sao phải học Lịch sử:** Giúp con người biết được cội nguồn của",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_2",
                    title: "Xã hội nguyên thủy",
                    summary: "**Nguồn gốc loài người:** Quá trình tiến hóa từ Vượn người (khoảng 5 - 6 triệu năm trước) -> Người tối cổ (khoảng 4 triệu năm trước) -> Người tinh khôn / Người hiện đại (khoảng 15 vạn năm trước). Dấu tích của Người tối c",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_3",
                    title: "Lịch sử thế giới cổ đại",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_4",
                    title: "1. Các quốc gia cổ đại phương Đông (Ai Cập, Lưỡng Hà, Ấn Độ, Trung Quốc)",
                    summary: "**Điều kiện tự nhiên:** Hình thành ở lưu vực các con sông lớn (Sông Nile ở Ai Cập; Sông Tigris và Euphrates ở Lưỡng Hà; Sông Ấn và Sông Hằng ở Ấn Độ; Sông Hoàng Hà và Trường Giang ở Trung Quốc). Đất đai phù sa màu mỡ, th",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_5",
                    title: "2. Các quốc gia cổ đại phương Tây (Hy Lạp và La Mã)",
                    summary: "**Điều kiện tự nhiên:** Hình thành ở vùng ven biển Địa Trung Hải, địa hình nhiều đồi núi, đất đai khô cằn. Thuận lợi phát triển thủ công nghiệp (làm gốm, đúc đồng) và thương nghiệp đường biển (hàng hải, buôn bán).; **Chế",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 6, 2), ("sử", 6, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s2_1",
                    title: "Nước Văn Lang và Âu Lạc",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_2",
                    title: "1. Nước Văn Lang (Khoảng thế kỷ VII TCN - 208 TCN)",
                    summary: "**Cơ sở hình thành:** Sự phát triển của văn hóa Đông Sơn và nghề trồng lúa nước; nhu cầu trị thủy (đắp đê chống lũ) và chống giặc ngoại xâm.; **Tổ chức nhà nước:** Kinh đô đặt tại Phong Châu (Phú Thọ). Đứng đầu nhà nước",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_3",
                    title: "2. Nước Âu Lạc (208 TCN - 179 TCN)",
                    summary: "**Sự thành lập:** Thục Phán hợp nhất người Tây Âu và Lạc Việt sau cuộc kháng chiến chống quân xâm lược Tần thành công, lên ngôi lấy hiệu là An Dương Vương, lập ra nước Âu Lạc, dời đô về Cổ Loa (Đông Anh, Hà Nội).; **Sự p",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_4",
                    title: "Thời kỳ Bắc thuộc và cuộc đấu tranh giành độc lập dân tộc (Từ thế kỷ II TCN đến thế kỷ X)",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_5",
                    title: "1. Chính sách cai trị của phong kiến phương Bắc",
                    summary: "**Về hành chính:** Sáp nhập lãnh thổ nước ta vào bản đồ Trung Quốc, chia thành các quận, huyện, cử quan lại người Hán sang cai trị trực tiếp tới tận cấp huyện.; **Về kinh tế:** Áp đặt chính sách vơ vét, bóc lột thuế khóa",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_6",
                    title: "2. Các cuộc khởi nghĩa tiêu biểu trong thời kỳ Bắc thuộc",
                    summary: "**Khởi nghĩa Hai Bà Trưng (Năm 40):** Chống lại ách cai trị của nhà Đông Hán (Thái thú Tô Định). Cuộc khởi nghĩa bùng nổ ở Hát Môn, nhanh chóng làm chủ các quận, lật đổ chính quyền đô hộ. Trưng Trắc lên ngôi vua (Trưng V",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_7",
                    title: "3. Bước ngoặt lịch sử đầu thế kỷ X",
                    summary: "**Cuộc tự chủ của họ Khúc và họ Dương:**; **Chiến thắng Bạch Đằng của Ngô Quyền (Năm 938):**",
                    subject: "Lịch sử",
                    grade: 6,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 7, 1), ("sử", 7, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s1_1",
                    title: "Lịch sử thế giới trung đại",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_2",
                    title: "1. Quá trình hình thành và phát triển của chế độ phong kiến Tây Âu",
                    summary: "**Sự hình thành:** Từ thế kỷ V, các bộ tộc người Germain tràn vào xâm chiếm lãnh thổ của đế quốc La Mã, thành lập các vương quốc mới. Họ phong chức tước, chia ruộng đất cho các tướng lĩnh quân sự và quý tộc, hình thành c",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_3",
                    title: "2. Các cuộc phát kiến địa lí và sự hình thành quan hệ sản xuất tư bản chủ nghĩa",
                    summary: "**Các cuộc phát kiến địa lí lớn (Thế kỷ XV - XVI):**; **Sự hình thành quan hệ sản xuất tư bản chủ nghĩa:** Giai cấp quý tộc và thương nhân Tây Âu tích lũy vốn và nhân công bằng cách tước đoạt ruộng đất, cướp bóc thuộc đị",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_4",
                    title: "3. Phong trào Văn hóa Phục hưng và Cải cách tôn giáo",
                    summary: "**Phong trào Văn hóa Phục hưng (Thế kỷ XIV - XVII):** Xuất hiện đầu tiên ở Ý, nhằm khôi phục và phát triển những giá trị tinh hoa của văn hóa cổ đại Hy Lạp - La Mã. Tư tưởng chủ đạo là chủ nghĩa nhân văn, đề cao giá trị",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_5",
                    title: "4. Lịch sử Trung Quốc và Ấn Độ thời phong kiến",
                    summary: "**Trung Quốc:** Phát triển rực rỡ qua các triều đại Đường, Tống, Nguyên, Minh, Thanh. Bộ máy nhà nước quân chủ chuyên chế ngày càng hoàn thiện và tập quyền sâu sắc. Nền kinh tế phát triển mạnh, xuất hiện mầm mống tư bản",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_6",
                    title: "Lịch sử Việt Nam từ thế kỷ X đến đầu thế kỷ XI",
                    summary: "",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_7",
                    title: "1. Thời kỳ Ngô - Đinh - Tiền Lê (939 - 1009)",
                    summary: "**Nhà Ngô (939 - 965):** Ngô Quyền lên ngôi vua, chọn Cổ Loa làm kinh đô, xây dựng chính quyền độc lập bước đầu ổn định. Sau khi Ngô Quyền mất, đất nước rơi vào thời kỳ **'Loạn 12 sứ quân'**.; **Nhà Đinh (968 - 980):** Đ",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 7, 2), ("sử", 7, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s2_1",
                    title: "Nước Đại Việt thời Lý (1009 - 1225)",
                    summary: "**Sự thành lập và dời đô:** Năm 1009, Lý Công Uẩn lên ngôi vua (Lý Thái Tổ), sáng lập nhà Lý. Năm 1010, vua quyết định **dời đô từ Hoa Lư về thành Đại La và đổi tên thành Thăng Long** (Hà Nội ngày nay) vì đây là vùng đất",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_2",
                    title: "Nước Đại Việt thời Trần (1226 - 1400)",
                    summary: "**Sự thành lập:** Cuối thế kỷ XII, nhà Lý suy yếu. Đầu năm 1226, Lý Chiêu Hoàng (vua nữ cuối cùng nhà Lý) nhường ngôi cho chồng là Trần Cảnh (Trần Thái Tông), nhà Trần thành lập. Nhà Trần thực hiện chế độ **Thái thượng h",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_3",
                    title: "Nước Đại Việt thời Hồ (1400 - 1407)",
                    summary: "**Sự thành lập:** Cuối thế kỷ XIV, nhà Trần khủng hoảng suy yếu trầm trọng. Năm 1400, đại thần Hồ Quý Ly ép vua Trần nhường ngôi, lập ra nhà Hồ, đổi tên nước thành **Đại Ngu** (mong muốn sự an vui lớn), dời đô về Tây Đô",
                    subject: "Lịch sử",
                    grade: 7,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 8, 1), ("sử", 8, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s1_1",
                    title: "Chủ đề / Chương",
                    summary: "Nội dung / Sự kiện trọng tâm - Kiến thức cốt lõi cần nắm vững",
                    subject: "Lịch sử",
                    grade: 8,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_2",
                    title: "Chương 1: Châu Âu và Bắc Mỹ từ nửa sau thế kỉ XVI đến thế kỉ XVIII",
                    summary: "Cách mạng tư sản Anh, Pháp và Chiến tranh giành độc lập của 13 thuộc địa Anh ở Bắc Mỹ - - Nguyên nhân, tiền đề: Mâu thuẫn giữa tư sản, quý tộc mới với chế độ phong kiến (Anh, Pháp) hoặc ách thống trị thực dân (Bắc Mỹ).;",
                    subject: "Lịch sử",
                    grade: 8,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_3",
                    title: "Chương 2: Đông Nam Á từ nửa sau thế kỉ XVI đến thế kỉ XIX",
                    summary: "Quá trình xâm lược của chủ nghĩa tư bản phương Tây và phong trào đấu tranh của nhân dân ĐNÁ - - Quá trình xâm lược: Các nước phương Tây phân chia thuộc địa (Anh chiếm Miến Điện, Mã Lai; Pháp chiếm 3 nước Đông Dương; Tây",
                    subject: "Lịch sử",
                    grade: 8,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_4",
                    title: "Chương 3: Việt Nam từ đầu thế kỉ XVI đến thế kỉ XVIII",
                    summary: "Xung đột Nam - Bắc triều và Trịnh - Nguyễn - - Cục diện: Nhà Lê suy yếu dẫn đến xung đột Lê - Mạc (Nam - Bắc triều) và xung đột Trịnh - Nguyễn (chia cắt đất nước tại sông Gianh thành Đàng Trong và Đàng Ngoài).; - Hệ quả:",
                    subject: "Lịch sử",
                    grade: 8,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 8, 2), ("sử", 8, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s2_1",
                    title: "Chương 4: Châu Âu và nước Mỹ từ cuối thế kỉ XVIII đến đầu thế kỉ XX",
                    summary: "Sự hình thành chủ nghĩa đế quốc và Phong trào công nhân quốc tế - - Chủ nghĩa đế quốc: Cuối XIX - đầu XX, các nước tư bản chuyển sang giai đoạn đế quốc chủ nghĩa (Anh, Pháp, Đức, Mỹ), xuất hiện các tổ chức độc quyền.; -",
                    subject: "Lịch sử",
                    grade: 8,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_2",
                    title: "Chương 5: Sự phát triển của khoa học, kĩ thuật, văn học, nghệ thuật trong các thế kỉ XVIII - XIX",
                    summary: "Thành tựu khoa học, kĩ thuật, văn học và nghệ thuật thế giới - - Khoa học - kĩ thuật: Các thuyết tiến hóa (Đác-uyn), thuyết vạn vật hấp dẫn (Niu-tơn), phát minh ra điện, dầu mỏ, ô tô...; - Văn học - nghệ thuật: Sự nở rộ",
                    subject: "Lịch sử",
                    grade: 8,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_3",
                    title: "Chương 6: Châu Á từ nửa sau thế kỉ XIX đến đầu thế kỉ XX",
                    summary: "Tình hình Trung Quốc, Nhật Bản, Ấn Độ và Đông Nam Á - - Trung Quốc, Ấn Độ: Bị các nước đế quốc xâm lược, biến thành thuộc địa hoặc nửa thuộc địa; nổ ra nhiều cuộc cách mạng (Cách mạng Tân Hợi 1911 ở Trung Quốc).; - Nhật",
                    subject: "Lịch sử",
                    grade: 8,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_4",
                    title: "Chương 7: Việt Nam từ thế kỉ XIX đến đầu thế kỉ XX",
                    summary: "Việt Nam dưới thời nhà Nguyễn (nửa đầu thế kỉ XIX) - - Chính trị: Nhà Nguyễn thiết lập bộ máy cai trị chuyên chế trung ương tập quyền, xây dựng kinh đô Huế, củng cố luật pháp (Luật Gia Long).; - Đối ngoại: Thực hiện chín",
                    subject: "Lịch sử",
                    grade: 8,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 9, 1), ("sử", 9, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s1_1",
                    title: "Chương 1: Thế giới từ năm 1918 đến năm 1945",
                    summary: "Nước Nga và Liên Xô (1918 - 1945); Các nước tư bản giữa hai cuộc chiến tranh; Chiến tranh thế giới thứ hai (1939 - 1945). - - Liên Xô: Hoàn thành công cuộc khôi phục kinh tế (Chính sách kinh tế mới - NEP) và xây dựng chủ",
                    subject: "Lịch sử",
                    grade: 9,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_2",
                    title: "Chương 2: Thế giới từ năm 1945 đến nay",
                    summary: "Chiến tranh lạnh; Liên hợp quốc; Trật tự thế giới hai cực I-an-ta; Xu thế toàn cầu hóa. - - Trật tự hai cực: Sự đối đầu gay gắt giữa hai khối tư bản chủ nghĩa (Mỹ đứng đầu) và xã hội chủ nghĩa (Liên Xô đứng đầu) thông qu",
                    subject: "Lịch sử",
                    grade: 9,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_3",
                    title: "Chương 3: Việt Nam từ năm 1918 đến năm 1930",
                    summary: "Phong trào yêu nước (1919 - 1925); Hoạt động của Nguyễn Ái Quốc; Sự ra đời của Đảng Cộng sản Việt Nam. - - Bối cảnh: Pháp tiến hành khai thác thuộc địa lần thứ hai, làm chuyển biến xã hội Việt Nam.; - Nguyễn Ái Quốc: Tìm",
                    subject: "Lịch sử",
                    grade: 9,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_4",
                    title: "Chương 4: Việt Nam từ năm 1930 đến năm 1945",
                    summary: "Phong trào cách mạng 1930 - 1931 (Xô viết Nghệ - Tĩnh); Phong trào 1936 - 1939; Cách mạng tháng Tám năm 1945. - - Diễn tập cách mạng: Phong trào 1930 - 1931 và phong trào dân chủ 1936 - 1939 là những bước chuẩn bị quan t",
                    subject: "Lịch sử",
                    grade: 9,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 9, 2), ("sử", 9, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s2_1",
                    title: "Chương 5: Việt Nam từ năm 1945 đến năm 1954",
                    summary: "Đấu tranh bảo vệ chính quyền (1945 - 1946); Kháng chiến toàn quốc chống Pháp; Chiến dịch Điện Biên Phủ 1954. - - Vượt qua hiểm nghèo: Khắc phục nạn đói, nạn dốt, khó khăn tài chính và ký Hiệp định Sơ bộ để đẩy quân Tưởng",
                    subject: "Lịch sử",
                    grade: 9,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_2",
                    title: "Chương 6: Việt Nam từ năm 1954 đến năm 1975",
                    summary: "Cách mạng hai miền Nam - Bắc; Đấu tranh chống các chiến lược chiến tranh của Mỹ; Đại thắng mùa Xuân 1975. - - Nhiệm vụ chiến lược: Miền Bắc xây dựng chủ nghĩa xã hội và làm hậu phương; miền Nam đấu tranh chống Mỹ và tay",
                    subject: "Lịch sử",
                    grade: 9,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_3",
                    title: "Chương 7: Việt Nam từ năm 1975 đến nay",
                    summary: "Khắc phục hậu quả chiến tranh; Công cuộc Đổi mới từ năm 1986 đến nay. - - Giai đoạn đầu: Hoàn thành thống nhất đất nước về mặt nhà nước (1976); chiến đấu bảo vệ biên giới phía Bắc và phía Tây Nam.; - Bước ngoặt Đổi mới:",
                    subject: "Lịch sử",
                    grade: 9,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 10, 1), ("sử", 10, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s1_1",
                    title: "Chủ đề 1: Lịch sử và Sử học",
                    summary: "Hiện thực lịch sử và nhận thức lịch sử; Vai trò của Sử học đối với các ngành khoa học và cuộc sống. - - Khái niệm: Phân biệt 'hiện thực lịch sử' (sự thật khách quan đã xảy ra) và 'nhận thức lịch sử' (tri thức của con ngư",
                    subject: "Lịch sử",
                    grade: 10,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_2",
                    title: "Chủ đề 2: Vai trò của sử học trong bảo tồn di sản",
                    summary: "Mối quan hệ giữa Sử học với công tác bảo tồn, phát huy giá trị di sản văn hóa và thiên nhiên. - - Mối quan hệ biện chứng: Di sản là nguồn sử liệu quan trọng của Sử học; ngược lại, Sử học giúp xác định giá trị thực sự để",
                    subject: "Lịch sử",
                    grade: 10,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_3",
                    title: "Chủ đề 3: Các cuộc cách mạng công nghiệp trong lịch sử thế giới",
                    summary: "Cách mạng công nghiệp lần thứ nhất và lần thứ hai; Cách mạng công nghiệp lần thứ ba và lần thứ tư. - - Cuộc CM lần 1 & 2 (Thế kỉ XVIII - XIX): Gắn liền với máy hơi nước, điện lực, động cơ đốt trong; đưa nhân loại từ văn",
                    subject: "Lịch sử",
                    grade: 10,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_4",
                    title: "Chủ đề 4: Văn minh thế giới thời kì cổ - trung đại",
                    summary: "Các nền văn minh phương Đông và phương Tây cổ - trung đại. - - Phương Đông: Văn minh Ai Cập, Ấn Độ, Trung Hoa cổ - trung đại (hình thành bên các dòng sông lớn, phát minh ra chữ viết, tôn giáo, kiến trúc độc đáo).; - Phươ",
                    subject: "Lịch sử",
                    grade: 10,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 10, 2), ("sử", 10, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s2_1",
                    title: "Chủ đề 5: Các nền văn minh trên đất nước Việt Nam (trước năm 1858)",
                    summary: "Văn minh Văn Lang - Âu Lạc; Văn minh Chăm-pa; Văn minh Phù Nam; Văn minh Đại Việt. - - Các văn minh cổ: Sự hình thành và phát triển của 3 trung tâm văn minh bản địa (Đông Sơn/Văn Lang - Âu Lạc ở miền Bắc; Sa Huỳnh/Chăm-p",
                    subject: "Lịch sử",
                    grade: 10,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_2",
                    title: "Chủ đề 6: Cộng đồng các dân tộc Việt Nam",
                    summary: "Các dân tộc trên đất nước Việt Nam; Khối đại đoàn kết dân tộc trong lịch sử Việt Nam. - - Thành phần: Việt Nam là quốc gia đa dân tộc (54 dân tộc) thuộc các ngữ hệ khác nhau, cùng chung sống lâu đời.; - Đoàn kết: Khối đạ",
                    subject: "Lịch sử",
                    grade: 10,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_3",
                    title: "Chủ đề 7: Lịch sử bảo vệ chủ quyền, các quyền và lợi ích hợp pháp của Việt Nam ở Biển Đông",
                    summary: "Vị trí chiến lược của Biển Đông; Lịch sử xác lập và thực thi chủ quyền của Việt Nam đối với quần đảo Hoàng Sa và Trường Sa. - - Vị trí: Biển Đông là tuyến đường hàng hải huyết mạch quốc tế, có vị trí chiến lược kinh tế v",
                    subject: "Lịch sử",
                    grade: 10,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 11, 1), ("sử", 11, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s1_1",
                    title: "Chủ đề 1: Cách mạng tư sản và sự phát triển của chủ nghĩa tư bản",
                    summary: "Các cuộc cách mạng tư sản tiêu biểu; Sự phát triển của chủ nghĩa tư bản; Chủ nghĩa tư bản hiện đại. - - CM tư sản: Bản chất, động lực và ý nghĩa của các cuộc cách mạng (Anh, Pháp, Mỹ).; - Sự phát triển: Quá trình chuyển",
                    subject: "Lịch sử",
                    grade: 11,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_2",
                    title: "Chủ đề 2: Sự phát triển của chủ nghĩa xã hội",
                    summary: "Sự hình thành và phát triển của Liên Xô; Hệ thống chủ nghĩa xã hội thế giới; Công cuộc đổi mới, cải cách ở Trung Quốc và Việt Nam. - - Sự hình thành: Liên Xô ra đời và trở thành chỗ dựa cho phong trào cách mạng thế giới.",
                    subject: "Lịch sử",
                    grade: 11,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_3",
                    title: "Chủ đề 3: Quá trình giành độc lập dân tộc của các nước Đông Nam Á",
                    summary: "Hành trình đi đến độc lập dân tộc; Phong trào giải phóng dân tộc ở các nước ĐNÁ thời kỳ thuộc địa và sau Thế chiến II. - - Thuộc địa: Các nước ĐNÁ (trừ Xiêm) bị biến thành thuộc địa của thực dân phương Tây.; - Đấu tranh:",
                    subject: "Lịch sử",
                    grade: 11,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_4",
                    title: "Chủ đề 4: Chiến tranh bảo vệ Tổ quốc và chiến tranh giải phóng dân tộc trong lịch sử Việt Nam (trước năm 1945)",
                    summary: "Khái quát về các cuộc chiến tranh giữ nước bảo vệ độc lập; Ý nghĩa và bài học lịch sử của các cuộc kháng chiến thắng lợi. - - Bảo vệ Tổ quốc: Các cuộc kháng chiến chống quân xâm lược phương Bắc tiêu biểu (kháng chiến chố",
                    subject: "Lịch sử",
                    grade: 11,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 11, 2), ("sử", 11, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s2_1",
                    title: "Chủ đề 5: Các cuộc cải cách lớn trong lịch sử Việt Nam (trước năm 1945)",
                    summary: "Cải cách của Khúc Thừa Dụ; Cải cách của Hồ Quý Ly; Cải cách của Lê Thánh Tông; Cải cách Minh Mạng. - - Hồ Quý Ly (cuối XIV - đầu XV): Cải cách toàn diện (phát hành tiền giấy, hạn điền, hạn nô...) nhưng thất bại do chưa h",
                    subject: "Lịch sử",
                    grade: 11,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_2",
                    title: "Chủ đề 6: Lịch sử bảo vệ chủ quyền, các quyền và lợi ích hợp pháp của Việt Nam ở Biển Đông",
                    summary: "Quá trình Việt Nam xác lập, thực thi chủ quyền đối với quần đảo Hoàng Sa và Trường Sa qua các thời kỳ lịch sử. - - Tập trung tư liệu: Khẳng định bằng các nguồn bằng chứng lịch sử vững chắc (mộc bản, châu bản nhà Nguyễn,",
                    subject: "Lịch sử",
                    grade: 11,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 12, 1), ("sử", 12, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s1_1",
                    title: "Chủ đề 1: Thế giới trong và sau Chiến tranh lạnh",
                    summary: "Trật tự thế giới trong Chiến tranh lạnh; Trật tự thế giới sau Chiến tranh lạnh. - - Trong Chiến tranh lạnh: Sự đối đầu giữa hai cực Xô - Mỹ (1947 - 1989), các cuộc chiến tranh cục bộ và sự sụp đổ của trật tự hai cực I-an",
                    subject: "Lịch sử",
                    grade: 12,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_2",
                    title: "Chủ đề 2: ASEAN: Những chặng đường lịch sử",
                    summary: "Quá trình hình thành và phát triển của ASEAN; Ý nghĩa sự ra đời của Cộng đồng ASEAN. - - Lịch sử: Thành lập ngày 8/8/1967 tại Băng Cốc nhằm hợp tác phát triển kinh tế, văn hóa, xã hội và đảm bảo hòa bình khu vực.; - Mở r",
                    subject: "Lịch sử",
                    grade: 12,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_3",
                    title: "Chủ đề 3: Cách mạng tháng Tám năm 1945, Chiến tranh giải phóng dân tộc và chiến tranh bảo vệ Tổ quốc trong lịch sử Việt Nam (từ năm 1945 đến nay)",
                    summary: "Khái quát thắng lợi của Cách mạng tháng Tám (1945); Cuộc kháng chiến toàn quốc chống thực dân Pháp (1945 - 1954). - - Cách mạng tháng Tám: Nghệ thuật chớp thời cơ, kết hợp đấu tranh chính trị với vũ trang, giành chính qu",
                    subject: "Lịch sử",
                    grade: 12,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("lịch sử", 12, 2), ("sử", 12, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s2_1",
                    title: "Chủ đề 3 (Tiếp theo): Cuộc chiến tranh giải phóng và bảo vệ Tổ quốc",
                    summary: "Cuộc kháng chiến chống Mỹ cứu nước (1954 - 1975); Các cuộc chiến tranh bảo vệ biên giới Tổ quốc (sau 1975). - - Kháng chiến chống Mỹ: Đánh bại các chiến lược của Mỹ (Chiến tranh đơn phương, Đặc biệt, Cục bộ, Việt Nam hóa",
                    subject: "Lịch sử",
                    grade: 12,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_2",
                    title: "Chủ đề 4: Công cuộc Đổi mới ở Việt Nam từ năm 1986 đến nay",
                    summary: "Bối cảnh lịch sử; Nội dung và thành tựu của công cuộc Đổi mới đất nước. - - Bối cảnh: Đất nước lâm vào khủng hoảng kinh tế - xã hội trầm trọng do mô hình tập trung quan liêu bao cấp và sự bao vây cấm vận.; - Nội dung Đổi",
                    subject: "Lịch sử",
                    grade: 12,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_3",
                    title: "Chủ đề 5: Lịch sử bảo vệ chủ quyền, các quyền và lợi ích hợp pháp của Việt Nam ở Biển Đông",
                    summary: "Tầm quan trọng của Biển Đông; Đấu tranh ngoại giao và pháp lý bảo vệ chủ quyền biển đảo hiện nay. - - Tầm quan trọng: Ý nghĩa sống còn về kinh tế (dầu khí, thủy sản, vận tải biển) và an ninh quốc phòng của Việt Nam.; - Đ",
                    subject: "Lịch sử",
                    grade: 12,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Mai Phương • Lịch Sử Học Mãi",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 6, 1), ("địa lý", 6, 1), ("địa", 6, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s1_1",
                    title: "Chương 1: Bản đồ - Phương tiện thể hiện bề mặt Trái Đất",
                    summary: "Hệ thống kinh, vĩ tuyến; Tỉ lệ bản đồ; Phương hướng trên bản đồ; Kĩ năng đọc bản đồ. - - Kinh, vĩ tuyến: Xác định kinh tuyến gốc (0 độ), vĩ tuyến gốc (Xích đạo) và cách tìm tọa độ địa lí của một điểm.; - Tỉ lệ bản đồ: Bi",
                    subject: "Địa lí",
                    grade: 6,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_2",
                    title: "Chương 2: Trái Đất - Hành tinh của Hệ Mặt Trời",
                    summary: "Vị trí Trái Đất trong hệ Mặt Trời; Hình dạng, kích thước Trái Đất; Các chuyển động của Trái Đất và hệ quả. - - Vị trí: Trái Đất là hành tinh thứ 3 theo thứ tự xa dần Mặt Trời, có hình cầu.; - Chuyển động tự quay quanh tr",
                    subject: "Địa lí",
                    grade: 6,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_3",
                    title: "Chương 3: Cấu tạo của Trái Đất. Vỏ Trái Đất",
                    summary: "Cấu tạo bên trong của Trái Đất; Các mảng kiến tạo; Nội lực và ngoại lực; Núi lửa và động đất. - - Cấu tạo: Gồm 3 lớp (Vỏ Trái Đất, manti và nhân). Lớp vỏ ngoài cùng tuy mỏng nhất nhưng có vai trò quan trọng nhất đối với",
                    subject: "Địa lí",
                    grade: 6,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s1_4",
                    title: "Chương 4: Địa hình bề mặt Trái Đất",
                    summary: "Các dạng địa hình chính: Núi, đồi, cao nguyên, đồng bằng; Khoáng sản. - - Đặc điểm: Phân biệt các dạng địa hình dựa vào độ cao tuyệt đối và hình thái (đỉnh, sườn, thung lũng).; - Khoáng sản: Phân loại khoáng sản năng lượ",
                    subject: "Địa lí",
                    grade: 6,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 6, 2), ("địa lý", 6, 2), ("địa", 6, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g6_s2_1",
                    title: "Chương 5: Khí hậu và biến đổi khí hậu",
                    summary: "Lớp vỏ khí (Khí quyển); Nhiệt độ không khí; Khí áp và gió; Khí hậu và biến đổi khí hậu. - - Thành phần: Khí quyển gồm nhiều tầng, lớp đối lưu sát mặt đất là nơi diễn ra các hiện tượng khí tượng (mưa, mây, sấm chớp).; - K",
                    subject: "Địa lí",
                    grade: 6,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_2",
                    title: "Chương 6: Nước trên Trái Đất",
                    summary: "Thành phần của thủy quyển; Vòng tuần hoàn lớn của nước; Sông và hồ; Nước ngầm và băng hà; Biển và đại dương. - - Vòng tuần hoàn nước: Nước bốc hơi -> tạo mây -> mưa -> chảy ra sông, biển rồi tiếp tục bốc hơi.; - Sông ngò",
                    subject: "Địa lí",
                    grade: 6,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_3",
                    title: "Chương 7: Đất và sinh vật trên Trái Đất",
                    summary: "Lớp đất trên Trái Đất; Các nhân tố hình thành đất; Sinh vật và các đới thiên nhiên. - - Thành phần đất: Gồm chất khoáng, chất hữu cơ, không khí và nước. Khẳng định vai trò của con người trong việc làm tăng hoặc suy giảm",
                    subject: "Địa lí",
                    grade: 6,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g6_s2_4",
                    title: "Chương 8: Con người và thiên nhiên",
                    summary: "Dân số thế giới; Sự phân bố dân cư; Tác động của con người lên thiên nhiên. - - Dân số: Sự gia tăng dân số thế giới và xu hướng phân bố dân cư tập trung ở những nơi có điều kiện tự nhiên thuận lợi.; - Môi trường: Con ngư",
                    subject: "Địa lí",
                    grade: 6,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 7, 1), ("địa lý", 7, 1), ("địa", 7, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s1_1",
                    title: "Chương 1: Châu Âu",
                    summary: "Vị trí địa lí, đặc điểm tự nhiên, dân cư, xã hội châu Âu; Liên minh châu Âu (EU). - - Tự nhiên: Nằm ở phía tây lục địa Á - Âu, chủ yếu thuộc đới ôn hòa. Địa hình gồm đồng bằng lớn ở phía đông, núi già ở phía bắc và núi t",
                    subject: "Địa lí",
                    grade: 7,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_2",
                    title: "Chương 2: Châu Á",
                    summary: "Vị trí địa lí, tự nhiên, dân cư, xã hội và các khu vực của châu Á. - - Tự nhiên: Châu lục rộng lớn nhất thế giới, có đầy đủ các đới khí hậu, địa hình bị chia cắt mạnh lưới sông ngòi dày đặc (sông Mê Công, sông Trường Gia",
                    subject: "Địa lí",
                    grade: 7,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s1_3",
                    title: "Chương 3: Châu Phi",
                    summary: "Vị trí địa lí, tự nhiên, dân cư, xã hội và vấn đề khai thác, bảo vệ thiên nhiên. - - Tự nhiên: Địa hình chủ yếu là các cao nguyên, khí hậu nóng và khô bậc nhất thế giới do có các hoang mạc khổng lồ (Xa-ha-ra).; - Dân cư",
                    subject: "Địa lí",
                    grade: 7,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 7, 2), ("địa lý", 7, 2), ("địa", 7, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g7_s2_1",
                    title: "Chương 4: Châu Mỹ",
                    summary: "Khái quát vị trí địa lí; Đặc điểm tự nhiên, dân cư, xã hội và kinh tế của Bắc Mỹ, Trung và Nam Mỹ. - - Bắc Mỹ: Địa hình chia làm 3 vùng rõ rệt (hệ thống Coóc-đi-e ở phía tây, đồng bằng ở giữa, núi già A-pa-lát ở phía đôn",
                    subject: "Địa lí",
                    grade: 7,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_2",
                    title: "Chương 5: Châu Đại Dương",
                    summary: "Tự nhiên, dân cư, xã hội và kinh tế khu vực lục địa Ô-xtrây-li-a và các đảo. - - Tự nhiên: Phần lớn diện tích lục địa là hoang mạc khô hạn nhưng có hệ động thực vật đặc hữu vô cùng độc đáo (thú có túi, cây bạch đàn). Các",
                    subject: "Địa lí",
                    grade: 7,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g7_s2_3",
                    title: "Chương 6: Châu Nam Cực",
                    summary: "Lịch sử khám phá; Đặc điểm tự nhiên và vấn đề bảo vệ môi trường châu Nam Cực. - - Đặc điểm: Châu lục lạnh nhất, khô nhất và lộng gió nhất thế giới, bề mặt bị bao phủ bởi một lớp băng khiên dày trung bình hơn 2000m.; - Dâ",
                    subject: "Địa lí",
                    grade: 7,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 8, 1), ("địa lý", 8, 1), ("địa", 8, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s1_1",
                    title: "Chương 1: Vị trí địa lí và phạm vi lãnh thổ Việt Nam",
                    summary: "Vị trí địa lí, phạm vi lãnh thổ và ảnh hưởng đối với tự nhiên, kinh tế - xã hội. - - Phạm vi lãnh thổ: Gồm 3 bộ phận: vùng đất (hơn 331 nghìn $km^2$), vùng trời và vùng biển rộng lớn thuộc Biển Đông.; - Đặc điểm vị trí:",
                    subject: "Địa lí",
                    grade: 8,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_2",
                    title: "Chương 2: Đặc điểm địa hình Việt Nam",
                    summary: "Các khu vực địa hình; Tác động của ngoại lực và con người đối với địa hình. - - Đặc điểm chung: Địa hình đồi núi chiếm diện tích lớn ($3/4$ diện tích là đồi núi thấp), đồng bằng chỉ chiếm $1/4$. Địa hình có hai hướng chí",
                    subject: "Địa lí",
                    grade: 8,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s1_3",
                    title: "Chương 3: Đặc điểm khí hậu Việt Nam",
                    summary: "Tính chất nhiệt đới ẩm gió mùa; Sự phân hóa khí hậu; Khí hậu và đời sống. - - Tính chất: Nhiệt độ trung bình năm cao (> $20^\\circ C$), lượng mưa lớn (1500 - 2000 mm/năm), độ ẩm không khí cao (> 80%). Khí hậu chia thành h",
                    subject: "Địa lí",
                    grade: 8,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 8, 2), ("địa lý", 8, 2), ("địa", 8, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g8_s2_1",
                    title: "Chương 4: Đặc điểm thủy văn Việt Nam",
                    summary: "Mạng lưới sông ngòi; Các hệ thống sông lớn; Vai trò của hồ, đầm và nước ngầm. - - Sông ngòi: Mạng lưới sông ngòi dày đặc nhưng chủ yếu là sông nhỏ, ngắn và dốc; lượng nước phong phú, giàu phù sa. Chế độ nước sông chia là",
                    subject: "Địa lí",
                    grade: 8,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_2",
                    title: "Chương 5: Đặc điểm đất và sinh vật Việt Nam",
                    summary: "Các nhóm đất chính; Đặc điểm sinh vật; Vấn đề bảo tồn đa dạng sinh học. - - Thổ nhưỡng: Ba nhóm đất chính gồm đất feralit (vùng đồi núi, chiếm diện tích lớn nhất, thích hợp cây công nghiệp), đất phù sa (vùng đồng bằng, t",
                    subject: "Địa lí",
                    grade: 8,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g8_s2_3",
                    title: "Chương 6: Biển đảo Việt Nam",
                    summary: "Đặc điểm tự nhiên vùng biển; Địa lí các đảo và quần đảo; Khai thác tài nguyên biển. - - Tự nhiên vùng biển: Vùng biển Việt Nam có tính chất nhiệt đới ẩm gió mùa hải dương; biển ấm quanh năm, chế độ thủy triều phức tạp (n",
                    subject: "Địa lí",
                    grade: 8,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 9, 1), ("địa lý", 9, 1), ("địa", 9, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s1_1",
                    title: "Chủ đề 1: Địa lí dân cư Việt Nam",
                    summary: "Cộng đồng các dân tộc; Dân số và gia tăng dân số; Phân bố dân cư và các loại hình quần cư; Lao động và việc làm. - - Dân tộc: Việt Nam là quốc gia đa dân tộc (54 dân tộc), người Kinh chiếm đa số. Các dân tộc luôn đoàn kế",
                    subject: "Địa lí",
                    grade: 9,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_2",
                    title: "Chủ đề 2: Các ngành kinh tế",
                    summary: "Chuyển dịch cơ cấu kinh tế; Địa lí ngành Nông nghiệp, Lâm nghiệp, Thủy sản; Địa lí ngành Công nghiệp. - - Chuyển dịch: Chuyển dịch rõ rệt từ khu vực I (Nông - lâm - thủy sản) sang khu vực II (Công nghiệp - xây dựng) và k",
                    subject: "Địa lí",
                    grade: 9,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s1_3",
                    title: "Chủ đề 3: Địa lí dịch vụ",
                    summary: "Vai trò, đặc điểm phát triển ngành dịch vụ; Giao thông vận tải và Bưu chính viễn thông; Thương mại và Du lịch. - - Giao thông & Viễn thông: Mạng lưới giao thông phát triển đầy đủ các loại hình (đường bộ, đường sắt, đường",
                    subject: "Địa lí",
                    grade: 9,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 9, 2), ("địa lý", 9, 2), ("địa", 9, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g9_s2_1",
                    title: "Chủ đề 4: Sự phân hóa lãnh thổ (Các vùng kinh tế Việt Nam)",
                    summary: "Vùng Trung du và miền núi Bắc Bộ; Vùng Đồng bằng sông Hồng; Vùng Bắc Trung Bộ và Duyên hải miền Trung. - - Trung du và miền núi Bắc Bộ: Thế mạnh về khai thác khoáng sản, thủy điện, trồng cây công nghiệp nguồn gốc cận nhi",
                    subject: "Địa lí",
                    grade: 9,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_2",
                    title: "Chủ đề 4: Sự phân hóa lãnh thổ (Tiếp theo)",
                    summary: "Vùng Tây Nguyên; Vùng Đông Nam Bộ; Vùng Đồng bằng sông Cửu Long. - - Tây Nguyên: Vùng duy nhất không giáp biển; thế mạnh lớn nhất là đất đỏ feralit trên đá ba-zan thích hợp phát triển cây công nghiệp dài ngày (cà phê, ca",
                    subject: "Địa lí",
                    grade: 9,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g9_s2_3",
                    title: "Chủ đề 5: Phát triển tổng hợp kinh tế và bảo vệ tài nguyên, môi trường biển - đảo",
                    summary: "Các ngành kinh tế biển; Bảo vệ tài nguyên và môi trường biển - đảo. - - Kinh tế biển: Phát triển tổng hợp 4 ngành nghề chính: Khai thác hải sản; Khai thác khoáng sản biển (dầu khí, muối); Du lịch biển - đảo; Giao thông v",
                    subject: "Địa lí",
                    grade: 9,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 10, 1), ("địa lý", 10, 1), ("địa", 10, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s1_1",
                    title: "Chương 1: Sử dụng bản đồ",
                    summary: "Môn Địa lí với định hướng nghề nghiệp; Các phương pháp biểu hiện các đối tượng địa lí trên bản đồ; Sử dụng bản đồ trong học tập và đời sống. - - Định hướng: Hiểu rõ vai trò của môn Địa lí đối với cuộc sống và các ngành n",
                    subject: "Địa lí",
                    grade: 10,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_2",
                    title: "Chương 2: Trái Đất",
                    summary: "Nguồn gốc hình thành Trái Đất; Vỏ Trái Đất và vật liệu cấu tạo vỏ Trái Đất; Thuyết kiến tạo mảng. - - Hình thành: Khái quát về nguồn gốc hình thành Trái Đất và hệ Mặt Trời.; - Kiến thức lõi: Cấu tạo vỏ Trái Đất cấu thành",
                    subject: "Địa lí",
                    grade: 10,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_3",
                    title: "Chương 3: Thạch quyển",
                    summary: "Tác động của nội lực và ngoại lực đến địa hình bề mặt Trái Đất. - - Nội lực: Lực sinh ra từ bên trong Trái Đất, xu hướng làm địa hình gồ ghề (gây ra các vận động nâng lên, hạ xuống, uốn nếp, đứt gãy).; - Ngoại lực: Lực s",
                    subject: "Địa lí",
                    grade: 10,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_4",
                    title: "Chương 4: Khí quyển",
                    summary: "Cấu trúc của khí quyển; Sự phân bố nhiệt độ không khí; Khí áp và gió; Mưa. - - Nhiệt độ: Phân bố phụ thuộc vào vĩ độ địa lí, lục địa - đại dương và địa hình.; - Khí áp & Gió: Nguyên nhân thay đổi khí áp; các đai khí áp t",
                    subject: "Địa lí",
                    grade: 10,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s1_5",
                    title: "Chương 5: Thủy quyển",
                    summary: "Thành phần của thủy quyển; Nước trên lục địa; Biển và đại dương. - - Nước lục địa: Chế độ nước sông (phụ thuộc nguồn cung cấp nước: mưa, băng tuyết tan, nước ngầm) và vai trò của hồ, đầm, nước ngầm, băng hà.; - Biển & Đạ",
                    subject: "Địa lí",
                    grade: 10,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 10, 2), ("địa lý", 10, 2), ("địa", 10, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g10_s2_1",
                    title: "Chương 6: Thổ nhưỡng quyển và sinh quyển",
                    summary: "Đất và các nhân tố hình thành đất; Sinh quyển và các nhân tố ảnh hưởng đến sự phát triển, phân bố của sinh vật. - - Đất: Khái niệm thổ nhưỡng và thổ nhưỡng quyển. Nắm vững 5 nhân tố hình thành đất: đá mẹ, khí hậu, sinh v",
                    subject: "Địa lí",
                    grade: 10,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_2",
                    title: "Chương 7: Địa lí dân cư",
                    summary: "Gia tăng dân số; Cơ cấu dân số; Phân bố dân cư và đô thị hóa. - - Gia tăng dân số: Phân biệt gia tăng tự nhiên (sinh - tử) và gia tăng cơ học (di cư), ảnh hưởng của gia tăng dân số tới phát triển kinh tế.; - Cơ cấu: Cơ c",
                    subject: "Địa lí",
                    grade: 10,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_3",
                    title: "Chương 8: Các nguồn lực phát triển kinh tế và một số tiêu chí đánh giá sự phát triển kinh tế",
                    summary: "Nguồn lực phát triển kinh tế; Cơ cấu nền kinh tế; Một số tiêu chí đánh giá nền kinh tế. - - Nguồn lực: Phân loại nguồn lực vị trí địa lí, nguồn lực tự nhiên, nguồn lực kinh tế - xã hội.; - Cơ cấu kinh tế: Gồm cơ cấu ngàn",
                    subject: "Địa lí",
                    grade: 10,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_4",
                    title: "Chương 9: Địa lí các ngành kinh tế",
                    summary: "Địa lí ngành Nông nghiệp, Lâm nghiệp, Thủy sản; Địa lí ngành Công nghiệp; Địa lí ngành Dịch vụ. - - Nông - Lâm - Thủy sản: Đặc điểm, vai trò và các nhân tố ảnh hưởng; tình hình phát triển và phân bố các ngành trồng trọt,",
                    subject: "Địa lí",
                    grade: 10,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g10_s2_5",
                    title: "Chương 10: Phát triển bền vững và tăng trưởng xanh",
                    summary: "Môi trường và tài nguyên thiên nhiên; Phát triển bền vững và tăng trưởng xanh. - - Môi trường & Tài nguyên: Khái niệm, vai trò và chức năng của môi trường; phân loại tài nguyên thiên nhiên (khả năng bị hao kiệt và không",
                    subject: "Địa lí",
                    grade: 10,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 11, 1), ("địa lý", 11, 1), ("địa", 11, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s1_1",
                    title: "Phần 1: Khái quát nền kinh tế - xã hội thế giới",
                    summary: "Sự phân chia thành các nhóm nước; Toàn cầu hóa và khu vực hóa kinh tế; Một số vấn đề an ninh toàn cầu. - - Nhóm nước: Phân biệt các nước phát triển và đang phát triển dựa trên chỉ số thu nhập (GNI/người), chỉ số phát tri",
                    subject: "Địa lí",
                    grade: 11,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_2",
                    title: "Phần 2: Địa lí khu vực và quốc gia - Khu vực Mỹ La-tinh",
                    summary: "Vị trí địa lí, điều kiện tự nhiên, dân cư, xã hội và tình hình phát triển kinh tế khu vực Mỹ La-tinh. - - Tự nhiên: Giàu tài nguyên khoáng sản (kim loại màu, dầu khí) và tài nguyên rừng (rừng A-ma-zôn), nhưng địa hình ch",
                    subject: "Địa lí",
                    grade: 11,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_3",
                    title: "Liên minh Châu Âu (EU)",
                    summary: "Vị trí địa lí, điều kiện tự nhiên; Quy mô, mục đích và thể chế hoạt động; Vị thế kinh tế của EU. - - Liên kết đỉnh cao: Là tổ chức liên kết khu vực thành công và toàn diện nhất thế giới trên các mặt: kinh tế, luật pháp,",
                    subject: "Địa lí",
                    grade: 11,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s1_4",
                    title: "Khu vực Đông Nam Á",
                    summary: "Vị trí địa lí, tự nhiên, dân cư, xã hội ĐNÁ; Địa lí kinh tế và Hiệp hội các quốc gia ĐNÁ (ASEAN). - - Tự nhiên: Chia thành ĐNÁ lục địa và ĐNÁ hải đảo. Khí hậu nhiệt đới ẩm gió mùa, mạng lưới sông ngòi dày đặc, giàu tài n",
                    subject: "Địa lí",
                    grade: 11,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 11, 2), ("địa lý", 11, 2), ("địa", 11, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g11_s2_1",
                    title: "Hợp chủng quốc Hoa Kỳ (Mỹ)",
                    summary: "Vị trí địa lí, điều kiện tự nhiên; Dân cư và xã hội; Các ngành kinh tế lớn và sự phân hóa lãnh thổ. - - Tự nhiên: Lãnh thổ rộng lớn, giàu tài nguyên (đất phù sa, than đá, dầu mỏ). Phân hóa thành 3 vùng tự nhiên: Vùng phí",
                    subject: "Địa lí",
                    grade: 11,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_2",
                    title: "Liên bang Nga",
                    summary: "Vị trí địa lí, điều kiện tự nhiên; Dân cư và xã hội; Tình hình phát triển kinh tế và các vùng kinh tế. - - Tự nhiên: Quốc gia có diện tích lớn nhất thế giới, giàu tài nguyên bậc nhất (dầu mỏ, khí tự nhiên, than đá, rừng",
                    subject: "Địa lí",
                    grade: 11,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_3",
                    title: "Cộng hòa Nhân dân Trung Hoa (Trung Quốc)",
                    summary: "Vị trí địa lí, tự nhiên; Dân cư và xã hội; Các ngành kinh tế; Sự phân hóa lãnh thổ Đông - Tây. - - Tự nhiên: Địa hình phân hóa rõ rệt: Miền Đông (đồng bằng hạ lưu các sông lớn, khí hậu gió mùa ẩm thuận lợi) và Miền Tây (",
                    subject: "Địa lí",
                    grade: 11,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g11_s2_4",
                    title: "Nhật Bản & Cộng hòa Nam Phi",
                    summary: "Khái quát đặc điểm tự nhiên, dân cư và kinh tế của Nhật Bản (châu Á) và Cộng hòa Nam Phi (châu Phi). - - Nhật Bản: Quốc gia hải đảo, nghèo tài nguyên, nhiều thiên tai (động đất, núi lửa) và có dân số già nhất thế giới. T",
                    subject: "Địa lí",
                    grade: 11,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 12, 1), ("địa lý", 12, 1), ("địa", 12, 1):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s1_1",
                    title: "Chương 1: Địa lí tự nhiên Việt Nam",
                    summary: "Vị trí địa lí và phạm vi lãnh thổ; Lịch sử hình thành và phát triển lãnh thổ; Đặc điểm chung của tự nhiên; Vấn đề sử dụng và bảo vệ tự nhiên. - - Vị trí & Lãnh thổ: Ý nghĩa tự nhiên, kinh tế, văn hóa - xã hội và quốc phò",
                    subject: "Địa lí",
                    grade: 12,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_2",
                    title: "Chương 2: Địa lí dân cư Việt Nam",
                    summary: "Đặc điểm dân số và phân bố dân cư; Lao động và việc làm; Đô thị hóa. - - Dân số: Quốc gia đông dân, đa dân tộc; dân số còn tăng nhưng tốc độ đã giảm; cơ cấu dân số đang chuyển dịch từ 'dân số vàng' sang già hóa.; - Phân",
                    subject: "Địa lí",
                    grade: 12,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s1_3",
                    title: "Chương 3: Địa lí các ngành kinh tế (Phần Nông - Lâm - Thủy sản)",
                    summary: "Chuyển dịch cơ cấu kinh tế; Địa lí ngành nông nghiệp, lâm nghiệp và thủy sản. - - Chuyển dịch cơ cấu: Chuyển dịch rõ rệt theo ngành (giảm tỷ trọng khu vực I, tăng khu vực II và III), theo thành phần kinh tế (phát triển k",
                    subject: "Địa lí",
                    grade: 12,
                    semester: 1,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        case ("địa lí", 12, 2), ("địa lý", 12, 2), ("địa", 12, 2):
            return [
                TheoryTopicItem(
                    id: "trithu_g12_s2_1",
                    title: "Chương 3: Địa lí các ngành kinh tế (Tiếp theo - Công nghiệp & Dịch vụ)",
                    summary: "Địa lí ngành Công nghiệp; Địa lí ngành Dịch vụ. - - Công nghiệp: Cơ cấu công nghiệp chuyển dịch theo hướng hiện đại, tăng tỷ trọng các ngành công nghiệp chế biến - chế tạo và công nghiệp công nghệ cao. Phát triển các vùn",
                    subject: "Địa lí",
                    grade: 12,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_2",
                    title: "Chương 4: Địa lí các vùng kinh tế",
                    summary: "Vùng Trung du và miền núi Bắc Bộ; Vùng Đồng bằng sông Hồng; Vùng Bắc Trung Bộ; Vùng Duyên hải Nam Trung Bộ. - - Trung du và miền núi Bắc Bộ: Khai thác các thế mạnh đặc thù: Khai thác và chế biến khoáng sản, thủy điện, tr",
                    subject: "Địa lí",
                    grade: 12,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_3",
                    title: "Chương 4: Địa lí các vùng kinh tế (Tiếp theo)",
                    summary: "Vùng Tây Nguyên; Vùng Đông Nam Bộ; Vùng Đồng bằng sông Cửu Long; Các vùng kinh tế trọng điểm. - - Tây Nguyên: Phát triển các vùng chuyên canh cây công nghiệp lâu năm quy mô lớn (cà phê, cao su, chè, hồ tiêu) trên đất ba-",
                    subject: "Địa lí",
                    grade: 12,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "trithu_g12_s2_4",
                    title: "Chương 5: Địa lí địa phương (Tỉnh / Thành phố)",
                    summary: "Tìm hiểu địa lí tỉnh hoặc thành phố nơi học sinh đang sinh sống. - - Phân tích các đặc điểm tự nhiên, dân cư, tình hình phát triển các ngành kinh tế cụ thể của địa phương để áp dụng kiến thức lý thuyết vào thực tiễn sản",
                    subject: "Địa lí",
                    grade: 12,
                    semester: 2,
                    videoId: "Wh5gqPrJMQ4",
                    channelName: "Cô Lê Huệ • Địa Lí VietJack",
                    estimatedTime: "25 phút"
                ),
            ]
        default:
            return []
        }
    }
}
