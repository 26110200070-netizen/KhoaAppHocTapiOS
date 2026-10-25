import SwiftUI

// MARK: - Mindmap Node Model
struct MindmapNode: Identifiable {
    let id: String
    let title: String
    let icon: String
    let colorHex: String
    let description: String
    let formulas: [String]
    let keyPoints: [String]
    let traps: [String]
    let children: [MindmapNode]
    
    init(
        id: String = UUID().uuidString,
        title: String,
        icon: String = "circle.fill",
        colorHex: String = "#0284C7",
        description: String = "",
        formulas: [String] = [],
        keyPoints: [String] = [],
        traps: [String] = [],
        children: [MindmapNode] = []
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.colorHex = colorHex
        self.description = description
        self.formulas = formulas
        self.keyPoints = keyPoints
        self.traps = traps
        self.children = children
    }
}

// MARK: - Knowledge Mindmap View
struct KnowledgeMindmapView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    
    @State private var selectedGrade: Int = 12
    @State private var selectedSubject: String = "Toán"
    @State private var searchText: String = ""
    @State private var selectedNode: MindmapNode? = nil
    @State private var expandedBranchIds: Set<String> = []
    
    var onOpenAIChatWithTopic: ((String) -> Void)? = nil
    
    private let grades = [10, 11, 12]
    private let subjects = [
        "Toán", "Vật lí", "Hóa học", "Sinh học", "Ngữ văn", "Tiếng Anh", "Lịch sử", "Địa lí"
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "#F8FAF9")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Top Bar
                topHeaderBar
                
                // 2. Filters (Grade + Subjects)
                filterBar
                
                // 3. Search Bar
                searchBar
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                // 4. Mindmap Tree Content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        // Central Subject Node
                        centralRootCard
                        
                        // Branches
                        ForEach(currentBranches) { branch in
                            mindmapBranchSection(branch: branch)
                        }
                        
                        Spacer().frame(height: 80)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
        }
        .sheet(item: $selectedNode) { node in
            nodeDetailSheet(node: node)
        }
    }
    
    // MARK: - 1. Top Header Bar
    private var topHeaderBar: some View {
        HStack(spacing: 12) {
            Button(action: {
                dismiss()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(hex: "#111827"))
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("Sơ Đồ Kiến Thức")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    Image(systemName: "circle.hexagongrid.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#0284C7"))
                }
                Text("Hệ thống hóa toàn bộ kiến thức trực quan")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 6)
    }
    
    // MARK: - 2. Filter Bar (Grade + Subject Pills)
    private var filterBar: some View {
        VStack(spacing: 10) {
            // Grade Segmented Control
            HStack(spacing: 8) {
                ForEach(grades, id: \.self) { g in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedGrade = g
                        }
                    }) {
                        Text("Lớp \(g)")
                            .font(.system(size: 13, weight: selectedGrade == g ? .bold : .medium))
                            .foregroundColor(selectedGrade == g ? .white : Color(hex: "#4B5563"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(
                                Capsule()
                                    .fill(selectedGrade == g ? Color(hex: "#0284C7") : Color.white)
                                    .shadow(color: Color.black.opacity(selectedGrade == g ? 0.15 : 0.03), radius: 4, x: 0, y: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // Subjects Horizontal Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(subjects, id: \.self) { subj in
                        let isSelected = selectedSubject == subj
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedSubject = subj
                            }
                        }) {
                            Text(subj)
                                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? LinearGradient(colors: [Color(hex: "#0284C7"), Color(hex: "#0369A1")], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color.white], startPoint: .top, endPoint: .bottom))
                                        .shadow(color: Color.black.opacity(isSelected ? 0.15 : 0.04), radius: 4, x: 0, y: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 6)
    }
    
    // MARK: - 3. Search Bar
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.textSecondary)
                .font(.system(size: 14))
            
            TextField("Tìm kiếm chuyên đề, công thức, định lý...", text: $searchText)
                .font(.system(size: 14))
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
        )
    }
    
    // MARK: - 4. Central Root Card
    private var centralRootCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#0284C7"), Color(hex: "#38BDF8")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .shadow(color: Color(hex: "#0284C7").opacity(0.3), radius: 8, x: 0, y: 3)
                
                Image(systemName: subjectIcon(selectedSubject))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("\(selectedSubject) • Lớp \(selectedGrade)")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                
                Text("\(currentBranches.count) Chuyên đề trọng tâm • Nhấn nhánh để xem chi tiết")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Branch Section
    private func mindmapBranchSection(branch: MindmapNode) -> some View {
        let isExpanded = expandedBranchIds.contains(branch.id) || !searchText.isEmpty
        
        return VStack(alignment: .leading, spacing: 10) {
            // Branch Header Card
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    if expandedBranchIds.contains(branch.id) {
                        expandedBranchIds.remove(branch.id)
                    } else {
                        expandedBranchIds.insert(branch.id)
                    }
                }
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: branch.colorHex).opacity(0.12))
                            .frame(width: 38, height: 38)
                        Image(systemName: branch.icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: branch.colorHex))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(branch.title)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("\(branch.children.count) chủ đề con")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: branch.colorHex))
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                )
            }
            .buttonStyle(.plain)
            
            // Sub-branches / Child Nodes
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(branch.children.filter {
                        searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText) || $0.description.localizedCaseInsensitiveContains(searchText)
                    }) { child in
                        Button(action: {
                            selectedNode = child
                        }) {
                            HStack(spacing: 12) {
                                // Connecting node line & dot
                                Circle()
                                    .fill(Color(hex: branch.colorHex))
                                    .frame(width: 8, height: 8)
                                    .padding(.leading, 12)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(child.title)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(hex: "#1F2937"))
                                    
                                    if !child.description.isEmpty {
                                        Text(child.description)
                                            .font(.caption)
                                            .foregroundColor(AppTheme.textSecondary)
                                            .lineLimit(1)
                                    }
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    if !child.formulas.isEmpty {
                                        Text("\(child.formulas.count) CT")
                                            .font(.system(size: 10, weight: .bold))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color(hex: "#ECFDF5"))
                                            .foregroundColor(Color(hex: "#059669"))
                                            .clipShape(Capsule())
                                    }
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(Color.gray.opacity(0.4))
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.trailing, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.white.opacity(0.85))
                                    .shadow(color: Color.black.opacity(0.02), radius: 3, x: 0, y: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.leading, 18)
            }
        }
    }
    
    // MARK: - Node Detail Sheet
    private func nodeDetailSheet(node: MindmapNode) -> some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 6) {
                        Text(node.title)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        
                        if !node.description.isEmpty {
                            Text(node.description)
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color(hex: "#EFF6FF"))
                    )
                    
                    // Key Points (Kiến thức cốt lõi)
                    if !node.keyPoints.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(Color(hex: "#F59E0B"))
                                Text("Kiến Thức Cốt Lõi")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#111827"))
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(node.keyPoints, id: \.self) { pt in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("•")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "#0284C7"))
                                        Text(pt)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(hex: "#374151"))
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                        )
                    }
                    
                    // Formulas (Công thức giải nhanh)
                    if !node.formulas.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                Image(systemName: "function")
                                    .foregroundColor(Color(hex: "#059669"))
                                Text("Công Thức Giải Nhanh Trọng Tâm")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#111827"))
                            }
                            
                            VStack(spacing: 8) {
                                ForEach(node.formulas, id: \.self) { f in
                                    HStack {
                                        Text(f)
                                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                                            .foregroundColor(Color(hex: "#065F46"))
                                        Spacer()
                                        Button(action: {
                                            UIPasteboard.general.string = f
                                        }) {
                                            Image(systemName: "doc.on.doc")
                                                .font(.caption)
                                                .foregroundColor(Color(hex: "#059669"))
                                        }
                                    }
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(hex: "#ECFDF5"))
                                    )
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                        )
                    }
                    
                    // Traps (Bẫy đề thi cần tránh)
                    if !node.traps.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(Color(hex: "#DC2626"))
                                Text("Bẫy Thường Gặp & Điểm Cần Lưu Ý")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#111827"))
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(node.traps, id: \.self) { trap in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("⚠️")
                                            .font(.system(size: 12))
                                        Text(trap)
                                            .font(.system(size: 13))
                                            .foregroundColor(Color(hex: "#991B1B"))
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color(hex: "#FEF2F2"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(Color(hex: "#FCA5A5").opacity(0.5), lineWidth: 1)
                                )
                        )
                    }
                    
                    // Button Ask Shimy AI
                    Button(action: {
                        let topic = node.title
                        selectedNode = nil
                        dismiss()
                        onOpenAIChatWithTopic?(topic)
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 16, weight: .bold))
                            Text("Hỏi Shimy AI giải thích chuyên sâu chuyên đề này")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#059669"), Color(hex: "#10B981")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(hex: "#059669").opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .padding(.top, 4)
                }
                .padding(20)
            }
            .navigationTitle("Chi Tiết Chuyên Đề")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        selectedNode = nil
                    }
                    .font(.system(size: 15, weight: .semibold))
                }
            }
        }
    }
    
    // MARK: - Helpers & Data
    private func subjectIcon(_ subject: String) -> String {
        switch subject.lowercased() {
        case "toán": return "function"
        case "vật lí": return "atom"
        case "hóa học": return "flask.fill"
        case "sinh học": return "leaf.fill"
        case "ngữ văn": return "book.closed.fill"
        case "tiếng anh": return "character.bubble.fill"
        case "lịch sử": return "building.columns.fill"
        case "địa lí": return "globe.asia.australia.fill"
        default: return "sparkles"
        }
    }
    
    // Dynamic branches based on subject and grade
    private var currentBranches: [MindmapNode] {
        switch (selectedSubject.lowercased(), selectedGrade) {
        case ("toán", 12):
            return [
                MindmapNode(
                    title: "Chương 1: Ứng Dụng Đạo Hàm Khảo Sát Hàm Số",
                    icon: "chart.line.uptrend.xyaxis",
                    colorHex: "#0284C7",
                    children: [
                        MindmapNode(
                            title: "Tính đơn điệu của hàm số",
                            description: "Điều kiện y' > 0 (đồng biến), y' < 0 (nghịch biến)",
                            formulas: ["y' >= 0, ∀x ∈ (a;b) ⇔ Hàm số đồng biến", "Δ <= 0 và a > 0 cho tam thức bậc hai luôn dương"],
                            keyPoints: ["Dấu bằng chỉ xảy ra tại hữu hạn điểm.", "Xét tính đơn điệu trên từng khoảng xác định, không dùng ký hiệu hợp."],
                            traps: ["Quên điều kiện xác định của hàm phân thức bậc 1 / bậc 1.", "Dấu bằng xảy ra tại vô số điểm thì không đồng biến."]
                        ),
                        MindmapNode(
                            title: "Cực trị của hàm số",
                            description: "Điểm cực đại, cực tiểu và quy tắc tìm cực trị",
                            formulas: ["y'(x0) = 0 và y''(x0) < 0 ⇒ Cực đại", "y'(x0) = 0 và y''(x0) > 0 ⇒ Cực tiểu"],
                            keyPoints: ["y' đổi dấu từ + sang - là Cực đại.", "y' đổi dấu từ - sang + là Cực tiểu."],
                            traps: ["Hàm số phân thức bậc 1/bậc 1 không có cực trị."]
                        ),
                        MindmapNode(
                            title: "Đường tiệm cận của đồ thị hàm số",
                            description: "Tiệm cận đứng, tiệm cận ngang và tiệm cận xiên",
                            formulas: ["lim_{x→±∞} y = y0 ⇒ TCN y = y0", "lim_{x→x0^±} y = ±∞ ⇒ TCĐ x = x0"],
                            keyPoints: ["Bậc tử < bậc mẫu: TCN y = 0.", "Bậc tử = bậc mẫu: TCN y = hệ số cao nhất."],
                            traps: ["Nghiệm của mẫu triệt tiêu với nghiệm của tử thì chưa chắc là TCĐ."]
                        )
                    ]
                ),
                MindmapNode(
                    title: "Chương 2: Tọa Độ Vector Trong Không Gian Oxyz",
                    icon: "cube.transparent",
                    colorHex: "#7C3AED",
                    children: [
                        MindmapNode(
                            title: "Tọa độ điểm và vector trong Oxyz",
                            description: "Tích có hướng, tích vô hướng và ứng dụng",
                            formulas: ["u . v = |u|.|v|.cos(u, v)", "S_tamgiac = 1/2 |[AB, AC]|", "V_tu_dien = 1/6 |[AB, AC].AD|"],
                            keyPoints: ["Tích có hướng [u, v] vuông góc với cả u và v.", "Hai vector cùng phương khi [u, v] = 0."],
                            traps: ["Sai thứ tự định thức khi tính tọa độ tích có hướng."]
                        ),
                        MindmapNode(
                            title: "Phương trình mặt phẳng (P)",
                            description: "Véc-tơ pháp tuyến và khoảng cách từ điểm đến mp",
                            formulas: ["Ax + By + Cz + D = 0", "d(M, (P)) = |Ax0 + By0 + Cz0 + D| / √(A² + B² + C²)"],
                            keyPoints: ["VTPT n = [u1, u2] với u1, u2 là 2 vtcp không cùng phương."],
                            traps: ["Quên chia cho độ dài VTPT khi tính khoảng cách."]
                        ),
                        MindmapNode(
                            title: "Phương trình đường thẳng (d)",
                            description: "Phương trình chính tắc và tham số",
                            formulas: ["x = x0 + at, y = y0 + bt, z = z0 + ct", "(x - x0)/a = (y - y0)/b = (z - z0)/c"],
                            keyPoints: ["VTCP xác định phương chiều của đường thẳng.", "Góc giữa 2 đường thẳng tính bằng trị tuyệt đối cosin."],
                            traps: ["Mẫu số trong pt chính tắc phải khác 0."]
                        )
                    ]
                ),
                MindmapNode(
                    title: "Chương 3: Các Số Đặc Trưng Đo Mức Độ Phân Tán",
                    icon: "chart.bar.xaxis",
                    colorHex: "#059669",
                    children: [
                        MindmapNode(
                            title: "Khoảng biến thiên và khoảng tứ phân vị",
                            description: "R = x_max - x_min, ΔQ = Q3 - Q1",
                            formulas: ["R = x_max - x_min", "ΔQ = Q3 - Q1"],
                            keyPoints: ["Dùng để đo độ phân tán của mẫu số liệu ghép nhóm.", "Khoảng tứ phân vị ít bị ảnh hưởng bởi giá trị ngoại lệ."],
                            traps: ["Xác định sai nhóm chứa tứ phân vị khi ghép nhóm."]
                        ),
                        MindmapNode(
                            title: "Phương sai và độ lệch chuẩn",
                            description: "s² và s biểu thị độ phân tán quanh số trung bình",
                            formulas: ["s² = 1/n ∑ f_i (c_i - x̄)²", "s = √(s²)"],
                            keyPoints: ["Giá trị đại diện của nhóm [a; b) là (a + b) / 2."],
                            traps: ["Quên bình phương độ lệch hoặc nhầm giữa s và s²."]
                        )
                    ]
                )
            ]
            
        case ("vật lí", 12):
            return [
                MindmapNode(
                    title: "Chương 1: Vật Lý Nhiệt",
                    icon: "thermometer.sun.fill",
                    colorHex: "#DC2626",
                    children: [
                        MindmapNode(
                            title: "Mô hình động học phân tử chất khí",
                            description: "Chuyển động Brown, tương tác giữa các phân tử",
                            formulas: ["p = 1/3 ρ v̄²", "E_d = 3/2 k T"],
                            keyPoints: ["Nhiệt độ tuyệt đối T tỉ lệ thuận với động năng tịnh tiến trung bình.", "Chất khí lý tưởng coi các phân tử là chất điểm chỉ tương tác khi va chạm."],
                            traps: ["Nhầm nhiệt độ Celsius (°C) và Kelvin (K = °C + 273.15)."]
                        ),
                        MindmapNode(
                            title: "Định luật I Nhiệt Động Lực Học",
                            description: "ΔU = A + Q và quy ước dấu",
                            formulas: ["ΔU = A + Q", "Q = m c ΔT", "Q = m L"],
                            keyPoints: ["Q > 0: nhận nhiệt, Q < 0: truyền nhiệt.", "A > 0: nhận công, A < 0: thực hiện công."],
                            traps: ["Sai dấu của công A khi hệ giãn nở sinh công."]
                        )
                    ]
                ),
                MindmapNode(
                    title: "Chương 2: Khí Lý Tưởng",
                    icon: "wind",
                    colorHex: "#0284C7",
                    children: [
                        MindmapNode(
                            title: "Phương trình trạng thái Clapeyron - Mendeleev",
                            description: "Mối liên hệ p, V, T",
                            formulas: ["p V = n R T = (m/M) R T", "p1 V1 / T1 = p2 V2 / T2"],
                            keyPoints: ["Đẳng nhiệt: p V = const.", "Đẳng tích: p / T = const.", "Đẳng áp: V / T = const."],
                            traps: ["Không đổi đơn vị áp suất sang Pa (1 atm = 1.013.10^5 Pa)."]
                        )
                    ]
                ),
                MindmapNode(
                    title: "Chương 3: Từ Trường & Cảm Ứng Điện Từ",
                    icon: "bolt.fill",
                    colorHex: "#F59E0B",
                    children: [
                        MindmapNode(
                            title: "Lực từ & Cảm ứng từ B",
                            description: "F = B I l sin(α), lực Lorentz f = |q| v B sin(α)",
                            formulas: ["F = B I l sin(α)", "f = |q| v B sin(α)", "Φ = B S cos(α)"],
                            keyPoints: ["Quy tắc bàn tay trái xác định chiều lực từ.", "Quy tắc nắm tay phải xác định chiều đường sức từ."],
                            traps: ["Góc α là góc giữa vector cảm ứng từ B và pháp tuyến n."]
                        )
                    ]
                )
            ]
            
        case ("hóa học", 12):
            return [
                MindmapNode(
                    title: "Chương 1: Este - Lipit - Chất Giặt Rửa",
                    icon: "drop.fill",
                    colorHex: "#E11D48",
                    children: [
                        MindmapNode(
                            title: "Este & Phản ứng xà phòng hóa",
                            description: "RCOOR' + NaOH → RCOONa + R'OH",
                            formulas: ["M_este = 14n + 32 (este no đơn)", "n_NaOH = n_este = n_muoi"],
                            keyPoints: ["Phản ứng este hóa là thuận nghịch, xúc tác H2SO4 đặc.", "Thủy phân trong kiềm là 1 chiều (xà phòng hóa)."],
                            traps: ["Este của phenol tác dụng với NaOH theo tỉ lệ 1:2 tạo 2 muối và H2O."]
                        ),
                        MindmapNode(
                            title: "Chất béo (Triglycerit)",
                            description: "(RCOO)3C3H5 + 3NaOH → 3RCOONa + C3H5(OH)3",
                            formulas: ["m_muoi = m_lipit + m_NaOH - m_glixerol", "n_glixerol = n_lipit"],
                            keyPoints: ["Chất béo no (mỡ ĐV) ở thể rắn, chất béo không no (dầu TV) ở thể lỏng.", "Hiđro hóa chất béo lỏng thành chất béo rắn."],
                            traps: ["Quên tỉ lệ 1 mol chất béo sinh ra 1 mol glixerol và 3 mol muối."]
                        )
                    ]
                ),
                MindmapNode(
                    title: "Chương 2: Cacbohiđrat",
                    icon: "leaf.circle.fill",
                    colorHex: "#059669",
                    children: [
                        MindmapNode(
                            title: "Monosaccarit: Glucozơ & Fructozơ",
                            description: "C6H12O6, đồng phân của nhau",
                            formulas: ["1 Glucozơ → 2 Ag (tráng bạc)", "1 Glucozơ → 2 C2H5OH + 2 CO2"],
                            keyPoints: ["Glucozơ có nhóm -CHO nên làm mất màu Br2, tráng bạc.", "Fructozơ chuyển thành Glucozơ trong môi trường kiềm."],
                            traps: ["Fructozơ không làm mất màu nước brom."]
                        ),
                        MindmapNode(
                            title: "Polisaccarit: Tinh bột & Xenlulozơ",
                            description: "(C6H10O5)n, phản ứng thủy phân",
                            formulas: ["(C6H10O5)n + n H2O → n C6H12O6", "[C6H7O2(OH)3]n + 3n HNO3 → [C6H7O2(ONO2)3]n + 3n H2O"],
                            keyPoints: ["Tinh bột tác dụng với iot cho màu xanh tím.", "Xenlulozơ trinitrat dùng làm thuốc súng không khói."],
                            traps: ["Tinh bột và xenlulozơ không phải đồng phân của nhau vì n khác nhau."]
                        )
                    ]
                )
            ]
            
        default:
            return [
                MindmapNode(
                    title: "Chuyên đề 1: Khái Niệm Cơ Bản & Trọng Tâm",
                    icon: "star.fill",
                    colorHex: "#0284C7",
                    children: [
                        MindmapNode(
                            title: "Kiến thức nền tảng kì 1",
                            description: "Tổng hợp các định lý, quy tắc và phương pháp giải nhanh",
                            formulas: ["Hệ thống định nghĩa SGK chuẩn", "Các phương pháp nhận diện dạng đề"],
                            keyPoints: ["Nắm chắc lý thuyết sách giáo khoa.", "Rèn luyện kỹ năng phân tích đề thi."],
                            traps: ["Đọc lướt bỏ qua các từ khóa then chốt: 'không đúng', 'sai', 'duy nhất'."]
                        )
                    ]
                ),
                MindmapNode(
                    title: "Chuyên đề 2: Luyện Thi THPT & Kỹ Năng Làm Đề",
                    icon: "trophy.fill",
                    colorHex: "#7C3AED",
                    children: [
                        MindmapNode(
                            title: "Chiến thuật tối ưu thời gian làm bài",
                            description: "Phân bổ thời gian: 30 câu đầu 15 phút, 10 câu khó 30 phút",
                            formulas: ["Tối ưu điểm số 8+ và 9+"],
                            keyPoints: ["Làm câu dễ trước, chắc chắn 100% câu cơ bản.", "Ghi chú bẫy đề thi."],
                            traps: ["Dành quá 5 phút cho 1 câu hỏi lạ chưa có hướng đi."]
                        )
                    ]
                )
            ]
        }
    }
}
