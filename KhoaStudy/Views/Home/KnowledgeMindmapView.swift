import SwiftUI

// MARK: - Mindmap Node Model
enum NodeImportance: String, Codable {
    case critical = "TRỌNG TÂM THI 9+"
    case coreFormula = "CÔNG THỨC CỐT LÕI"
    case examTrap = "BẪY ĐỀ THI BGD"
    case foundation = "KIẾN THỨC CƠ BẢN"
    
    var colorHex: String {
        switch self {
        case .critical: return "#DC2626"
        case .coreFormula: return "#D97706"
        case .examTrap: return "#EA580C"
        case .foundation: return "#059669"
        }
    }
    
    var icon: String {
        switch self {
        case .critical: return "flame.fill"
        case .coreFormula: return "function"
        case .examTrap: return "exclamationmark.triangle.fill"
        case .foundation: return "checkmark.seal.fill"
        }
    }
}

struct MindmapNode: Identifiable {
    let id: String
    let title: String
    let icon: String
    let colorHex: String
    let description: String
    let importance: NodeImportance
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
        importance: NodeImportance = .foundation,
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
        self.importance = importance
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
    
    // Selectors: Lớp • Môn • Học kì
    @State private var selectedGrade: Int = 12
    @State private var selectedSubject: String = "Toán"
    @State private var selectedSemester: Int = 1 // 1: Học kì 1, 2: Học kì 2, 0: Toàn năm
    
    // Generator & Tree State
    @State private var isGeneratingMindmap: Bool = false
    @State private var hasGenerated: Bool = true
    @State private var selectedNode: MindmapNode? = nil
    @State private var expandedBranchIds: Set<String> = []
    @State private var filterImportance: NodeImportance? = nil
    
    var onOpenAIChatWithTopic: ((String) -> Void)? = nil
    
    private let grades = [10, 11, 12]
    private let subjects = [
        "Toán", "Vật lí", "Hóa học", "Sinh học", "Lịch sử", "Địa lí"
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "#F8FAF9")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Top Bar
                topHeaderBar
                
                // 2. Selectors: Lớp • Môn • Học kì
                filterControlSection
                
                // 3. Action Button: "LÊN SƠ ĐỒ KIẾN THỨC"
                generateActionButton
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                // 4. Mindmap Tree Content
                if isGeneratingMindmap {
                    mindmapGeneratingLoading
                } else {
                    mindmapScrollContent
                }
            }
        }
        .sheet(item: $selectedNode) { node in
            nodeDetailSheet(node: node)
        }
        .onAppear {
            selectedGrade = appState.currentUser.grade
            expandedBranchIds = Set(currentBranches.map { $0.id })
        }
    }
    
    // MARK: - 1. Top Header Bar
    private var topHeaderBar: some View {
        HStack(spacing: 12) {
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 5) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .bold))
                    Text("Trang Chủ")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(AppTheme.primaryDark)
            }
            
            Spacer()
            
            Text("Sơ Đồ Kiến Thức")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
            
            Spacer()
            
            // Dummy for symmetry
            Circle().fill(Color.clear).frame(width: 32, height: 32)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 6)
    }
    
    // MARK: - 2. Filter Control Section (Lớp • Môn • Học kì)
    private var filterControlSection: some View {
        VStack(spacing: 10) {
            // A. Khối Lớp & Học kì (2 hàng nút gọn gàng)
            HStack(spacing: 8) {
                // Grade Selector
                HStack(spacing: 6) {
                    ForEach(grades, id: \.self) { g in
                        let isSelected = (selectedGrade == g)
                        Button(action: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                selectedGrade = g
                            }
                        }) {
                            Text("Lớp \(g)")
                                .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? Color(hex: "#0A3E39") : Color.white)
                                )
                                .foregroundColor(isSelected ? .white : Color(hex: "#4B5563"))
                                .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 4, x: 0, y: 1)
                        }
                    }
                }
                
                Spacer()
                
                // Semester Selector
                HStack(spacing: 6) {
                    semesterChip(title: "HK1", semester: 1)
                    semesterChip(title: "HK2", semester: 2)
                    semesterChip(title: "Cả Năm", semester: 0)
                }
            }
            .padding(.horizontal, 16)
            
            // B. Môn Học (Horizontal chip scroll)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(subjects, id: \.self) { sub in
                        let isSelected = (selectedSubject == sub)
                        Button(action: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                selectedSubject = sub
                            }
                        }) {
                            Text(sub)
                                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? Color(hex: "#059669") : Color.white)
                                )
                                .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                                .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 4, x: 0, y: 1)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 2)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func semesterChip(title: String, semester: Int) -> some View {
        let isSelected = (selectedSemester == semester)
        return Button(action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                selectedSemester = semester
            }
        }) {
            Text(title)
                .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(hex: "#0284C7") : Color.white)
                )
                .foregroundColor(isSelected ? .white : Color(hex: "#4B5563"))
                .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 4, x: 0, y: 1)
        }
    }
    
    // MARK: - 3. Action Button: "LÊN SƠ ĐỒ KIẾN THỨC"
    private var generateActionButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                isGeneratingMindmap = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isGeneratingMindmap = false
                    hasGenerated = true
                    expandedBranchIds = Set(currentBranches.map { $0.id })
                }
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.triangle.branch")
                    .font(.system(size: 14, weight: .bold))
                Text("LÊN SƠ ĐỒ KIẾN THỨC (TRITHUCAI)")
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                Image(systemName: "sparkles")
                    .font(.system(size: 13, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#059669"), Color(hex: "#0D9488")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color(hex: "#059669").opacity(0.3), radius: 8, x: 0, y: 3)
        }
    }
    
    // MARK: - Generating Animation
    private var mindmapGeneratingLoading: some View {
        VStack(spacing: 14) {
            Spacer()
            ProgressView()
                .tint(Color(hex: "#059669"))
                .scaleEffect(1.3)
            Text("Đang tổng hợp sơ đồ kiến thức chuẩn SGK...")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.textSecondary)
            Spacer()
        }
    }
    
    // MARK: - 4. Mindmap Scroll Content
    private var mindmapScrollContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                // Central Subject Node
                centralRootCard
                
                // Priority Legend (Để học sinh biết cái nào quan trọng mà học)
                importanceLegendSection
                
                // Branches
                ForEach(currentBranches) { branch in
                    mindmapBranchSection(branch: branch)
                }
                
                Spacer().frame(height: 80)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
        }
    }
    
    // MARK: - Central Root Card
    private var centralRootCard: some View {
        let semText = selectedSemester == 1 ? "Học Kì 1" : (selectedSemester == 2 ? "Học Kì 2" : "Toàn Bộ Năm Học")
        return HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#059669").opacity(0.12))
                    .frame(width: 52, height: 52)
                Image(systemName: "sparkles")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: "#059669"))
            }
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text("CHUẨN BỘ GIÁO DỤC")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundColor(Color(hex: "#059669"))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color(hex: "#D1FAE5")))
                    
                    Text("\(semText)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#0284C7"))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color(hex: "#E0F2FE")))
                }
                
                Text("\(selectedSubject) • Lớp \(selectedGrade)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                
                Text("\(currentBranches.count) chuyên đề lớn • Trực quan hóa bám sát trithucAI")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Importance Legend (Giúp học sinh biết phần nào quan trọng)
    private var importanceLegendSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("QUY ƯỚC MỨC ĐỘ QUAN TRỌNG TRONG ĐỀ THI")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(hex: "#4B5563"))
            
            HStack(spacing: 8) {
                legendTag(title: "Trọng tâm 9+", color: Color(hex: "#DC2626"), icon: "flame.fill")
                legendTag(title: "Công thức cốt lõi", color: Color(hex: "#D97706"), icon: "function")
                legendTag(title: "Bẫy đề thi", color: Color(hex: "#EA580C"), icon: "exclamationmark.triangle.fill")
                legendTag(title: "Cơ bản", color: Color(hex: "#059669"), icon: "checkmark.seal.fill")
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 1)
        )
    }
    
    private func legendTag(title: String, color: Color, icon: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 9, weight: .bold))
            Text(title)
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundColor(color)
        .padding(.horizontal, 7)
        .padding(.vertical, 4)
        .background(Capsule().fill(color.opacity(0.12)))
    }
    
    // MARK: - Mindmap Branch Section (Accordion Tree)
    private func mindmapBranchSection(branch: MindmapNode) -> some View {
        let isExpanded = expandedBranchIds.contains(branch.id)
        
        return VStack(alignment: .leading, spacing: 10) {
            // Branch Header Button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    if isExpanded {
                        expandedBranchIds.remove(branch.id)
                    } else {
                        expandedBranchIds.insert(branch.id)
                    }
                }
            }) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(hex: branch.colorHex))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: branch.icon)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Text(branch.title)
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#111827"))
                                .lineLimit(1)
                            
                            importanceBadge(importance: branch.importance)
                        }
                        
                        Text(branch.description)
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color.gray.opacity(0.5))
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                )
            }
            .buttonStyle(.plain)
            
            // Sub-branches and leaves
            if isExpanded && !branch.children.isEmpty {
                VStack(spacing: 8) {
                    ForEach(branch.children) { child in
                        mindmapChildNodeRow(node: child, parentColor: branch.colorHex)
                    }
                }
                .padding(.leading, 20)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
    
    // MARK: - Child Node Row
    private func mindmapChildNodeRow(node: MindmapNode, parentColor: String) -> some View {
        Button(action: {
            selectedNode = node
        }) {
            HStack(spacing: 10) {
                // Tree connector dot
                Circle()
                    .fill(Color(hex: node.importance.colorHex))
                    .frame(width: 8, height: 8)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(node.title)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(hex: "#1F2937"))
                            .lineLimit(1)
                        
                        importanceBadge(importance: node.importance)
                    }
                    
                    if !node.description.isEmpty {
                        Text(node.description)
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Tap to see details pill
                Text("Chi tiết")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(hex: "#059669"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color(hex: "#D1FAE5")))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func importanceBadge(importance: NodeImportance) -> some View {
        HStack(spacing: 3) {
            Image(systemName: importance.icon)
                .font(.system(size: 8, weight: .bold))
            Text(importance.rawValue)
                .font(.system(size: 9, weight: .heavy))
        }
        .foregroundColor(Color(hex: importance.colorHex))
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Capsule().fill(Color(hex: importance.colorHex).opacity(0.12)))
    }
    
    // MARK: - Node Detail Sheet (Xem công thức, bẫy đề thi, hỏi AI)
    private func nodeDetailSheet(node: MindmapNode) -> some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    // Header card
                    VStack(alignment: .leading, spacing: 6) {
                        importanceBadge(importance: node.importance)
                        
                        Text(node.title)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        
                        Text(node.description)
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
                    
                    // Core Formulas Section
                    if !node.formulas.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                Image(systemName: "function")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "#D97706"))
                                Text("CÔNG THỨC BẮT BUỘC NHỚ")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(hex: "#111827"))
                            }
                            
                            ForEach(node.formulas, id: \.self) { formula in
                                Text(formula)
                                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                                    .foregroundColor(Color(hex: "#1F2937"))
                                    .padding(10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "#FEF3C7").opacity(0.5)))
                            }
                        }
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
                    }
                    
                    // Exam Traps Section
                    if !node.traps.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "#DC2626"))
                                Text("BẪY ĐỀ THI BGD THƯỜNG GẶP")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(hex: "#111827"))
                            }
                            
                            ForEach(node.traps, id: \.self) { trap in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color(hex: "#DC2626"))
                                    Text(trap)
                                        .font(.system(size: 13))
                                        .foregroundColor(Color(hex: "#374151"))
                                }
                                .padding(8)
                            }
                        }
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
                    }
                    
                    // Action Buttons
                    Button(action: {
                        selectedNode = nil
                        dismiss()
                        onOpenAIChatWithTopic?(node.title)
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                            Text("Hỏi Shimy AI Giải Thích Bài Này")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Capsule().fill(Color(hex: "#059669")))
                    }
                    .padding(.top, 10)
                }
                .padding(16)
            }
            .background(Color(hex: "#F8FAF9").ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") { selectedNode = nil }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppTheme.primaryDark)
                }
            }
        }
    }
    
    // MARK: - Dữ Liệu Sơ Đồ Kiến Thức Chuẩn trithucAI
    private var currentBranches: [MindmapNode] {
        let sub = selectedSubject.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let gr = selectedGrade
        let sem = selectedSemester
        
        switch (sub, gr) {
        case ("toán", 12):
            if sem == 1 {
                return [
                    MindmapNode(
                        title: "1. Ứng Dụng Đạo Hàm Khảo Sát Đồ Thị",
                        icon: "chart.xyaxis.line",
                        colorHex: "#0284C7",
                        description: "Chiếm 35-40% đề thi tốt nghiệp THPT, gồm đơn điệu, cực trị, Glnn-Gtnn, tiệm cận.",
                        importance: .critical,
                        formulas: [
                            "Đơn điệu: f'(x) >= 0 (hoặc <= 0) với mọi x thuộc K",
                            "Cực trị: y = ax^3 + bx^2 + cx + d -> y' = 3ax^2 + 2bx + c (Delta' = b^2 - 3ac)",
                            "Tiệm cận đứng: lim x->x0+ f(x) = vô cùng; Tiệm cận ngang: lim x->vô cùng f(x) = y0"
                        ],
                        traps: [
                            "Quên kiểm tra nghiệm mẫu số có triệt tiêu với nghiệm tử số ở bài toán tiệm cận đứng.",
                            "Nhầm lẫn giữa cực đại/cực tiểu của hàm số (y) và điểm cực đại/cực tiểu (x)."
                        ],
                        children: [
                            MindmapNode(title: "Tính Đơn Điệu Của Hàm Số", importance: .coreFormula, description: "Điều kiện cần và đủ để hàm số đồng biến, nghịch biến trên khoảng."),
                            MindmapNode(title: "Cực Trị Hàm Số Bậc Ba & Phân Thức", importance: .critical, description: "Cực trị có điều kiện tham số m, đường thẳng đi qua 2 điểm cực trị."),
                            MindmapNode(title: "Giá Trị Lớn Nhất & Nhỏ Nhất (Glnn/Gtnn)", importance: .coreFormula, description: "Tìm max/min trên đoạn [a; b], ứng dụng bài toán thực tế tối ưu hóa."),
                            MindmapNode(title: "Đường Tiệm Cận Đồ Thị Hàm Số", importance: .examTrap, description: "Tiệm cận đứng, ngang, xiên. Bài toán chứa tham số m.")
                        ]
                    ),
                    MindmapNode(
                        title: "2. Khối Tròn Xoay & Không Gian",
                        icon: "cylinder.split.1x2.fill",
                        colorHex: "#7C3AED",
                        description: "Khối nón, khối trụ, khối cầu và thể tích khối chóp lăng trụ.",
                        importance: .critical,
                        formulas: [
                            "Khối Nón: Sxq = pi * r * l, V = (1/3) * pi * r^2 * h (l^2 = r^2 + h^2)",
                            "Khối Trụ: Sxq = 2 * pi * r * h, V = pi * r^2 * h",
                            "Khối Cầu: S = 4 * pi * R^2, V = (4/3) * pi * R^3",
                            "Thể tích chóp: V = (1/3) * S_đáy * h; Thể tích lăng trụ: V = S_đáy * h"
                        ],
                        traps: [
                            "Nhầm lẫn giữa bán kính r và đường kính d.",
                            "Quên nhân hệ số 1/3 trong công thức thể tích khối chóp và nón."
                        ],
                        children: [
                            MindmapNode(title: "Khối Nón Tròn Xoay", importance: .coreFormula, description: "Thiết diện qua trục, diện tích xung quanh và toàn phần."),
                            MindmapNode(title: "Khối Trụ & Khối Cầu Ngoại Tiếp", importance: .critical, description: "Mặt cầu ngoại tiếp hình chóp và lăng trụ đều."),
                            MindmapNode(title: "Tỉ Số Thể Tích (Định Lý Simson)", importance: .examTrap, description: "Chỉ áp dụng cho chóp tam giác S.ABC, không áp dụng cho tứ giác!")
                        ]
                    )
                ]
            } else if sem == 2 {
                return [
                    MindmapNode(
                        title: "1. Nguyên Hàm, Tích Phân & Ứng Dụng",
                        icon: "function",
                        colorHex: "#0284C7",
                        description: "Kỹ thuật tính tích phân, diện tích hình phẳng và thể tích vật thể tròn xoay.",
                        importance: .critical,
                        formulas: [
                            "Tích phân từng phần: int(u dv) = u*v - int(v du)",
                            "Diện tích hình phẳng: S = int_a^b |f(x) - g(x)| dx",
                            "Thể tích tròn xoay: V = pi * int_a^b [f(x)]^2 dx"
                        ],
                        traps: [
                            "Quên dấu trị tuyệt đối |f(x) - g(x)| khi tính diện tích hình phẳng.",
                            "Quên nhân pi ở công thức tính thể tích vật thể tròn xoay."
                        ],
                        children: [
                            MindmapNode(title: "Bảng Nguyên Hàm Cơ Bản & Đổi Biến", importance: .coreFormula, description: "Phương pháp đổi biến số đặt t = u(x)."),
                            MindmapNode(title: "Tích Phân Từng Phần (Nhất Lô, Nhì Đa...)", importance: .critical, description: "Thứ tự ưu tiên đặt u: Lôgarit -> Đa thức -> Lượng giác -> Mũ."),
                            MindmapNode(title: "Ứng Dụng Hình Phẳng & Tròn Xoay", importance: .critical, description: "Bài toán thực tế tính diện tích mặt cắt và thể tích bồn chứa.")
                        ]
                    ),
                    MindmapNode(
                        title: "2. Tọa Độ Không Gian Oxyz",
                        icon: "cube.transparent.fill",
                        colorHex: "#059669",
                        description: "Mặt phẳng, đường thẳng, mặt cầu và bài toán khoảng cách, góc.",
                        importance: .critical,
                        formulas: [
                            "Mặt phẳng: A(x - x0) + B(y - y0) + C(z - z0) = 0",
                            "Mặt cầu: (x - a)^2 + (y - b)^2 + (z - c)^2 = R^2",
                            "Khoảng cách điểm M đến (P): d(M, P) = |AxM + ByM + CzM + D| / sqrt(A^2 + B^2 + C^2)"
                        ],
                        traps: [
                            "Nhầm lẫn giữa vectơ chỉ phương u và vectơ pháp tuyến n khi chuyển đổi giữa đường thẳng và mặt phẳng."
                        ],
                        children: [
                            MindmapNode(title: "Phương Trình Mặt Phẳng & Khoảng Cách", importance: .coreFormula, description: "Vị trí tương đối, góc giữa 2 mặt phẳng."),
                            MindmapNode(title: "Phương Trình Đường Thẳng", importance: .coreFormula, description: "Dạng tham số và chính tắc, góc giữa đường và mặt."),
                            MindmapNode(title: "Bài Toán Cực Trị Oxyz (Min-Max)", importance: .critical, description: "Dành cho điểm 9-10: Vị trí điểm M sao cho tổng khoảng cách nhỏ nhất.")
                        ]
                    )
                ]
            } else {
                // Toàn năm
                return [
                    MindmapNode(title: "Học Kỳ 1: Khảo Sát Đồ Thị & Khối Tròn Xoay", icon: "1.circle.fill", colorHex: "#0284C7", description: "Ứng dụng đạo hàm, cực trị, tiệm cận, thể tích khối chóp nón trụ cầu.", importance: .critical),
                    MindmapNode(title: "Học Kỳ 2: Tích Phân & Hình Học Oxyz", icon: "2.circle.fill", colorHex: "#059669", description: "Nguyên hàm tích phân từng phần, mặt phẳng, đường thẳng, mặt cầu trong không gian.", importance: .critical)
                ]
            }
            
        case ("vật lí", 12):
            return [
                MindmapNode(
                    title: "1. Dao Động Cơ Học",
                    icon: "waveform.path.ecg",
                    colorHex: "#7C3AED",
                    description: "Dao động điều hòa, con lắc lò xo, con lắc đơn, cộng hưởng cơ.",
                    importance: .critical,
                    formulas: [
                        "x = A * cos(omega * t + phi)",
                        "v = -omega * A * sin(omega * t + phi), a = -omega^2 * x",
                        "Con lắc lò xo: omega = sqrt(k / m); Con lắc đơn: omega = sqrt(g / l)"
                    ],
                    traps: [
                        "Vận tốc sớm pha pi/2 so với li độ, gia tốc ngược pha pi so với li độ."
                    ]
                ),
                MindmapNode(
                    title: "2. Sóng Cơ & Giao Thoa Sóng",
                    icon: "water.waves",
                    colorHex: "#0284C7",
                    description: "Sóng âm, sóng dừng, giao thoa cực đại và cực tiểu.",
                    importance: .critical,
                    formulas: [
                        "lambda = v * T = v / f",
                        "Cực đại giao thoa: d2 - d1 = k * lambda; Cực tiểu: d2 - d1 = (k + 0.5) * lambda"
                    ]
                ),
                MindmapNode(
                    title: "3. Dòng Điện Xoay Chiều",
                    icon: "bolt.fill",
                    colorHex: "#EA580C",
                    description: "Mạch RLC nối tiếp, hiện tượng cộng hưởng, máy biến áp và truyền tải điện năng.",
                    importance: .critical,
                    formulas: [
                        "Z = sqrt(R^2 + (ZL - ZC)^2), ZL = omega * L, ZC = 1 / (omega * C)",
                        "Cộng hưởng: ZL = ZC -> omega^2 * L * C = 1 -> Zmin = R, Imax = U / R"
                    ]
                )
            ]
            
        case ("hóa học", 12):
            return [
                MindmapNode(
                    title: "1. Este - Lipit (Chất Béo)",
                    icon: "drop.fill",
                    colorHex: "#EA580C",
                    description: "Phản ứng xà phòng hóa, thủy phân este, chất béo no và không no.",
                    importance: .critical,
                    formulas: [
                        "RCOOR' + NaOH -> RCOONa + R'OH",
                        "(RCOO)3C3H5 + 3NaOH -> 3RCOONa + C3H5(OH)3 (Glixerol)"
                    ]
                ),
                MindmapNode(
                    title: "2. Cacbohidrat & Amin - Peptit",
                    icon: "leaf.fill",
                    colorHex: "#059669",
                    description: "Glucozo, Fructozo, Saccarozo, Tinh bột, Xenlulozo, Amino axit và Protein.",
                    importance: .critical
                ),
                MindmapNode(
                    title: "3. Đại Cương Kim Loại & Điện Phân",
                    icon: "shield.fill",
                    colorHex: "#0284C7",
                    description: "Dãy điện hóa kim loại, ăn mòn kim loại, định luật Faraday.",
                    importance: .coreFormula
                )
            ]
            
        default:
            return [
                MindmapNode(
                    title: "1. Kiến Thức Trọng Tâm Học Kỳ 1 (trithucAI)",
                    icon: "book.fill",
                    colorHex: "#059669",
                    description: "Các bài học cốt lõi môn \(selectedSubject) Lớp \(selectedGrade) bám sát SGK chuẩn.",
                    importance: .critical,
                    formulas: ["Công thức và quy luật cơ bản học kỳ 1"],
                    keyPoints: ["Bám sát chương trình Giáo dục phổ thông mới của Bộ GD&ĐT"]
                ),
                MindmapNode(
                    title: "2. Kiến Thức Nâng Cao Học Kỳ 2 (trithucAI)",
                    icon: "star.fill",
                    colorHex: "#0284C7",
                    description: "Chuyên đề phân hóa bứt phá điểm số cao trong các kỳ thi.",
                    importance: .coreFormula,
                    formulas: ["Quy tắc giải nhanh và tư duy liên môn"],
                    keyPoints: ["Ôn luyện dạng bài nhận biết, thông hiểu và vận dụng"]
                )
            ]
        }
    }
}
