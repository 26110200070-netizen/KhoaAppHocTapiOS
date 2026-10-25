import SwiftUI

// MARK: - Mindmap Node Model
enum NodeImportance: String, Codable, CaseIterable {
    case critical = "TRỌNG TÂM THI 9+"
    case coreFormula = "CÔNG THỨC CỐT LÕI"
    case examTrap = "BẪY ĐỀ THI BGD"
    case foundation = "KIẾN THỨC CƠ BẢN"
    
    var colorHex: String {
        switch self {
        case .critical: return "#DC2626"
        case .coreFormula: return "#0D9488"
        case .examTrap: return "#D97706"
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
    
    init(
        id: String = UUID().uuidString,
        title: String,
        icon: String = "circle.fill",
        colorHex: String = "#0284C7",
        importance: NodeImportance,
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
        self.importance = importance
        self.formulas = formulas
        self.keyPoints = keyPoints
        self.traps = traps
        self.children = children
    }
}

// MARK: - Curriculum Chapter Item for Circular Mindmap & Bar Chart
struct CurriculumMindmapChapter: Identifiable {
    let id: String
    let title: String
    let shortTitle: String
    let points: Double       // e.g. 3.0đ
    let percentage: Double   // e.g. 0.30 (30%)
    let importance: NodeImportance
    let colorHex: String
    let icon: String
    let description: String
    let formulas: [String]
    let traps: [String]
    let keyPoints: [String]
    let children: [MindmapNode]
    
    init(
        id: String = UUID().uuidString,
        title: String,
        shortTitle: String,
        points: Double,
        percentage: Double,
        importance: NodeImportance,
        colorHex: String,
        icon: String,
        description: String,
        formulas: [String] = [],
        traps: [String] = [],
        keyPoints: [String] = [],
        children: [MindmapNode] = []
    ) {
        self.id = id
        self.title = title
        self.shortTitle = shortTitle
        self.points = points
        self.percentage = percentage
        self.importance = importance
        self.colorHex = colorHex
        self.icon = icon
        self.description = description
        self.formulas = formulas
        self.traps = traps
        self.keyPoints = keyPoints
        self.children = children
    }
}

// MARK: - View Mode (Sơ đồ tròn, Biểu đồ cột, Cây chi tiết)
enum MindmapDisplayMode: Int, CaseIterable {
    case donut = 0
    case bar = 1
    case tree = 2
    
    var title: String {
        switch self {
        case .donut: return "Sơ Đồ Tròn"
        case .bar: return "Biểu Đồ Cột"
        case .tree: return "Cây Chi Tiết"
        }
    }
    
    var icon: String {
        switch self {
        case .donut: return "chart.pie.fill"
        case .bar: return "chart.bar.xaxis"
        case .tree: return "list.bullet.indent"
        }
    }
}

// MARK: - Knowledge Mindmap View
struct KnowledgeMindmapView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    
    // Selectors: Lớp • Môn • Học kì
    @State private var selectedGrade: Int
    @State private var selectedSubject: String
    @State private var selectedSemester: Int // 1: Học kì 1, 2: Học kì 2, 0: Toàn năm
    
    // Display Mode: 0 (Donut/Circle), 1 (Bar Chart), 2 (Hierarchical Tree)
    @State private var displayMode: MindmapDisplayMode = .donut
    
    // Interactive Selection
    @State private var selectedChapterId: String? = nil
    @State private var selectedNodeForSheet: MindmapNode? = nil
    @State private var expandedBranchIds: Set<String> = []
    @State private var isGeneratingMindmap: Bool = false
    
    var onOpenAIChatWithTopic: ((String) -> Void)? = nil
    
    private let grades = [10, 11, 12]
    private let subjects = [
        "Toán", "Vật lí", "Hóa học", "Sinh học", "Lịch sử", "Địa lí"
    ]
    
    public init(
        initialGrade: Int? = nil,
        initialSubject: String? = nil,
        initialSemester: Int? = nil,
        onOpenAIChatWithTopic: ((String) -> Void)? = nil
    ) {
        self.onOpenAIChatWithTopic = onOpenAIChatWithTopic
        _selectedGrade = State(initialValue: initialGrade ?? 11)
        _selectedSubject = State(initialValue: initialSubject ?? "Toán")
        _selectedSemester = State(initialValue: initialSemester ?? 1)
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#F8FAF9")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Top Bar
                topHeaderBar
                
                // 2. Selectors: Lớp • Môn • Học kì
                filterControlSection
                
                // 3. Mode Switcher (Sơ đồ tròn | Biểu đồ cột | Cây chi tiết)
                modeSwitcherSection
                
                // 4. Main Visual Content
                if isGeneratingMindmap {
                    mindmapGeneratingLoading
                } else {
                    mainScrollView
                }
            }
        }
        .sheet(item: $selectedNodeForSheet) { node in
            nodeDetailSheet(node: node)
        }
        .onAppear {
            if selectedChapterId == nil {
                selectedChapterId = currentChapters.first?.id
            }
            expandedBranchIds = Set(currentChapters.map { $0.id })
        }
    }
    
    // MARK: - 1. Top Header Bar (Quiet, designer, 1px bottom rule)
    private var topHeaderBar: some View {
        HStack(spacing: 12) {
            Button(action: { dismiss() }) {
                HStack(spacing: 5) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                    Text("Trang Chủ")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(AppTheme.primaryDark)
            }
            
            Spacer()
            
            VStack(spacing: 1) {
                Text("Sơ Đồ Kiến Thức Chuẩn")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                Text("trithucAI • BGD 2026")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundColor(Color(hex: "#6B7280"))
            }
            
            Spacer()
            
            // Dummy for symmetry
            Circle().fill(Color.clear).frame(width: 32, height: 32)
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Color.white)
        .overlay(Divider(), alignment: .bottom)
    }
    
    // MARK: - 2. Filter Control Section (Lớp • Môn • Học kì)
    private var filterControlSection: some View {
        VStack(spacing: 8) {
            // Row A: Grade & Semester
            HStack(spacing: 8) {
                // Grade Selector
                HStack(spacing: 5) {
                    ForEach(grades, id: \.self) { g in
                        let isSelected = (selectedGrade == g)
                        Button(action: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                selectedGrade = g
                                selectedChapterId = currentChapters.first?.id
                            }
                        }) {
                            Text("Lớp \(g)")
                                .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                .padding(.horizontal, 11)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? Color(hex: "#111827") : Color.white)
                                )
                                .foregroundColor(isSelected ? .white : Color(hex: "#4B5563"))
                                .overlay(
                                    Capsule().stroke(Color(hex: isSelected ? "#111827" : "#E5E7EB"), lineWidth: 1)
                                )
                        }
                    }
                }
                
                Spacer()
                
                // Semester Selector
                HStack(spacing: 5) {
                    semesterChip(title: "HK1", sem: 1)
                    semesterChip(title: "HK2", sem: 2)
                    semesterChip(title: "Cả Năm", sem: 0)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // Row B: Subject Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(subjects, id: \.self) { sub in
                        let isSelected = (selectedSubject == sub)
                        Button(action: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                selectedSubject = sub
                                selectedChapterId = currentChapters.first?.id
                            }
                        }) {
                            Text(sub)
                                .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                .padding(.horizontal, 13)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? Color(hex: "#059669") : Color.white)
                                )
                                .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                                .overlay(
                                    Capsule().stroke(Color(hex: isSelected ? "#059669" : "#E5E7EB"), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 2)
            }
        }
        .padding(.bottom, 6)
        .background(Color.white)
        .overlay(Divider(), alignment: .bottom)
    }
    
    private func semesterChip(title: String, sem: Int) -> some View {
        let isSelected = (selectedSemester == sem)
        return Button(action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                selectedSemester = sem
                selectedChapterId = currentChapters.first?.id
            }
        }) {
            Text(title)
                .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(hex: "#0284C7") : Color.white)
                )
                .foregroundColor(isSelected ? .white : Color(hex: "#4B5563"))
                .overlay(
                    Capsule().stroke(Color(hex: isSelected ? "#0284C7" : "#E5E7EB"), lineWidth: 1)
                )
        }
    }
    
    // MARK: - 3. Mode Switcher (Sơ đồ tròn • Biểu đồ cột • Cây chi tiết)
    private var modeSwitcherSection: some View {
        HStack(spacing: 8) {
            ForEach(MindmapDisplayMode.allCases, id: \.rawValue) { mode in
                let isSelected = (displayMode == mode)
                Button(action: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                        displayMode = mode
                    }
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: mode.icon)
                            .font(.system(size: 11, weight: .bold))
                        Text(mode.title)
                            .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(isSelected ? Color.white : Color(hex: "#F3F4F6"))
                    )
                    .foregroundColor(isSelected ? Color(hex: "#111827") : Color(hex: "#6B7280"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color(hex: isSelected ? "#D1D5DB" : "#E5E7EB"), lineWidth: isSelected ? 1 : 0)
                    )
                }
            }
        }
        .padding(4)
        .background(Color(hex: "#E5E7EB").opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    // MARK: - 4. Main Scroll View
    private var mainScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                // Scope Header Bar
                scopeHeaderBar
                
                // Active Visualization
                switch displayMode {
                case .donut:
                    donutVisualizationView
                case .bar:
                    barChartVisualizationView
                case .tree:
                    treeVisualizationView
                }
                
                // Chapter Detail Inspector
                if let activeChap = activeChapter {
                    chapterInspectorCard(chapter: activeChap)
                }
                
                Spacer().frame(height: 60)
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
        }
    }
    
    // Scope Header
    private var scopeHeaderBar: some View {
        let semText = selectedSemester == 1 ? "Học Kì 1" : (selectedSemester == 2 ? "Học Kì 2" : "Cả Năm")
        return HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("MA TRẬN KIẾN THỨC BGD")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#059669"))
                    Text("•")
                        .foregroundColor(Color.gray.opacity(0.4))
                        .font(.system(size: 10))
                    Text("\(semText)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#0284C7"))
                }
                
                Text("\(selectedSubject) • Lớp \(selectedGrade)")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
            }
            
            Spacer()
            
            // Tabular Total Score Badge
            VStack(alignment: .trailing, spacing: 1) {
                Text("10.0")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(hex: "#111827"))
                Text("Tổng điểm thi")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color(hex: "#6B7280"))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                )
        )
    }
    
    // =====================================================================
    // MARK: - VISUALIZATION 1: SƠ ĐỒ HÌNH TRÒN (DONUT RING MINDMAP)
    // =====================================================================
    private var donutVisualizationView: some View {
        let chapters = currentChapters
        let activeChap = activeChapter ?? chapters.first
        
        return VStack(spacing: 16) {
            // Ring Container
            ZStack {
                // Donut Ring (Thin 16px stroke, taste-skill compliant)
                ForEach(chapters.indices, id: \.self) { idx in
                    let chap = chapters[idx]
                    let isSelected = (chap.id == activeChap?.id)
                    let range = chapterAngleRange(index: idx, chapters: chapters)
                    
                    Circle()
                        .trim(from: range.start, to: range.end)
                        .stroke(
                            Color(hex: chap.colorHex),
                            style: StrokeStyle(lineWidth: isSelected ? 22 : 16, lineCap: .butt)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 170, height: 170)
                        .scaleEffect(isSelected ? 1.04 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                selectedChapterId = chap.id
                            }
                        }
                }
                
                // Center Hub Information
                VStack(spacing: 2) {
                    if let chap = activeChap {
                        Text(String(format: "%.1fđ", chap.points))
                            .font(.system(size: 26, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(hex: chap.colorHex))
                        Text(String(format: "%.0f%% ma trận", chap.percentage * 100))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(hex: "#4B5563"))
                    } else {
                        Text("100%")
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("Ma trận chuẩn")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "#6B7280"))
                    }
                }
            }
            .frame(height: 200)
            .padding(.top, 10)
            
            // Legend Table (Taste-skill compliant: dot, name, percentage, points in tabular font)
            VStack(spacing: 8) {
                ForEach(chapters) { chap in
                    let isSelected = (chap.id == activeChap?.id)
                    Button(action: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                            selectedChapterId = chap.id
                        }
                    }) {
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color(hex: chap.colorHex))
                                .frame(width: 8, height: 8)
                            
                            Text(chap.shortTitle)
                                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                .foregroundColor(Color(hex: isSelected ? "#111827" : "#374151"))
                                .lineLimit(1)
                            
                            Spacer()
                            
                            // Importance Pill
                            importanceMiniTag(importance: chap.importance)
                            
                            // Tabular Points
                            Text(String(format: "%.1fđ · %.0f%%", chap.points, chap.percentage * 100))
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(hex: isSelected ? chap.colorHex : "#6B7280"))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(isSelected ? Color(hex: chap.colorHex).opacity(0.08) : Color.clear)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    if chap.id != chapters.last?.id {
                        Divider().padding(.leading, 28)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                    )
            )
        }
    }
    
    private func chapterAngleRange(index: Int, chapters: [CurriculumMindmapChapter]) -> (start: CGFloat, end: CGFloat) {
        let total = chapters.reduce(0.0) { $0 + $1.percentage }
        guard total > 0 else { return (0, 1) }
        
        var current: Double = 0
        for i in 0..<index {
            current += chapters[i].percentage
        }
        let start = CGFloat(current / total)
        let end = CGFloat((current + chapters[index].percentage) / total)
        // subtle 0.005 gap between slices
        let gap: CGFloat = chapters.count > 1 ? 0.004 : 0
        return (start + gap, max(start + gap, end - gap))
    }
    
    // =====================================================================
    // MARK: - VISUALIZATION 2: BIỂU ĐỒ CỘT (HORIZONTAL BAR CHART)
    // =====================================================================
    private var barChartVisualizationView: some View {
        let chapters = currentChapters
        let activeChap = activeChapter ?? chapters.first
        
        return VStack(alignment: .leading, spacing: 14) {
            // Header with scale hint
            HStack {
                Text("TỶ TRỌNG ĐIỂM THI THEO CHUYÊN ĐỀ")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#6B7280"))
                Spacer()
                Text("Thang 10 điểm")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }
            .padding(.horizontal, 4)
            
            // Bar Rows
            VStack(spacing: 12) {
                ForEach(chapters) { chap in
                    let isSelected = (chap.id == activeChap?.id)
                    Button(action: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                            selectedChapterId = chap.id
                        }
                    }) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .center) {
                                Text(chap.title)
                                    .font(.system(size: 13, weight: isSelected ? .bold : .semibold))
                                    .foregroundColor(Color(hex: isSelected ? "#111827" : "#374151"))
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                importanceMiniTag(importance: chap.importance)
                                
                                Text(String(format: "%.1fđ", chap.points))
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .foregroundColor(Color(hex: chap.colorHex))
                            }
                            
                            // Horizontal Bar
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    // Background track
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(hex: "#F3F4F6"))
                                        .frame(height: 12)
                                    
                                    // Filled segment
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(hex: chap.colorHex))
                                        .frame(width: max(geo.size.width * CGFloat(chap.percentage / 0.40), 14), height: 12)
                                }
                            }
                            .frame(height: 12)
                            
                            // Percentage subtitle
                            HStack {
                                Text(chap.description)
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "#6B7280"))
                                    .lineLimit(1)
                                Spacer()
                                Text(String(format: "%.0f%% đề thi", chap.percentage * 100))
                                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                                    .foregroundColor(Color(hex: "#9CA3AF"))
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(isSelected ? Color(hex: chap.colorHex).opacity(0.06) : Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color(hex: isSelected ? chap.colorHex : "#E5E7EB"), lineWidth: isSelected ? 1.5 : 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // =====================================================================
    // MARK: - VISUALIZATION 3: CÂY CHI TIẾT (HIERARCHICAL TREE)
    // =====================================================================
    private var treeVisualizationView: some View {
        VStack(spacing: 12) {
            ForEach(currentChapters) { chap in
                let isExpanded = expandedBranchIds.contains(chap.id)
                VStack(alignment: .leading, spacing: 8) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            if isExpanded {
                                expandedBranchIds.remove(chap.id)
                            } else {
                                expandedBranchIds.insert(chap.id)
                            }
                            selectedChapterId = chap.id
                        }
                    }) {
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color(hex: chap.colorHex))
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Image(systemName: chap.icon)
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 6) {
                                    Text(chap.title)
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(hex: "#111827"))
                                    importanceMiniTag(importance: chap.importance)
                                }
                                Text(chap.description)
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "#6B7280"))
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Text(String(format: "%.1fđ", chap.points))
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(hex: chap.colorHex))
                            
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "#9CA3AF"))
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // Children nodes
                    if isExpanded && !chap.children.isEmpty {
                        VStack(spacing: 6) {
                            ForEach(chap.children) { child in
                                Button(action: {
                                    selectedNodeForSheet = child
                                }) {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color(hex: child.importance.colorHex))
                                            .frame(width: 6, height: 6)
                                        Text(child.title)
                                            .font(.system(size: 12.5, weight: .medium))
                                            .foregroundColor(Color(hex: "#1F2937"))
                                            .lineLimit(1)
                                        Spacer()
                                        importanceMiniTag(importance: child.importance)
                                        Text("Chi tiết")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(Color(hex: "#059669"))
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 9)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.leading, 18)
                    }
                }
            }
        }
    }
    
    // MARK: - Chapter Inspector Card (Clean, 1px border, editorial style)
    private func chapterInspectorCard(chapter: CurriculumMindmapChapter) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        importanceMiniTag(importance: chapter.importance)
                        Text(String(format: "%.1f điểm thi (%.0f%% ma trận)", chapter.points, chapter.percentage * 100))
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(hex: chapter.colorHex))
                    }
                    
                    Text(chapter.title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    Text(chapter.description)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#4B5563"))
                }
                Spacer()
            }
            
            Divider()
            
            // Core Formulas
            if !chapter.formulas.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 5) {
                        Image(systemName: "function")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(hex: "#0D9488"))
                        Text("CÔNG THỨC BẮT BUỘC NHỚ")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "#111827"))
                    }
                    
                    ForEach(chapter.formulas, id: \.self) { f in
                        Text(f)
                            .font(.system(size: 12.5, weight: .medium, design: .monospaced))
                            .foregroundColor(Color(hex: "#1F2937"))
                            .padding(.leading, 10)
                            .overlay(
                                Rectangle().fill(Color(hex: "#0D9488")).frame(width: 2.5),
                                alignment: .leading
                            )
                            .padding(.vertical, 2)
                    }
                }
            }
            
            // Exam Traps
            if !chapter.traps.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 5) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(hex: "#D97706"))
                        Text("BẪY ĐỀ THI BGD THƯỜNG GẶP")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "#111827"))
                    }
                    
                    ForEach(chapter.traps, id: \.self) { t in
                        HStack(alignment: .top, spacing: 6) {
                            Text("⚠️")
                                .font(.system(size: 11))
                            Text(t)
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#374151"))
                        }
                        .padding(.vertical, 1)
                    }
                }
            }
            
            // Shimy AI Ask Action
            Button(action: {
                dismiss()
                onOpenAIChatWithTopic?(chapter.title)
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .bold))
                    Text("Hỏi Shimy AI Giải Thích Bài Này")
                        .font(.system(size: 12.5, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(hex: "#111827"))
                )
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                )
        )
    }
    
    private func importanceMiniTag(importance: NodeImportance) -> some View {
        HStack(spacing: 3) {
            Image(systemName: importance.icon)
                .font(.system(size: 7, weight: .bold))
            Text(importance.rawValue)
                .font(.system(size: 8.5, weight: .heavy))
        }
        .foregroundColor(Color(hex: importance.colorHex))
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
        .background(Capsule().fill(Color(hex: importance.colorHex).opacity(0.12)))
    }
    
    // MARK: - Node Detail Sheet
    private func nodeDetailSheet(node: MindmapNode) -> some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        importanceMiniTag(importance: node.importance)
                        Text(node.title)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        if !node.description.isEmpty {
                            Text(node.description)
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#4B5563"))
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#E5E7EB"), lineWidth: 1))
                    )
                    
                    if !node.formulas.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CÔNG THỨC")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "#6B7280"))
                            ForEach(node.formulas, id: \.self) { f in
                                Text(f)
                                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                                    .foregroundColor(Color(hex: "#111827"))
                                    .padding(.leading, 8)
                                    .overlay(Rectangle().fill(Color(hex: "#059669")).frame(width: 2), alignment: .leading)
                            }
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#E5E7EB"), lineWidth: 1))
                        )
                    }
                    
                    Button(action: {
                        selectedNodeForSheet = nil
                        dismiss()
                        onOpenAIChatWithTopic?(node.title)
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                            Text("Hỏi Shimy AI")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "#111827")))
                    }
                }
                .padding(16)
            }
            .background(Color(hex: "#F8FAF9").ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") { selectedNodeForSheet = nil }
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "#111827"))
                }
            }
        }
    }
    
    // MARK: - Loading View
    private var mindmapGeneratingLoading: some View {
        VStack(spacing: 12) {
            Spacer()
            ProgressView().tint(Color(hex: "#059669"))
            Text("Đang nạp sơ đồ kiến thức trithucAI...")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(hex: "#6B7280"))
            Spacer()
        }
    }
    
    private var activeChapter: CurriculumMindmapChapter? {
        if let id = selectedChapterId, let found = currentChapters.first(where: { $0.id == id }) {
            return found
        }
        return currentChapters.first
    }
    
    // =====================================================================
    // MARK: - DYNAMIC CURRICULUM DATA GENERATOR (trithucAI GROUNDED)
    // =====================================================================
    private var currentChapters: [CurriculumMindmapChapter] {
        let sub = selectedSubject.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let gr = selectedGrade
        let sem = selectedSemester
        
        // 1. Math Curriculum
        if sub == "toán" {
            if gr == 11 {
                if sem == 1 {
                    return [
                        CurriculumMindmapChapter(
                            title: "1. Hàm Số Lượng Giác & Phương Trình Lượng Giác",
                            shortTitle: "Lượng Giác",
                            points: 3.0,
                            percentage: 0.30,
                            importance: .critical,
                            colorHex: "#0284C7",
                            icon: "waveform.path.ecg",
                            description: "Góc lượng giác, đường tròn lượng giác, tập xác định, đồ thị sin/cos/tan/cot.",
                            formulas: [
                                "sin²α + cos²α = 1; tan α · cot α = 1",
                                "sin(a ± b) = sin a · cos b ± cos a · sin b",
                                "cos(a ± b) = cos a · cos b ∓ sin a · sin b",
                                "sin 2x = 2·sin x · cos x; cos 2x = cos²x - sin²x"
                            ],
                            traps: [
                                "Quên đặt điều kiện cos x ≠ 0 khi giải phương trình có chứa tan x.",
                                "Nhầm lẫn giữa họ nghiệm π + k2π và -π + k2π."
                            ],
                            children: [
                                MindmapNode(title: "Góc Lượng Giác & Giá Trị Lượng Giác", importance: .foundation, description: "Hệ số đo radian, góc liên kết hơn kém π, phụ nhau."),
                                MindmapNode(title: "Công Thức Biến Đổi Lượng Giác", importance: .coreFormula, description: "Công thức cộng, nhân đôi, hạ bậc, biến đổi tích thành tổng."),
                                MindmapNode(title: "Phương Trình Lượng Giác Cơ Bản", importance: .critical, description: "sin x = m, cos x = m, tan x = m và phương trình bậc hai theo một hàm số lượng giác.")
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "2. Dãy Số, Cấp Số Cộng & Cấp Số Nhân",
                            shortTitle: "Cấp Số",
                            points: 2.5,
                            percentage: 0.25,
                            importance: .coreFormula,
                            colorHex: "#059669",
                            icon: "number.square.fill",
                            description: "Dãy số tăng giảm, công thức số hạng tổng quát, tính tổng n số hạng đầu.",
                            formulas: [
                                "CSC: un = u1 + (n - 1)·d; Sn = n·(u1 + un)/2 = n·[2u1 + (n - 1)d]/2",
                                "CSN: un = u1 · q^(n - 1); Sn = u1 · (1 - q^n)/(1 - q) (q ≠ 1)",
                                "Tổng CSN lùi vô hạn (|q| < 1): S = u1 / (1 - q)"
                            ],
                            traps: [
                                "Nhầm số mũ của CSN: un = u1 · q^(n-1), rất hay quên trừ 1 ở số mũ.",
                                "Quên điều kiện công bội q ≠ 1 khi áp dụng công thức Sn của cấp số nhân."
                            ],
                            children: [
                                MindmapNode(title: "Cấp Số Cộng (CSC)", importance: .coreFormula, description: "Số hạng tổng quát, tính chất uk = (uk-1 + uk+1)/2, tổng Sn."),
                                MindmapNode(title: "Cấp Số Nhân (CSN)", importance: .critical, description: "Công bội q, số hạng tổng quát, cấp số nhân lùi vô hạn.")
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "3. Giới Hạn & Hàm Số Liên Tục",
                            shortTitle: "Giới Hạn",
                            points: 2.0,
                            percentage: 0.20,
                            importance: .examTrap,
                            colorHex: "#D97706",
                            icon: "arrow.triangle.merge",
                            description: "Giới hạn dãy số, giới hạn hàm số tại một điểm, dạng vô định 0/0, liên tục.",
                            formulas: [
                                "lim (1/n^k) = 0 (k > 0); lim q^n = 0 khi |q| < 1",
                                "lim x->x0 [f(x) / g(x)] dạng 0/0 -> Phân tích nhân tử hoặc nhân liên hợp",
                                "Hàm số liên tục tại x0 <=> lim x->x0 f(x) = f(x0)"
                            ],
                            traps: [
                                "Dạng vô định ∞ - ∞ khi x -> -∞: Phải chú ý đưa x ra ngoài căn có dấu trừ -x.",
                                "Giới hạn một bên x -> x0+ và x -> x0- khác nhau thì không tồn tại giới hạn."
                            ],
                            children: [
                                MindmapNode(title: "Giới Hạn Hàm Số Tại Vô Cực & Một Điểm", importance: .coreFormula, description: "Khử các dạng vô định 0/0, ∞/∞, ∞ - ∞."),
                                MindmapNode(title: "Hàm Số Liên Tục", importance: .examTrap, description: "Xét tính liên tục trên khoảng/đoạn, định lý giá trị trung gian có nghiệm.")
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "4. Quan Hệ Song Song Trong Không Gian",
                            shortTitle: "Hình Không Gian",
                            points: 2.5,
                            percentage: 0.25,
                            importance: .critical,
                            colorHex: "#7C3AED",
                            icon: "cube.transparent.fill",
                            description: "Đường thẳng và mặt phẳng, hai đường thẳng chéo nhau, hai mặt phẳng song song.",
                            formulas: [
                                "Đường thẳng d song song (P): d không thuộc (P) và d // a với a thuộc (P)",
                                "(P) // (Q): Hai đường cắt nhau của (P) lần lượt song song với (Q)",
                                "Định lý Ta-lét trong không gian, thiết diện cắt bởi mặt phẳng song song"
                            ],
                            traps: [
                                "Nhầm hai đường thẳng chéo nhau với hai đường thẳng song song.",
                                "Tìm giao tuyến của 2 mặt phẳng quên tìm điểm chung thứ 2 hoặc phương song song."
                            ],
                            children: [
                                MindmapNode(title: "Đường Thẳng Song Song Mặt Phẳng", importance: .coreFormula, description: "Phương pháp chứng minh đường song song với mặt."),
                                MindmapNode(title: "Hai Mặt Phẳng Song Song", importance: .critical, description: "Tính chất, định lý thiết diện và hình chóp cụt.")
                            ]
                        )
                    ]
                } else if sem == 2 {
                    return [
                        CurriculumMindmapChapter(
                            title: "1. Hàm Số Mũ & Hàm Số Lôgarit",
                            shortTitle: "Mũ & Logarit",
                            points: 3.0,
                            percentage: 0.30,
                            importance: .critical,
                            colorHex: "#0284C7",
                            icon: "function",
                            description: "Lũy thừa số mũ thực, logarit, phương trình và bất phương trình mũ, logarit.",
                            formulas: [
                                "log_a (b · c) = log_a b + log_a c; log_a (b^α) = α · log_a b",
                                "Đổi cơ số: log_a b = (log_c b) / (log_c a)",
                                "(a^x)' = a^x · ln a; (ln x)' = 1 / x"
                            ],
                            traps: [
                                "Quên đặt điều kiện cơ số 0 < a ≠ 1 và biểu thức dưới dấu logarit > 0.",
                                "Bất phương trình log_a f(x) > log_a g(x): Đổi chiều khi 0 < a < 1!"
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "2. Đạo Hàm & Ý Nghĩa Hình Học",
                            shortTitle: "Đạo Hàm",
                            points: 2.5,
                            percentage: 0.25,
                            importance: .critical,
                            colorHex: "#0D9488",
                            icon: "chart.line.uptrend.xyaxis",
                            description: "Quy tắc tính đạo hàm, đạo hàm hàm hợp, phương trình tiếp tuyến của đồ thị.",
                            formulas: [
                                "Phương trình tiếp tuyến tại M(x0; y0): y = f'(x0)·(x - x0) + y0",
                                "(u · v)' = u'v + uv'; (u / v)' = (u'v - uv') / v²",
                                "Đạo hàm hàm hợp: [f(u)]' = f'(u) · u'"
                            ],
                            traps: [
                                "Nhầm giữa tiếp tuyến 'tại điểm' (đã biết x0) và tiếp tuyến 'đi qua điểm' (chưa biết x0)."
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "3. Quan Hệ Vuông Góc Trong Không Gian",
                            shortTitle: "Vuông Góc",
                            points: 2.5,
                            percentage: 0.25,
                            importance: .critical,
                            colorHex: "#7C3AED",
                            icon: "square.split.diagonal.2x2",
                            description: "Đường thẳng vuông góc mặt phẳng, hai mặt phẳng vuông góc, khoảng cách và góc.",
                            formulas: [
                                "d ⊥ (P) <=> d vuông góc với 2 đường cắt nhau nằm trong (P)",
                                "Góc giữa đường và mặt: Góc giữa d và hình chiếu d' của nó trên (P)",
                                "Khoảng cách từ điểm đến mặt phẳng: Kẻ đoạn vuông góc từ điểm đến mặt"
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "4. Một Số Yếu Tố Xác Suất",
                            shortTitle: "Xác Suất",
                            points: 2.0,
                            percentage: 0.20,
                            importance: .coreFormula,
                            colorHex: "#D97706",
                            icon: "dice.fill",
                            description: "Biến cố giao, biến cố hợp, quy tắc cộng và quy tắc nhân xác suất.",
                            formulas: [
                                "P(A ∪ B) = P(A) + P(B) - P(A ∩ B)",
                                "A và B độc lập <=> P(A ∩ B) = P(A) · P(B)"
                            ]
                        )
                    ]
                } else {
                    // Toàn năm lớp 11
                    return [
                        CurriculumMindmapChapter(title: "Học Kỳ 1: Lượng Giác & Dãy Số - Cấp Số", shortTitle: "Học Kỳ 1", points: 5.0, percentage: 0.50, importance: .critical, colorHex: "#0284C7", icon: "1.circle.fill", description: "Hàm số lượng giác, CSC, CSN, Giới hạn và Quan hệ song song."),
                        CurriculumMindmapChapter(title: "Học Kỳ 2: Mũ - Logarit & Đạo Hàm - Vuông Góc", shortTitle: "Học Kỳ 2", points: 5.0, percentage: 0.50, importance: .critical, colorHex: "#059669", icon: "2.circle.fill", description: "Hàm số mũ, logarit, đạo hàm tiếp tuyến, quan hệ vuông góc và xác suất.")
                    ]
                }
            } else if gr == 12 {
                if sem == 1 {
                    return [
                        CurriculumMindmapChapter(
                            title: "1. Ứng Dụng Đạo Hàm Khảo Sát Đồ Thị",
                            shortTitle: "Khảo Sát Hàm Số",
                            points: 3.5,
                            percentage: 0.35,
                            importance: .critical,
                            colorHex: "#0284C7",
                            icon: "chart.xyaxis.line",
                            description: "Tính đơn điệu, cực trị, giá trị lớn nhất nhỏ nhất, đường tiệm cận đứng, ngang, xiên.",
                            formulas: [
                                "Đơn điệu: f'(x) ≥ 0 (hoặc ≤ 0) ∀x ∈ K (bằng 0 tại hữu hạn điểm)",
                                "Cực trị bậc 3: y = ax³ + bx² + cx + d -> y' = 3ax² + 2bx + c (Δ' = b² - 3ac)",
                                "Tiệm cận đứng: lim x->x0⁺ f(x) = ±∞; Tiệm cận ngang: lim x->±∞ f(x) = y0"
                            ],
                            traps: [
                                "Quên kiểm tra nghiệm mẫu số có triệt tiêu với tử số trong bài toán tiệm cận đứng.",
                                "Nhầm lẫn giữa cực trị của hàm số (y) và điểm cực trị của hàm số (x)."
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "2. Vectơ & Tọa Độ Trong Không Gian",
                            shortTitle: "Vectơ Không Gian",
                            points: 2.0,
                            percentage: 0.20,
                            importance: .coreFormula,
                            colorHex: "#0D9488",
                            icon: "arrow.up.right",
                            description: "Vectơ trong không gian, hệ trục Oxyz, tích vô hướng, biểu thức tọa độ.",
                            formulas: [
                                "u · v = |u| · |v| · cos(u, v) = x1·x2 + y1·y2 + z1·z2",
                                "Độ dài vectơ: |u| = √(x² + y² + z²)",
                                "Tích có hướng: [u, v] vuông góc với cả u và v"
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "3. Khối Đa Diện & Khối Tròn Xoay",
                            shortTitle: "Khối Tròn Xoay",
                            points: 2.5,
                            percentage: 0.25,
                            importance: .critical,
                            colorHex: "#7C3AED",
                            icon: "cylinder.split.1x2.fill",
                            description: "Thể tích khối chóp, lăng trụ, diện tích và thể tích khối nón, khối trụ, khối cầu.",
                            formulas: [
                                "Nón: Sxq = π·r·l, V = 1/3·π·r²·h (l² = r² + h²)",
                                "Trụ: Sxq = 2π·r·h, V = π·r²·h; Cầu: S = 4π·R², V = 4/3·π·R³",
                                "Chóp: V = 1/3·S_đáy·h; Lăng trụ: V = S_đáy·h"
                            ],
                            traps: [
                                "Quên nhân hệ số 1/3 ở công thức thể tích khối nón và khối chóp.",
                                "Nhầm lẫn giữa bán kính r và đường kính d = 2r."
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "4. Thống Kê Dữ Liệu Ghép Nhóm",
                            shortTitle: "Thống Kê",
                            points: 2.0,
                            percentage: 0.20,
                            importance: .foundation,
                            colorHex: "#D97706",
                            icon: "chart.bar.fill",
                            description: "Khoảng biến thiên, khoảng tứ phân vị, phương sai và độ lệch chuẩn của mẫu ghép nhóm.",
                            formulas: [
                                "Giá trị đại diện nhóm [a; b): c = (a + b) / 2",
                                "Số trung bình: x̄ = (m1·c1 + ... + mk·ck) / n",
                                "Phương sai s² = 1/n · Σ mi·(ci - x̄)²; Độ lệch chuẩn s = √(s²)"
                            ]
                        )
                    ]
                } else {
                    // HK2 Lớp 12
                    return [
                        CurriculumMindmapChapter(
                            title: "1. Nguyên Hàm, Tích Phân & Ứng Dụng",
                            shortTitle: "Tích Phân",
                            points: 3.5,
                            percentage: 0.35,
                            importance: .critical,
                            colorHex: "#0284C7",
                            icon: "function",
                            description: "Phương pháp đổi biến số, tích phân từng phần, diện tích hình phẳng và thể tích tròn xoay.",
                            formulas: [
                                "Từng phần: ∫ u dv = u·v - ∫ v du",
                                "Diện tích hình phẳng: S = ∫ |f(x) - g(x)| dx",
                                "Thể tích vật thể tròn xoay: V = π · ∫ [f(x)]² dx"
                            ],
                            traps: [
                                "Quên nhân π trong công thức thể tích vật thể tròn xoay quanh trục Ox.",
                                "Quên đặt dấu trị tuyệt đối |f(x) - g(x)| khi hai đồ thị cắt nhau trên đoạn [a; b]."
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "2. Phương Trình Mặt Phẳng, Đường Thẳng & Mặt Cầu (Oxyz)",
                            shortTitle: "Hình Học Oxyz",
                            points: 3.5,
                            percentage: 0.35,
                            importance: .critical,
                            colorHex: "#059669",
                            icon: "cube.fill",
                            description: "Vị trí tương đối, góc, khoảng cách từ điểm đến mặt phẳng, bài toán cực trị Oxyz.",
                            formulas: [
                                "Mặt phẳng (P): A(x - x0) + B(y - y0) + C(z - z0) = 0",
                                "Khoảng cách d(M, P) = |AxM + ByM + CzM + D| / √(A² + B² + C²)",
                                "Mặt cầu: (x - a)² + (y - b)² + (z - c)² = R²"
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "3. Xác Suất Có Điều Kiện & Công Thức Bayes",
                            shortTitle: "Xác Suất BGD",
                            points: 1.5,
                            percentage: 0.15,
                            importance: .examTrap,
                            colorHex: "#D97706",
                            icon: "dice.fill",
                            description: "Xác suất có điều kiện P(A|B), công thức xác suất toàn phần và công thức Bayes chuẩn 2026.",
                            formulas: [
                                "P(A|B) = P(A ∩ B) / P(B) với P(B) > 0",
                                "Xác suất toàn phần: P(B) = P(A1)·P(B|A1) + P(A2)·P(B|A2)"
                            ]
                        ),
                        CurriculumMindmapChapter(
                            title: "4. Ứng Dụng Toán Học Thực Tế Tối Ưu Hóa",
                            shortTitle: "Ứng Dụng Thực Tế",
                            points: 1.5,
                            percentage: 0.15,
                            importance: .coreFormula,
                            colorHex: "#7C3AED",
                            icon: "sparkles",
                            description: "Bài toán thực tế tối ưu hóa chi phí sản xuất, thể tích lớn nhất, bài toán lãi suất kép.",
                            formulas: [
                                "Lãi kép: An = A · (1 + r)^n",
                                "Hàm chi phí tối ưu C(x) đạt cực tiểu khi C'(x) = 0"
                            ]
                        )
                    ]
                }
            } else {
                // Lớp 10
                return [
                    CurriculumMindmapChapter(title: "1. Mệnh Đề, Tập Hợp & Bất Phương Trình", shortTitle: "Mệnh Đề - Tập Hợp", points: 3.0, percentage: 0.30, importance: .foundation, colorHex: "#0284C7", icon: "circle.grid.2x2", description: "Mệnh đề kéo theo, tập con, các phép toán giao hợp hiệu, BPT bậc hai một ẩn."),
                    CurriculumMindmapChapter(title: "2. Hệ Thức Lượng & Vectơ Trong Mặt Phẳng", shortTitle: "Hệ Thức Lượng", points: 3.5, percentage: 0.35, importance: .critical, colorHex: "#059669", icon: "triangle.fill", description: "Định lý cosin a² = b² + c² - 2bc·cos A, định lý sin, công thức diện tích tam giác và vectơ."),
                    CurriculumMindmapChapter(title: "3. Thống Kê & Xác Suất Cổ Điển", shortTitle: "Thống Kê 10", points: 3.5, percentage: 0.35, importance: .coreFormula, colorHex: "#D97706", icon: "chart.bar.fill", description: "Số trung bình, trung vị, mốt, tứ phân vị và xác suất trong trò chơi đơn giản.")
                ]
            }
        }
        
        // 2. Physics Curriculum
        if sub == "vật lí" || sub == "vật ly" {
            if gr == 11 {
                return [
                    CurriculumMindmapChapter(title: "1. Dao Động Điều Hòa", shortTitle: "Dao Động", points: 3.0, percentage: 0.30, importance: .critical, colorHex: "#0284C7", icon: "waveform.path.ecg", description: "Phương trình x = A·cos(ωt + φ), vận tốc sớm pha π/2, gia tốc ngược pha với li độ."),
                    CurriculumMindmapChapter(title: "2. Sóng Điện Từ & Sóng Ánh Sáng", shortTitle: "Sóng", points: 2.5, percentage: 0.25, importance: .coreFormula, colorHex: "#0D9488", icon: "water.waves", description: "Giao thoa sóng ánh sáng: i = λ·D / a, vị trí vân sáng x = k·i, vân tối x = (k + 0.5)·i."),
                    CurriculumMindmapChapter(title: "3. Điện Trường & Thế Năng Điện", shortTitle: "Điện Trường", points: 2.5, percentage: 0.25, importance: .critical, colorHex: "#7C3AED", icon: "bolt.fill", description: "Cường độ điện trường E = F / q = k·|Q| / (ε·r²), tụ điện C = Q / U."),
                    CurriculumMindmapChapter(title: "4. Dòng Điện Không Đổi & Định Luật Ôm", shortTitle: "Dòng Điện", points: 2.0, percentage: 0.20, importance: .foundation, colorHex: "#D97706", icon: "powerplug.fill", description: "Định luật Ôm cho toàn mạch: I = E / (R + r), công và công suất nguồn điện.")
                ]
            } else if gr == 12 {
                return [
                    CurriculumMindmapChapter(title: "1. Dao Động Cơ & Con Lắc", shortTitle: "Dao Động Cơ", points: 3.5, percentage: 0.35, importance: .critical, colorHex: "#0284C7", icon: "waveform", description: "Con lắc lò xo ω = √(k/m), con lắc đơn ω = √(g/l), năng lượng dao động E = 1/2·k·A²."),
                    CurriculumMindmapChapter(title: "2. Sóng Cơ & Giao Thoa Sóng", shortTitle: "Sóng Cơ", points: 2.5, percentage: 0.25, importance: .critical, colorHex: "#059669", icon: "water.waves", description: "Bước sóng λ = v·T = v/f, giao thoa cực đại d2 - d1 = k·λ, sóng dừng có nút và bụng."),
                    CurriculumMindmapChapter(title: "3. Dòng Điện Xoay Chiều RLC", shortTitle: "Điện Xoay Chiều", points: 2.5, percentage: 0.25, importance: .critical, colorHex: "#EA580C", icon: "bolt.fill", description: "Trở kháng Z = √(R² + (ZL - ZC)²), hiện tượng cộng hưởng ZL = ZC, công suất P = U·I·cos φ."),
                    CurriculumMindmapChapter(title: "4. Vật Lí Hạt Nhân & Lượng Tử", shortTitle: "Hạt Nhân", points: 1.5, percentage: 0.15, importance: .coreFormula, colorHex: "#7C3AED", icon: "atom", description: "Hiện tượng quang điện ε = h·f, hệ thức Anh-xtanh E = m·c², định luật phóng xạ.")
                ]
            } else {
                return [
                    CurriculumMindmapChapter(title: "1. Động Học Chất Điểm (Chuyển Động Thẳng)", shortTitle: "Động Học", points: 3.5, percentage: 0.35, importance: .foundation, colorHex: "#0284C7", icon: "car.fill", description: "Chuyển động thẳng đều s = v·t, biến đổi đều v = v0 + at, s = v0·t + 1/2·at², v² - v0² = 2as."),
                    CurriculumMindmapChapter(title: "2. Ba Định Luật Niu-tơn & Các Lực Cơ Học", shortTitle: "Động Lực Học", points: 3.5, percentage: 0.35, importance: .critical, colorHex: "#059669", icon: "scalemass.fill", description: "Định luật II Niu-tơn F = m·a, lực ma sát, lực đàn hồi F = k·|Δl|, lực hấp dẫn."),
                    CurriculumMindmapChapter(title: "3. Năng Lượng, Công & Định Luật Bảo Toàn", shortTitle: "Cơ Năng", points: 3.0, percentage: 0.30, importance: .coreFormula, colorHex: "#D97706", icon: "flame.fill", description: "Công cơ học A = F·s·cos α, động năng Wđ = 1/2·m·v², thế năng Wt = m·g·z, bảo toàn cơ năng.")
                ]
            }
        }
        
        // 3. Chemistry Curriculum
        if sub == "hóa học" || sub == "hóa" {
            if gr == 11 {
                return [
                    CurriculumMindmapChapter(title: "1. Cân Bằng Hóa Học & Thuyết Bronsted", shortTitle: "Cân Bằng Hóa Học", points: 3.0, percentage: 0.30, importance: .critical, colorHex: "#0284C7", icon: "scalemass.fill", description: "Hằng số cân bằng Kc, nguyên lý chuyển dịch cân bằng Lơ Sa-tơ-li-ê, pH dung dịch."),
                    CurriculumMindmapChapter(title: "2. Nitơ - Photpho & Lưu Huỳnh", shortTitle: "Nitơ & Lưu Huỳnh", points: 2.5, percentage: 0.25, importance: .coreFormula, colorHex: "#0D9488", icon: "leaf.fill", description: "Axit HNO3 và H2SO4 đặc có tính oxi hóa mạnh, muối amoni, mưa axit."),
                    CurriculumMindmapChapter(title: "3. Đại Cương Hóa Học Hữu Cơ", shortTitle: "Hữu Cơ Cơ Bản", points: 2.5, percentage: 0.25, importance: .critical, colorHex: "#059669", icon: "circle.hexagonpath.fill", description: "Công thức đơn giản nhất, công thức phân tử, đồng đẳng và đồng phân cấu tạo."),
                    CurriculumMindmapChapter(title: "4. Hiđrocacbon (Ankan, Anken, Aren)", shortTitle: "Hiđrocacbon", points: 2.0, percentage: 0.20, importance: .coreFormula, colorHex: "#D97706", icon: "drop.fill", description: "Phản ứng thế halogen của ankan, phản ứng cộng của anken tuân theo quy tắc Mac-côp-nhi-côp.")
                ]
            } else if gr == 12 {
                return [
                    CurriculumMindmapChapter(title: "1. Este - Lipit (Chất Béo)", shortTitle: "Este & Lipit", points: 3.0, percentage: 0.30, importance: .critical, colorHex: "#EA580C", icon: "drop.fill", description: "Phản ứng thủy phân trong môi trường axit và xà phòng hóa với kiềm NaOH."),
                    CurriculumMindmapChapter(title: "2. Cacbohiđrat & Amin - Peptit", shortTitle: "Amin & Protein", points: 3.0, percentage: 0.30, importance: .critical, colorHex: "#059669", icon: "leaf.fill", description: "Glucozơ, Saccarozơ, Tinh bột, amino axit, liên kết peptit, phản ứng màu biure."),
                    CurriculumMindmapChapter(title: "3. Đại Cương Kim Loại & Dãy Điện Hóa", shortTitle: "Đại Cương Kim Loại", points: 2.5, percentage: 0.25, importance: .coreFormula, colorHex: "#0284C7", icon: "shield.fill", description: "Dãy điện hóa, ăn mòn điện hóa học, phương pháp nhiệt luyện, thủy luyện, điện phân."),
                    CurriculumMindmapChapter(title: "4. Kim Loại Kiềm, Kiềm Thổ & Nhôm", shortTitle: "Kiềm & Nhôm", points: 1.5, percentage: 0.15, importance: .foundation, colorHex: "#7C3AED", icon: "sparkles", description: "Hợp chất lưỡng tính Al(OH)3 và Al2O3, nước cứng và phương pháp làm mềm.")
                ]
            } else {
                return [
                    CurriculumMindmapChapter(title: "1. Cấu Tạo Nguyên Tử & Bảng Tuần Hoàn", shortTitle: "Nguyên Tử & BTH", points: 3.5, percentage: 0.35, importance: .foundation, colorHex: "#0284C7", icon: "atom", description: "Hạt proton, notron, electron, cấu hình electron, quy luật biến đổi tuần hoàn."),
                    CurriculumMindmapChapter(title: "2. Liên Kết Hóa Học (Ion & Cộng Hóa Trị)", shortTitle: "Liên Kết Hóa Học", points: 3.5, percentage: 0.35, importance: .critical, colorHex: "#059669", icon: "link", description: "Quy tắc bát tử (octiet), liên kết cộng hóa trị có cực và không cực, liên kết hiđro."),
                    CurriculumMindmapChapter(title: "3. Phản Ứng Oxi Hóa - Khử", shortTitle: "Oxi Hóa - Khử", points: 3.0, percentage: 0.30, importance: .coreFormula, colorHex: "#D97706", icon: "flame.fill", description: "Xác định số oxi hóa, phương pháp thăng bằng electron: Khử cho - O nhận.")
                ]
            }
        }
        
        // 4. Default for Biology, History, Geography
        return [
            CurriculumMindmapChapter(
                title: "1. Kiến Thức Trọng Tâm Học Kỳ 1 (trithucAI)",
                shortTitle: "Chuyên Đề HK1",
                points: 5.0,
                percentage: 0.50,
                importance: .critical,
                colorHex: "#059669",
                icon: "book.fill",
                description: "Toàn bộ bài học cốt lõi môn \(selectedSubject) Lớp \(selectedGrade) bám sát SGK chuẩn Bộ GD&ĐT.",
                formulas: ["Kiến thức nền tảng và phương pháp tư duy đặc thù môn \(selectedSubject)."],
                traps: ["Tránh nhầm lẫn các khái niệm tương đồng trong đề thi trắc nghiệm."]
            ),
            CurriculumMindmapChapter(
                title: "2. Kiến Thức Nâng Cao Học Kỳ 2 (trithucAI)",
                shortTitle: "Chuyên Đề HK2",
                points: 5.0,
                percentage: 0.50,
                importance: .coreFormula,
                colorHex: "#0284C7",
                icon: "star.fill",
                description: "Chuyên đề phân hóa bứt phá điểm số cao trong các kỳ thi học kỳ và tốt nghiệp.",
                formulas: ["Kỹ năng liên hệ thực tiễn và giải quyết bài toán vận dụng cao."],
                traps: ["Đọc kỹ yêu cầu đề bài tránh bẫy câu hỏi phủ định (KHÔNG đúng)."]
            )
        ]
    }
}
