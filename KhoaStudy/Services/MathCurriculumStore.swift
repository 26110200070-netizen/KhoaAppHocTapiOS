import Foundation

/// Kho dữ liệu kiến thức môn Toán chuẩn hóa từ tài liệu biên soạn trithuctoan (Lớp 6 - Lớp 12, Full HK1 & HK2)
struct MathCurriculumStore {
    static let shared = MathCurriculumStore()
    
    private init() {}
    
    func getMathTopics(grade: Int, semester: Int) -> [TheoryTopicItem] {
        switch (grade, semester) {
        case (6, 1):
            return [
                TheoryTopicItem(
                    id: "math_g6_s1_1",
                    title: "Tập hợp và Số tự nhiên",
                    summary: "Tập hợp và phần tử: Ký hiệu thuộc ($\\in$) và không thuộc ($\\notin$). Cách viết một tập hợp bằng cách liệt kê phần tử hoặc chỉ ra tính chất đặc trưng.; Tập hợ...",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "33 phút"
                ),
                TheoryTopicItem(
                    id: "math_g6_s1_2",
                    title: "Tính chất chia hết trong tập hợp số tự nhiên",
                    summary: "Quan hệ chia hết: Khái niệm ước và bội. Cách tìm tập hợp các ước Ư($a$) và tập hợp các bội B($a$).; Tính chất chia hết của một tổng: Nếu tất cả các số hạng đ...",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "27 phút"
                ),
                TheoryTopicItem(
                    id: "math_g6_s1_3",
                    title: "Số nguyên",
                    summary: "Tập hợp số nguyên ($\\mathbb{Z}$): Trục số nguyên, số đối của một số nguyên. Khái niệm số nguyên âm, số nguyên dương và số 0. So sánh hai số nguyên.; Các phép...",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "29 phút"
                ),
                TheoryTopicItem(
                    id: "math_g6_s1_4",
                    title: "Hình học trực quan (Hình học phẳng cơ bản)",
                    summary: "Tam giác đều, Hình vuông, Hình lục giác đều: Nhận biết các đặc điểm cơ bản về cạnh, góc, đường chéo và cách vẽ bằng dụng cụ học tập.; Hình chữ nhật, Hình tho...",
                    subject: "Toán",
                    grade: 6,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "23 phút"
                ),
            ]
        case (6, 2):
            return [
                TheoryTopicItem(
                    id: "math_g6_s2_1",
                    title: "Phân số",
                    summary: "Khái niệm phân số: Mở rộng phân số với tử và mẫu là các số nguyên ($\\frac{a}{b}$ với $a, b \\in \\mathbb{Z}, b \\neq 0$). Hai phân số bằng nhau.; Tính chất cơ b...",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "31 phút"
                ),
                TheoryTopicItem(
                    id: "math_g6_s2_2",
                    title: "Số thập phân",
                    summary: "Khái niệm số thập phân: Số thập phân âm, số thập phân dương. Số đối của số thập phân.; Các phép tính với số thập phân: Cộng, trừ, nhân, chia số thập phân (tu...",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "23 phút"
                ),
                TheoryTopicItem(
                    id: "math_g6_s2_3",
                    title: "Hình học phẳng (Điểm, Đường thẳng, Góc)",
                    summary: "Điểm, Đường thẳng: Điểm thuộc đường thẳng, điểm không thuộc đường thẳng. Ba điểm thẳng hàng, ba điểm không thẳng hàng. Hai đường thẳng cắt nhau, hai đường th...",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "29 phút"
                ),
                TheoryTopicItem(
                    id: "math_g6_s2_4",
                    title: "Một số yếu tố Thống kê và Xác suất",
                    summary: "Thu thập và phân loại dữ liệu: Cách thu thập dữ liệu (quan sát, lập bảng hỏi). Dữ liệu là số (số liệu) và dữ liệu không phải là số.; Biểu diễn dữ liệu:; Bảng...",
                    subject: "Toán",
                    grade: 6,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "29 phút"
                ),
            ]
        case (7, 1):
            return [
                TheoryTopicItem(
                    id: "math_g7_s1_1",
                    title: "Số hữu tỉ",
                    summary: "Tập hợp số hữu tỉ ($\\mathbb{Q}$): Định nghĩa số hữu tỉ là số viết được dưới dạng phân số $\\frac{a}{b}$ với $a, b \\in \\mathbb{Z}, b \\neq 0$. Biểu diễn số hữu ...",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "35 phút"
                ),
                TheoryTopicItem(
                    id: "math_g7_s1_2",
                    title: "Số thực",
                    summary: "Số thập phân hữu hạn và số thập phân vô hạn tuần hoàn: Cách nhận biết và viết một phân số dưới dạng số thập phân.; Số vô tỉ: Định nghĩa số vô tỉ là số viết đ...",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "23 phút"
                ),
                TheoryTopicItem(
                    id: "math_g7_s1_3",
                    title: "Tỉ lệ thức và Đại lượng tỉ lệ",
                    summary: "Tỉ lệ thức: Định nghĩa $\\frac{a}{b} = \\frac{c}{d}$. Tính chất cơ bản của tỉ lệ thức ($a \\cdot d = b \\cdot c$).; Tính chất của dãy tỉ số bằng nhau: $\\frac{a}{...",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "23 phút"
                ),
                TheoryTopicItem(
                    id: "math_g7_s1_4",
                    title: "Hình khối trong thực tiễn",
                    summary: "Hình lăng trụ đứng tam giác, Hình lăng trụ đứng tứ giác:; Mô tả định dạng, nhận biết đỉnh, cạnh, mặt đáy, mặt bên.; Công thức tính Diện tích xung quanh ($S_{...",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "21 phút"
                ),
                TheoryTopicItem(
                    id: "math_g7_s1_5",
                    title: "Góc và Đường thẳng song song",
                    summary: "Góc ở vị trí đặc biệt: Hai góc kề bù (có tổng bằng $180^\\circ$), hai góc đối đỉnh (thì bằng nhau). Tia phân giác của một góc.; Hai đường thẳng song song:; Dấ...",
                    subject: "Toán",
                    grade: 7,
                    semester: 1,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "25 phút"
                ),
            ]
        case (7, 2):
            return [
                TheoryTopicItem(
                    id: "math_g7_s2_1",
                    title: "Biểu thức đại số và Đa thức một biến",
                    summary: "Biểu thức đại số: Khái niệm biểu thức đại số, tính giá trị của một biểu thức đại số tại giá trị cho trước của biến.; Đa thức một biến:; Định nghĩa, thu gọn đ...",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "33 phút"
                ),
                TheoryTopicItem(
                    id: "math_g7_s2_2",
                    title: "Tam giác và Các trường hợp bằng nhau",
                    summary: "Tổng các góc trong một tam giác: Bằng $180^\\circ$.; Hai tam giác bằng nhau: Định nghĩa hai tam giác bằng nhau.; Ba trường hợp bằng nhau của tam giác:",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "31 phút"
                ),
                TheoryTopicItem(
                    id: "math_g7_s2_3",
                    title: "Quan hệ giữa các yếu tố trong tam giác",
                    summary: "Quan hệ giữa góc và cạnh đối diện: Trong một tam giác, góc đối diện với cạnh lớn hơn là góc lớn hơn và ngược lại.; Quan hệ giữa đường vuông góc và đường xiên...",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "21 phút"
                ),
                TheoryTopicItem(
                    id: "math_g7_s2_4",
                    title: "Các đường đồng quy trong tam giác",
                    summary: "Đường trung tuyến: Ba đường trung tuyến đồng quy tại một điểm gọi là Trọng tâm. Trọng tâm cách mỗi đỉnh một khoảng bằng $\\frac{2}{3}$ độ dài đường trung tuyế...",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "23 phút"
                ),
                TheoryTopicItem(
                    id: "math_g7_s2_5",
                    title: "Thu thập, biểu diễn và phân tích dữ liệu",
                    summary: "Biểu đồ đoạn thẳng: Đọc, phân tích thông tin và vẽ biểu đồ đoạn thẳng biểu diễn xu hướng thay đổi của dữ liệu theo thời gian.; Biểu đồ hình quạt tròn: Đọc, p...",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "19 phút"
                ),
                TheoryTopicItem(
                    id: "math_g7_s2_6",
                    title: "Biến cố và Xác suất của biến cố",
                    summary: "Làm quen với biến cố: Khái niệm biến cố chắc chắn, biến cố không thể và biến cố ngẫu nhiên.; Xác suất của biến cố ngẫu nhiên: Tính xác suất của một số biến c...",
                    subject: "Toán",
                    grade: 7,
                    semester: 2,
                    videoId: "IGp-J96BbTU",
                    channelName: "Học Toán Cùng Thầy Kenka - Tiến Sĩ Trần Hoan",
                    estimatedTime: "19 phút"
                ),
            ]
        case (8, 1):
            return [
                TheoryTopicItem(
                    id: "math_g8_s1_1",
                    title: "Đa thức nhiều biến",
                    summary: "Đơn thức và đa thức nhiều biến: Khái niệm đơn thức, đa thức nhiều biến. Đơn thức đồng dạng. Thu gọn và tìm bậc của đa thức.; Các phép tính với đa thức:; Cộng...",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "Thầy Lê Ngọc Diên - Toán THCS",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "math_g8_s1_2",
                    title: "Hằng đẳng thức đáng nhớ",
                    summary: "7 Hằng đẳng thức đáng nhớ:; Phân tích đa thức thành nhân tử: Các phương pháp cơ bản gồm đặt nhân tử chung, dùng hằng đẳng thức, nhóm hạng tử, và phối hợp nhi...",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "Thầy Lê Ngọc Diên - Toán THCS",
                    estimatedTime: "19 phút"
                ),
                TheoryTopicItem(
                    id: "math_g8_s1_3",
                    title: "Phân thức đại số",
                    summary: "Khái niệm phân thức đại số: Biểu thức có dạng $\\frac{A}{B}$ với $A, B$ là các đa thức và $B$ khác đa thức 0. Điều kiện xác định và giá trị của phân thức.; Tí...",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "Thầy Lê Ngọc Diên - Toán THCS",
                    estimatedTime: "21 phút"
                ),
                TheoryTopicItem(
                    id: "math_g8_s1_4",
                    title: "Hình khối trong thực tiễn",
                    summary: "Hình chóp tam giác đều và Hình chóp tứ giác đều:; Nhận biết đỉnh, cạnh bên, mặt bên, mặt đáy, đường cao, trung đoạn của hình chóp đều.; Công thức tính Diện t...",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "Thầy Lê Ngọc Diên - Toán THCS",
                    estimatedTime: "23 phút"
                ),
                TheoryTopicItem(
                    id: "math_g8_s1_5",
                    title: "Tứ giác",
                    summary: "Tứ giác: Định nghĩa tứ giác lồi. Tổng các góc của một tứ giác bằng $360^\\circ$.; Các hình tứ giác đặc biệt: Định nghĩa, tính chất và dấu hiệu nhận biết của:;...",
                    subject: "Toán",
                    grade: 8,
                    semester: 1,
                    videoId: "svZSkXxCnbs",
                    channelName: "Thầy Lê Ngọc Diên - Toán THCS",
                    estimatedTime: "29 phút"
                ),
            ]
        case (8, 2):
            return [
                TheoryTopicItem(
                    id: "math_g8_s2_1",
                    title: "Hàm số và Đồ thị",
                    summary: "Khái niệm hàm số: Định nghĩa hàm số, biến số. Giá trị của hàm số $y = f(x)$ tại một điểm.; Tọa độ phẳng: Hệ trục tọa độ Oxy, tọa độ của một điểm $(x; y)$.; H...",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "Thầy Lê Ngọc Diên - Toán THCS",
                    estimatedTime: "31 phút"
                ),
                TheoryTopicItem(
                    id: "math_g8_s2_2",
                    title: "Phương trình bậc nhất một ẩn",
                    summary: "Khái niệm phương trình bậc nhất một ẩn: Phương trình có dạng $ax + b = 0$ ($a \\neq 0$).; Cách giải phương trình: Vận dụng quy tắc chuyển vế và quy tắc nhân v...",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "Thầy Lê Ngọc Diên - Toán THCS",
                    estimatedTime: "21 phút"
                ),
                TheoryTopicItem(
                    id: "math_g8_s2_3",
                    title: "Định lý Thales trong tam giác",
                    summary: "Định lý Thales (Thuận và Đảo): Nếu một đường thẳng song song với một cạnh của tam giác và cắt hai cạnh còn lại thì nó định ra trên hai cạnh đó những đoạn thẳ...",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "Thầy Lê Ngọc Diên - Toán THCS",
                    estimatedTime: "21 phút"
                ),
                TheoryTopicItem(
                    id: "math_g8_s2_4",
                    title: "Tam giác đồng dạng",
                    summary: "Khái niệm: Định nghĩa hai tam giác đồng dạng, tỉ số đồng dạng $k$.; Các trường hợp đồng dạng của hai tam giác thường:; Cạnh - cạnh - cạnh (c.c.c).",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "Thầy Lê Ngọc Diên - Toán THCS",
                    estimatedTime: "29 phút"
                ),
                TheoryTopicItem(
                    id: "math_g8_s2_5",
                    title: "Thống kê",
                    summary: "Thu thập và lựa chọn dữ liệu: Lựa chọn phương pháp thu thập dữ liệu thích hợp. Biểu diễn dữ liệu bằng các dạng biểu đồ đã học.; Biểu đồ đoạn thẳng và Biểu đồ...",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "Thầy Lê Ngọc Diên - Toán THCS",
                    estimatedTime: "19 phút"
                ),
                TheoryTopicItem(
                    id: "math_g8_s2_6",
                    title: "Xác suất",
                    summary: "Xác suất của biến cố ngẫu nhiên: Định nghĩa xác suất của biến cố trong các mô hình đồng khả năng:",
                    subject: "Toán",
                    grade: 8,
                    semester: 2,
                    videoId: "svZSkXxCnbs",
                    channelName: "Thầy Lê Ngọc Diên - Toán THCS",
                    estimatedTime: "17 phút"
                ),
            ]
        case (9, 1):
            return [
                TheoryTopicItem(
                    id: "math_g9_s1_1",
                    title: "Căn bậc hai và Căn bậc ba",
                    summary: "Căn bậc hai số học: Định nghĩa căn bậc hai số học của số không âm $a$ là số không âm $x$ sao cho $x^2 = a$ (Ký hiệu: $\\sqrt{a}$).; Điều kiện xác định: Căn th...",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "23 phút"
                ),
                TheoryTopicItem(
                    id: "math_g9_s1_2",
                    title: "Các phép biến đổi căn thức bậc hai",
                    summary: "Khai phương một tích và Nhân các căn thức bậc hai: $\\sqrt{A \\cdot B} = \\sqrt{A} \\cdot \\sqrt{B}$ (với $A \\ge 0, B \\ge 0$).; Khai phương một thương và Chia các...",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "27 phút"
                ),
                TheoryTopicItem(
                    id: "math_g9_s1_3",
                    title: "Phương trình quy về phương trình bậc nhất một ẩn",
                    summary: "Phương trình tích: Phương trình dạng $A(x) \\cdot B(x) = 0 \\Leftrightarrow A(x) = 0$ hoặc $B(x) = 0$.; Phương trình chứa ẩn ở mẫu: Các bước giải bao gồm tìm đ...",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "19 phút"
                ),
                TheoryTopicItem(
                    id: "math_g9_s1_4",
                    title: "Hệ hai phương trình bậc nhất hai ẩn",
                    summary: "Khái niệm: Hệ có dạng $\\begin{cases} ax + by = c \\\\ a'x + b'y = c' \\end{cases}$; Phương pháp giải:; Phương pháp thế.",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "math_g9_s1_5",
                    title: "Hệ thức lượng trong tam giác vuông",
                    summary: "Các hệ thức về cạnh và đường cao: Cho tam giác $ABC$ vuông tại $A$, đường cao $AH$, gọi b, c là 2 cạnh góc vuông; a là cạnh huyền; b', c' là hình chiếu của b...",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Thầy Nguyễn Phan Tiến - Toán 9",
                    estimatedTime: "29 phút"
                ),
                TheoryTopicItem(
                    id: "math_g9_s1_6",
                    title: "Đường tròn (Phần cơ bản)",
                    summary: "Khái niệm đường tròn: Định nghĩa, sự xác định đường tròn, tính chất đối xứng của đường tròn.; Quan hệ đường kính và dây cung: Đường kính vuông góc với một dâ...",
                    subject: "Toán",
                    grade: 9,
                    semester: 1,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Thầy Nguyễn Phan Tiến - Toán 9",
                    estimatedTime: "23 phút"
                ),
            ]
        case (9, 2):
            return [
                TheoryTopicItem(
                    id: "math_g9_s2_1",
                    title: "Hàm số $y = ax^2$ ($a \\neq 0$) và Phương trình bậc hai một ẩn",
                    summary: "Hàm số $y = ax^2$: Tính chất đồng biến, nghịch biến tùy thuộc vào dấu của hệ số $a$. Đồ thị hàm số là một đường Parabol nhận trục Oy làm trục đối xứng.; Phươ...",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "29 phút"
                ),
                TheoryTopicItem(
                    id: "math_g9_s2_2",
                    title: "Góc với đường tròn",
                    summary: "Góc ở tâm: Số đo của góc ở tâm bằng số đo của cung bị chắn.; Góc nội tiếp: Số đo của góc nội tiếp bằng nửa số đo của cung bị chắn. Góc nội tiếp chắn nửa đườn...",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Thầy Nguyễn Phan Tiến - Toán 9",
                    estimatedTime: "27 phút"
                ),
                TheoryTopicItem(
                    id: "math_g9_s2_3",
                    title: "Hình trụ - Hình nón - Hình cầu",
                    summary: "Hình trụ: Công thức tính Diện tích xung quanh ($S_{xq} = 2\\pi Rh$) và Thể tích ($V = \\pi R^2h$).; Hình nón: Công thức tính Diện tích xung quanh ($S_{xq} = \\p...",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Thầy Nguyễn Phan Tiến - Toán 9",
                    estimatedTime: "21 phút"
                ),
                TheoryTopicItem(
                    id: "math_g9_s2_4",
                    title: "Tần suất và Xác suất nâng cao",
                    summary: "Bảng tần suất và Tần suất tương đối: Phân tích sâu hơn số liệu thống kê.; Xác suất bằng sơ đồ hình cây: Sử dụng sơ đồ hình cây để liệt kê toàn bộ các kết quả...",
                    subject: "Toán",
                    grade: 9,
                    semester: 2,
                    videoId: "5ykgVSHPbIo",
                    channelName: "Thầy Nguyễn Phan Tiến - Toán 9",
                    estimatedTime: "19 phút"
                ),
            ]
        case (10, 1):
            return [
                TheoryTopicItem(
                    id: "math_g10_s1_1",
                    title: "Mệnh đề và Tập hợp",
                    summary: "Mệnh đề toán học: Khái niệm mệnh đề, mệnh đề phủ định ($\\overline{P}$), mệnh đề kéo theo ($P \\Rightarrow Q$), mệnh đề tương đương ($P \\Leftrightarrow Q$). Mệ...",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "21 phút"
                ),
                TheoryTopicItem(
                    id: "math_g10_s1_2",
                    title: "Hàm số bậc hai và Đồ thị",
                    summary: "Hàm số và đồ thị: Khái niệm hàm số, tập xác định, tập giá trị. Sự biến thiên của hàm số (đồng biến, nghịch biến trên một khoảng).; Hàm số bậc hai: Hàm số dạn...",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "60Kg5b_mSZQ",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "27 phút"
                ),
                TheoryTopicItem(
                    id: "math_g10_s1_3",
                    title: "Hệ phương trình bậc nhất ba ẩn",
                    summary: "Khái niệm: Hệ phương trình gồm 3 phương trình bậc nhất có dạng tổng quát đối với 3 ẩn $x, y, z$.; Phương pháp giải: Phương pháp Gauss (biến đổi ma trận/hệ ph...",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "60Kg5b_mSZQ",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "19 phút"
                ),
                TheoryTopicItem(
                    id: "math_g10_s1_4",
                    title: "Vectơ và các phép toán",
                    summary: "Khái niệm vectơ: Định nghĩa vectơ, vectơ-không ($\\vec{0}$), hai vectơ cùng phương, cùng hướng, độ dài của vectơ, hai vectơ bằng nhau.; Các phép toán vectơ:; ...",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "27 phút"
                ),
                TheoryTopicItem(
                    id: "math_g10_s1_5",
                    title: "Tích vô hướng của hai vectơ và ứng dụng",
                    summary: "Giá trị lượng giác của một góc từ $0^\\circ$ đến $180^\\circ$: Định nghĩa $s\\text{in}, cos, tan, cot$ trên nửa đường tròn đơn vị. Hệ thức lượng cơ bản giữa các...",
                    subject: "Toán",
                    grade: 10,
                    semester: 1,
                    videoId: "60Kg5b_mSZQ",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "25 phút"
                ),
            ]
        case (10, 2):
            return [
                TheoryTopicItem(
                    id: "math_g10_s2_1",
                    title: "Dấu của tam thức bậc hai và Phương trình quy về bậc hai",
                    summary: "Tam thức bậc hai: Biểu thức dạng $f(x) = ax^2 + bx + c$ ($a \\neq 0$).; Định lý về dấu của tam thức bậc hai: Dựa vào biệt thức $\\Delta$ và hệ số $a$ để xét dấ...",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "60Kg5b_mSZQ",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "29 phút"
                ),
                TheoryTopicItem(
                    id: "math_g10_s2_2",
                    title: "Đại số tổ hợp",
                    summary: "Quy tắc đếm cơ bản: Quy tắc cộng (các hành động độc lập) và Quy tắc nhân (các hành động liên tiếp/công đoạn).; Hoán vị, Chỉnh hợp, Tổ hợp:; Hoán vị của $n$ p...",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "27 phút"
                ),
                TheoryTopicItem(
                    id: "math_g10_s2_3",
                    title: "Đường thẳng trong mặt phẳng tọa độ",
                    summary: "Vectơ chỉ phương (VTCP) và Vectơ pháp tuyến (VPTN) của đường thẳng.; Các dạng phương trình đường thẳng:; Phương trình tham số (dựa vào 1 điểm và 1 VTCP).",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Thầy Nguyễn Phan Tiến - Toán 10 SGK Mới",
                    estimatedTime: "27 phút"
                ),
                TheoryTopicItem(
                    id: "math_g10_s2_4",
                    title: "Đường tròn trong mặt phẳng tọa độ",
                    summary: "Phương trình đường tròn:; Dạng chính tắc: $(x - a)^2 + (y - b)^2 = R^2$ với tâm $I(a; b)$ và bán kính $R$.; Dạng tổng quát: $x^2 + y^2 - 2ax - 2by + c = 0$ v...",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Thầy Nguyễn Phan Tiến - Toán 10 SGK Mới",
                    estimatedTime: "23 phút"
                ),
                TheoryTopicItem(
                    id: "math_g10_s2_5",
                    title: "Ba đường Conic",
                    summary: "Đường Elip: Phương trình chính tắc $\\frac{x^2}{a^2} + \\frac{y^2}{b^2} = 1$ ($a > b > 0$). Xác định các yếu tố: đỉnh, tiêu điểm, tiêu cự ($2c = 2\\sqrt{a^2 - b...",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Thầy Nguyễn Phan Tiến - Toán 10 SGK Mới",
                    estimatedTime: "21 phút"
                ),
                TheoryTopicItem(
                    id: "math_g10_s2_6",
                    title: "Thống kê và Xác suất sơ cấp",
                    summary: "Tính xác suất theo định nghĩa cổ điển: Sử dụng các công cụ của đại số tổ hợp (quy tắc đếm, hoán vị, chỉnh hợp, tổ hợp) để xác định số phần tử của không gian ...",
                    subject: "Toán",
                    grade: 10,
                    semester: 2,
                    videoId: "xtYqUS8_pZM",
                    channelName: "Thầy Nguyễn Phan Tiến - Toán 10 SGK Mới",
                    estimatedTime: "17 phút"
                ),
            ]
        case (11, 1):
            return [
                TheoryTopicItem(
                    id: "math_g11_s1_1",
                    title: "Góc lượng giác và Giá trị lượng giác",
                    summary: "Góc lượng giác: Khái niệm góc lượng giác, đơn vị đo góc (độ và radian), độ dài cung tròn. Khái niệm đường tròn lượng giác.; Giá trị lượng giác: Định nghĩa $\\...",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "HASSGfzkLCc",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "33 phút"
                ),
                TheoryTopicItem(
                    id: "math_g11_s1_2",
                    title: "Hàm số lượng giác và Phương trình lượng giác cơ bản",
                    summary: "Hàm số lượng giác: Tập xác định, tập giá trị, tính chẵn lẻ, tính tuần hoàn và đồ thị của các hàm số $y = \\sin x, y = \\cos x, y = \\tan x, y = \\cot x$.; Phương...",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "HASSGfzkLCc",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "math_g11_s1_3",
                    title: "Dãy số, Cấp số cộng và Cấp số nhân",
                    summary: "Dãy số: Khái niệm dãy số (dãy số hữu hạn, dãy số vô hạn). Các cách cho một dãy số. Dãy số tăng, dãy số giảm, dãy số bị chặn.; Cấp số cộng (CSC):; Định nghĩa:...",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "ko6QriFQfEk",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "37 phút"
                ),
                TheoryTopicItem(
                    id: "math_g11_s1_4",
                    title: "Giới hạn và Hàm số liên tục",
                    summary: "Giới hạn của dãy số: Khái niệm giới hạn hữu hạn, giới hạn vô cực. Một số giới hạn đặc biệt. Định lý về giới hạn hữu hạn (tổng, hiệu, tích, thương). Tổng của ...",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "HASSGfzkLCc",
                    channelName: "Thầy Nguyễn Phan Tiến - VietJack",
                    estimatedTime: "21 phút"
                ),
                TheoryTopicItem(
                    id: "math_g11_s1_5",
                    title: "Đường thẳng và Mặt phẳng trong không gian (Hình học không gian)",
                    summary: "Đường thẳng và mặt phẳng: Khái niệm điểm, đường thẳng, mặt phẳng trong không gian. Các hình thức xác định một mặt phẳng. Hình chóp và hình lăng trụ.; Vị trí ...",
                    subject: "Toán",
                    grade: 11,
                    semester: 1,
                    videoId: "HASSGfzkLCc",
                    channelName: "Thầy Nguyễn Phan Tiến - VietJack",
                    estimatedTime: "27 phút"
                ),
            ]
        case (11, 2):
            return [
                TheoryTopicItem(
                    id: "math_g11_s2_1",
                    title: "Lũy thừa, Lôgarit và Hàm số lũy thừa, mũ, lôgarit",
                    summary: "Phép tính lũy thừa: Lũy thừa với số mũ nguyên, số mũ hữu tỉ và số mũ thực. Các tính chất của lũy thừa.; Phép tính lôgarit: Định nghĩa $\\log_a b$ ($a > 0, a \\...",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "HASSGfzkLCc",
                    channelName: "Thầy Nguyễn Phan Tiến - VietJack",
                    estimatedTime: "23 phút"
                ),
                TheoryTopicItem(
                    id: "math_g11_s2_2",
                    title: "Quan hệ vuông góc trong không gian",
                    summary: "Góc giữa hai đường thẳng trong không gian. Hai đường thẳng vuông góc.; Đường thẳng vuông góc với mặt phẳng:; Điều kiện: Đường thẳng vuông góc với hai đường t...",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "HASSGfzkLCc",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "29 phút"
                ),
                TheoryTopicItem(
                    id: "math_g11_s2_3",
                    title: "Đạo hàm",
                    summary: "Khái niệm đạo hàm: Định nghĩa đạo hàm tại một điểm (ý nghĩa hình học là hệ số góc của tiếp tuyến, ý nghĩa vật lý là vận tốc tức thời, gia tốc). Định nghĩa đạ...",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "HASSGfzkLCc",
                    channelName: "Thầy Nguyễn Phan Tiến - VietJack",
                    estimatedTime: "29 phút"
                ),
                TheoryTopicItem(
                    id: "math_g11_s2_4",
                    title: "Một số yếu tố Xác suất (Nâng cao)",
                    summary: "Biến cố giao và Biến cố xung khắc: Khái niệm và quy tắc cộng xác suất cho hai biến cố xung khắc: $P(A \\cup B) = P(A) + P(B)$.; Biến cố độc lập: Khái niệm hai...",
                    subject: "Toán",
                    grade: 11,
                    semester: 2,
                    videoId: "HASSGfzkLCc",
                    channelName: "Thầy Nguyễn Phan Tiến - VietJack",
                    estimatedTime: "21 phút"
                ),
            ]
        case (12, 1):
            return [
                TheoryTopicItem(
                    id: "math_g12_s1_1",
                    title: "Ứng dụng đạo hàm để khảo sát và vẽ đồ thị hàm số",
                    summary: "Tính đơn điệu của hàm số: Mối liên hệ giữa dấu của đạo hàm bậc nhất $f'(x)$ và tính đồng biến, nghịch biến của hàm số trên một khoảng.; Cực trị của hàm số: Đ...",
                    subject: "Toán",
                    grade: 12,
                    semester: 1,
                    videoId: "990wEB5yo2k",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "31 phút"
                ),
                TheoryTopicItem(
                    id: "math_g12_s1_2",
                    title: "Khối tròn xoay",
                    summary: "Nón tròn xoay, Trụ tròn xoay, Cầu tròn xoay: Khái niệm mặt tròn xoay, khối tròn xoay.; Ứng dụng thực tế: Tính diện tích xung quanh, diện tích toàn phần và th...",
                    subject: "Toán",
                    grade: 12,
                    semester: 1,
                    videoId: "990wEB5yo2k",
                    channelName: "Thầy Nguyễn Phan Tiến - Tuyensinh247",
                    estimatedTime: "19 phút"
                ),
                TheoryTopicItem(
                    id: "math_g12_s1_3",
                    title: "Hình học không gian (Thể tích khối đa diện)",
                    summary: "Khái niệm về khối đa diện: Định nghĩa hình đa diện, khối đa diện. Phép dời hình và sự bằng nhau giữa các khối đa diện. Phân chia và lắp ghép các khối đa diện...",
                    subject: "Toán",
                    grade: 12,
                    semester: 1,
                    videoId: "j615s9znk4U",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "25 phút"
                ),
            ]
        case (12, 2):
            return [
                TheoryTopicItem(
                    id: "math_g12_s2_1",
                    title: "Nguyên hàm và Tích phân",
                    summary: "Nguyên hàm: Định nghĩa nguyên hàm, tính chất của nguyên hàm. Bảng nguyên hàm của các hàm số sơ cấp cơ bản. Các phương pháp tìm nguyên hàm: Phương pháp đổi bi...",
                    subject: "Toán",
                    grade: 12,
                    semester: 2,
                    videoId: "990wEB5yo2k",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "25 phút"
                ),
                TheoryTopicItem(
                    id: "math_g12_s2_2",
                    title: "Xác suất có điều kiện và Công thức xác suất toàn phần",
                    summary: "Xác suất có điều kiện: Khái niệm và công thức tính xác suất của biến cố $A$ với điều kiện biến cố $B$ đã xảy ra: $P(A|B) = \\frac{P(A \\cap B)}{P(B)}$ ($P(B) >...",
                    subject: "Toán",
                    grade: 12,
                    semester: 2,
                    videoId: "990wEB5yo2k",
                    channelName: "Thầy Nguyễn Phan Tiến - Tuyensinh247",
                    estimatedTime: "21 phút"
                ),
                TheoryTopicItem(
                    id: "math_g12_s2_3",
                    title: "Hình học tọa độ (Phương pháp tọa độ trong không gian Oxyz)",
                    summary: "Hệ tọa độ trong không gian: Định nghĩa hệ trục tọa độ Oxyz, tọa độ của điểm, tọa độ của vectơ. Biểu thức tọa độ của các phép toán vectơ (cộng, trừ, nhân với ...",
                    subject: "Toán",
                    grade: 12,
                    semester: 2,
                    videoId: "phvpqxLNTUQ",
                    channelName: "Thầy Nguyễn Phan Tiến",
                    estimatedTime: "25 phút"
                ),
            ]
        default:
            return []
        }
    }
}
