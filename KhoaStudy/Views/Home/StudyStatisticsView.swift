import SwiftUI

/// Sơ Đồ Thống Kê Học Tập - Hiển thị 100% SỐ LIỆU THỰC TẾ
/// Lấy dữ liệu từ StudyHistoryStore (bài học thật), ExamHistoryStore (điểm thi thật) và AppState (thời gian tự học & phiên Pomodoro thật)
/// Thiết kế chuẩn hiện đại: Phẳng, thoáng, KHÔNG khung lồng khung (Single-layer clean surface)
struct StudyStatisticsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @ObservedObject private var historyStore = StudyHistoryStore.shared
    @ObservedObject private var examStore = ExamHistoryStore.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F8FAF9")
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        // 1. User Header & Title
                        headerOverviewSection
                        
                        // 2. 4-Box Key Metrics Grid (Single-layer cards, flat & modern)
                        keyMetricsGrid
                        
                        // 3. Subject Distribution Breakdown (100% Real from historyStore)
                        subjectBreakdownSection
                        
                        // 4. Grade & Semester Progress (100% Real from historyStore)
                        gradeAndSemesterSection
                        
                        // 5. Exam & Practice Performance (100% Real from examStore)
                        examPerformanceSection
                        
                        // 6. Recent Learning Activity Log (100% Real)
                        recentActivityLogSection
                        
                        Spacer().frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .bold))
                            Text("Trang Chủ")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(AppTheme.primaryDark)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Sơ Đồ Thống Kê")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.textPrimary)
                }
            }
        }
    }
    
    // MARK: - 1. Header Overview
    // MARK: - 1. Header Overview (Quiet typography, no floating circles)
    private var headerOverviewSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color(hex: "#059669"))
                    .frame(width: 6, height: 6)
                Text("DỮ LIỆU THỰC TẾ • LỚP \(appState.currentUser.grade)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#059669"))
                    .tracking(0.6)
            }
            
            Text("Sơ Đồ Thống Kê Học Tập")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
            
            Text("Ghi nhận chính xác 100% thời gian tự học, bài học hoàn thành và kết quả thi.")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#6B7280"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
    
    // MARK: - 2. Key Metrics Unified Surface (Single-layer 2x2 grid, NO floating cards)
    private var keyMetricsGrid: some View {
        let totalHours = appState.totalStudyMinutes / 60
        let totalMins = appState.totalStudyMinutes % 60
        let timeString: String
        if appState.totalStudyMinutes == 0 {
            timeString = "0 phút"
        } else if totalHours > 0 {
            timeString = "\(totalHours)h \(totalMins)p"
        } else {
            timeString = "\(totalMins) phút"
        }
        
        let lessonCount = historyStore.historyList.count
        let examCount = examStore.records.count
        
        return VStack(spacing: 0) {
            HStack(spacing: 0) {
                kpiCell(value: timeString, label: "TỰ HỌC", icon: "clock.fill", color: Color(hex: "#0284C7"))
                Divider().frame(height: 52)
                kpiCell(value: "\(lessonCount) bài", label: "ĐÃ HỌC", icon: "book.fill", color: Color(hex: "#059669"))
            }
            
            Divider()
            
            HStack(spacing: 0) {
                kpiCell(value: "\(appState.focusSessionCount) phiên", label: "TREO MÁY", icon: "flame.fill", color: Color(hex: "#EA580C"))
                Divider().frame(height: 52)
                kpiCell(value: "\(examCount) đề", label: "ĐÃ THI", icon: "doc.text.fill", color: Color(hex: "#7C3AED"))
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
    }
    
    private func kpiCell(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 11))
                    .foregroundColor(color)
                Text(label)
                    .font(.system(size: 10.5, weight: .bold))
                    .foregroundColor(Color(hex: "#6B7280"))
                    .tracking(0.5)
            }
            
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
    
    // MARK: - 3. Subject Breakdown Section (Flat single-layer card)
    private var subjectBreakdownSection: some View {
        let stats = computeRealSubjectStats()
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("PHÂN BỐ KIẾN THỨC THEO MÔN")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#6B7280"))
                    .tracking(0.5)
                Spacer()
                Text("\(historyStore.historyList.count) bài đã ghi nhận")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }
            
            if stats.isEmpty {
                VStack(spacing: 4) {
                    Text("Chưa có bài học nào được ghi nhận")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "#6B7280"))
                    Text("Hãy chọn bài học trong 'Học lý thuyết' để bắt đầu tích lũy dữ liệu")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
            } else {
                // Stacked Multi-Color Progress Bar
                GeometryReader { geo in
                    HStack(spacing: 2) {
                        ForEach(stats) { item in
                            let w = max(geo.size.width * CGFloat(item.percentage) / 100.0, 6)
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(item.color)
                                .frame(width: w, height: 8)
                        }
                    }
                }
                .frame(height: 8)
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                
                // Subject Details Rows (Flat with hairlines)
                VStack(spacing: 0) {
                    ForEach(stats) { item in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(item.color)
                                .frame(width: 8, height: 8)
                            
                            Text(item.name)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(hex: "#1F2937"))
                            
                            Spacer()
                            
                            Text("\(item.lessonCount) bài · \(Int(item.percentage))%")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(hex: "#4B5563"))
                        }
                        .padding(.vertical, 8)
                        
                        if item.id != stats.last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
    }
    
    // MARK: - 4. Grade & Semester Progress (Flat single-layer card)
    private var gradeAndSemesterSection: some View {
        let total = max(historyStore.historyList.count, 1)
        let g12 = historyStore.historyList.filter { $0.topicItem.grade == 12 }.count
        let g11 = historyStore.historyList.filter { $0.topicItem.grade == 11 }.count
        let g10 = historyStore.historyList.filter { $0.topicItem.grade == 10 }.count
        
        let sem1 = historyStore.historyList.filter { $0.topicItem.semester == 1 }.count
        let sem2 = historyStore.historyList.filter { $0.topicItem.semester == 2 }.count
        
        let hasData = !historyStore.historyList.isEmpty
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("PHÂN BỐ KHỐI LỚP & HỌC KÌ")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(hex: "#6B7280"))
                .tracking(0.5)
            
            VStack(spacing: 10) {
                realProgressBar(title: "Lớp 12", count: g12, total: hasData ? total : 0, color: Color(hex: "#059669"))
                realProgressBar(title: "Lớp 11", count: g11, total: hasData ? total : 0, color: Color(hex: "#0284C7"))
                realProgressBar(title: "Lớp 10", count: g10, total: hasData ? total : 0, color: Color(hex: "#9333EA"))
            }
            
            Divider().padding(.vertical, 2)
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Circle().fill(Color(hex: "#059669")).frame(width: 6, height: 6)
                    Text("Học kì 1: \(sem1) bài (\(hasData ? Int(Double(sem1)/Double(total)*100) : 0)%)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#374151"))
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    Circle().fill(Color(hex: "#0284C7")).frame(width: 6, height: 6)
                    Text("Học kì 2: \(sem2) bài (\(hasData ? Int(Double(sem2)/Double(total)*100) : 0)%)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#374151"))
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
    }
    
    private func realProgressBar(title: String, count: Int, total: Int, color: Color) -> some View {
        let pct = total > 0 ? Double(count) / Double(total) : 0.0
        return VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title)
                    .font(.system(size: 12.5, weight: .medium))
                    .foregroundColor(Color(hex: "#1F2937"))
                Spacer()
                Text("\(count) bài (\(Int(pct * 100))%)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(count > 0 ? color : Color(hex: "#9CA3AF"))
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(hex: "#F3F4F6"))
                        .frame(height: 6)
                    
                    if count > 0 {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(color)
                            .frame(width: max(geo.size.width * CGFloat(pct), 6), height: 6)
                    }
                }
            }
            .frame(height: 6)
        }
    }
    
    // MARK: - 5. Exam Performance (Flat single-layer card)
    private var examPerformanceSection: some View {
        let records = Array(examStore.recent5Records.reversed())
        let avg = examStore.averageScore
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("KẾT QUẢ LUYỆN ĐỀ")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#6B7280"))
                    .tracking(0.5)
                
                Spacer()
                
                if let avg = avg {
                    Text("ĐTB: \(String(format: "%.1f", avg)) / 10")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "#DC2626"))
                } else {
                    Text("Chưa có điểm")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
            }
            
            if records.isEmpty {
                VStack(spacing: 4) {
                    Text("Chưa có bài thi nào được thực hiện")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "#6B7280"))
                    Text("Làm bài kiểm tra ở mục 'Ôn thi bứt phá' để lưu điểm")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
            } else {
                HStack(alignment: .bottom, spacing: 14) {
                    ForEach(Array(records.enumerated()), id: \.element.id) { index, rec in
                        realBarChartColumn(
                            label: rec.shortDate,
                            score: rec.score,
                            maxScore: 10.0,
                            color: rec.score >= 8.0 ? Color(hex: "#059669") : (rec.score >= 5.0 ? Color(hex: "#0284C7") : Color(hex: "#DC2626"))
                        )
                    }
                }
                .frame(height: 110)
                .padding(.top, 4)
                
                Divider()
                
                HStack(spacing: 14) {
                    HStack(spacing: 4) {
                        Circle().fill(Color(hex: "#059669")).frame(width: 6, height: 6)
                        Text("Giỏi (>= 8.0)").font(.system(size: 11)).foregroundColor(Color(hex: "#6B7280"))
                    }
                    HStack(spacing: 4) {
                        Circle().fill(Color(hex: "#0284C7")).frame(width: 6, height: 6)
                        Text("Khá (5.0 - 7.9)").font(.system(size: 11)).foregroundColor(Color(hex: "#6B7280"))
                    }
                    HStack(spacing: 4) {
                        Circle().fill(Color(hex: "#DC2626")).frame(width: 6, height: 6)
                        Text("Cần ôn (< 5.0)").font(.system(size: 11)).foregroundColor(Color(hex: "#6B7280"))
                    }
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
    }
    
    private func realBarChartColumn(label: String, score: Double, maxScore: Double, color: Color) -> some View {
        let fraction = CGFloat(max(0.1, score / maxScore))
        let barHeight = max(90 * fraction, 16)
        
        return VStack(spacing: 6) {
            Text(String(format: "%.1f", score))
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.7), color],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: barHeight)
            
            Text(label)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - 6. Recent Learning Activity Log (Flat single-layer card)
    private var recentActivityLogSection: some View {
        let history = Array(historyStore.historyList.prefix(5))
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("NHẬT KÝ HỌC TẬP GẦN ĐÂY")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(hex: "#6B7280"))
                .tracking(0.5)
            
            if history.isEmpty {
                Text("Chưa có hoạt động học nào gần đây.")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 0) {
                    ForEach(history) { item in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color(hex: "#059669"))
                                .frame(width: 6, height: 6)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.topicItem.title)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(hex: "#1F2937"))
                                    .lineLimit(1)
                                
                                Text("\(item.topicItem.subject) • Lớp \(item.topicItem.grade) • \(item.sectionHeader)")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "#6B7280"))
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        
                        if item.id != history.last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
    }
    
    // MARK: - Helper to compute Real Subject Stats
    private struct SubjectStatItem: Identifiable {
        let id = UUID()
        let name: String
        let lessonCount: Int
        let percentage: Double
        let color: Color
    }
    
    private func computeRealSubjectStats() -> [SubjectStatItem] {
        let history = historyStore.historyList
        guard !history.isEmpty else { return [] }
        
        let subjects = [
            ("Toán", Color(hex: "#0284C7")),
            ("Vật lí", Color(hex: "#7C3AED")),
            ("Hóa học", Color(hex: "#EA580C")),
            ("Sinh học", Color(hex: "#059669")),
            ("Lịch sử", Color(hex: "#DC2626")),
            ("Địa lí", Color(hex: "#0D9488"))
        ]
        
        var counts: [String: Int] = [:]
        for item in history {
            counts[item.topicItem.subject, default: 0] += 1
        }
        
        let total = history.count
        var result: [SubjectStatItem] = []
        for (subName, col) in subjects {
            let count = counts[subName] ?? 0
            if count > 0 {
                let pct = (Double(count) / Double(total)) * 100.0
                result.append(SubjectStatItem(name: subName, lessonCount: count, percentage: pct, color: col))
            }
        }
        return result
    }
}
