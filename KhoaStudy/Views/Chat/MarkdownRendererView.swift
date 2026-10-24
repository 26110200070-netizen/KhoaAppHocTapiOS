import SwiftUI

enum MarkdownBlock: Identifiable {
    case header(text: String, level: Int, id: String)
    case paragraph(text: String, id: String)
    case code(code: String, language: String, id: String)
    case math(formula: String, id: String)
    case table(headers: [String], rows: [[String]], id: String)
    case bulletList(items: [String], id: String)
    case numberedList(items: [(Int, String)], id: String)
    case quote(text: String, id: String)
    case divider(id: String)
    
    var id: String {
        switch self {
        case .header(_, _, let id): return id
        case .paragraph(_, let id): return id
        case .code(_, _, let id): return id
        case .math(_, let id): return id
        case .table(_, _, let id): return id
        case .bulletList(_, let id): return id
        case .numberedList(_, let id): return id
        case .quote(_, let id): return id
        case .divider(let id): return id
        }
    }
}

struct MarkdownRendererView: View {
    let content: String
    
    var blocks: [MarkdownBlock] {
        MarkdownParser.parse(content)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(blocks) { block in
                renderBlock(block)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func renderBlock(_ block: MarkdownBlock) -> some View {
        switch block {
        case .header(let text, let level, _):
            renderHeader(text: text, level: level)
            
        case .paragraph(let text, _):
            Text(LocalizedStringKey(sanitizeInlineMath(text)))
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "#1F2937"))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
            
        case .code(let code, let language, _):
            renderCodeBlock(code: code, language: language)
            
        case .math(let formula, _):
            renderMathBlock(formula: formula)
            
        case .table(let headers, let rows, _):
            renderTableBlock(headers: headers, rows: rows)
            
        case .bulletList(let items, _):
            VStack(alignment: .leading, spacing: 6) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppTheme.primaryMint)
                        Text(LocalizedStringKey(sanitizeInlineMath(item)))
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "#1F2937"))
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.leading, 4)
            
        case .numberedList(let items, _):
            VStack(alignment: .leading, spacing: 6) {
                ForEach(items, id: \.0) { num, item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(num).")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.primary)
                            .frame(width: 22, alignment: .leading)
                        Text(LocalizedStringKey(sanitizeInlineMath(item)))
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "#1F2937"))
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.leading, 4)
            
        case .quote(let text, _):
            HStack(alignment: .top, spacing: 12) {
                Rectangle()
                    .fill(AppTheme.primaryMint)
                    .frame(width: 3)
                Text(LocalizedStringKey(sanitizeInlineMath(text)))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#374151"))
                    .lineSpacing(4)
                    .padding(.vertical, 2)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color(hex: "#F9FAFB"))
            .cornerRadius(6)
            
        case .divider:
            Divider()
                .padding(.vertical, 4)
        }
    }
    
    // MARK: - Headers (Hỗ trợ toàn diện H1 đến H6)
    private func renderHeader(text: String, level: Int) -> some View {
        let size: CGFloat = {
            switch level {
            case 1: return 20
            case 2: return 18
            case 3: return 16
            case 4: return 15
            case 5: return 14
            default: return 13.5
            }
        }()
        
        let weight: Font.Weight = {
            switch level {
            case 1: return .heavy
            case 2: return .bold
            case 3: return .bold
            case 4: return .bold
            default: return .semibold
            }
        }()
        
        let color: Color = {
            switch level {
            case 1, 2: return Color(hex: "#111827")
            case 3, 4: return Color(hex: "#1F2937")
            default: return Color(hex: "#374151")
            }
        }()
        
        return VStack(alignment: .leading, spacing: 4) {
            Text(LocalizedStringKey(sanitizeInlineMath(text)))
                .font(.system(size: size, weight: weight, design: .rounded))
                .foregroundColor(color)
                .padding(.top, level <= 2 ? 8 : (level <= 4 ? 6 : 3))
            
            if level <= 2 {
                Rectangle()
                    .fill(level == 1 ? AppTheme.primaryMint : Color(hex: "#E5E7EB"))
                    .frame(height: level == 1 ? 2.5 : 1.5)
                    .frame(maxWidth: level == 1 ? 60 : .infinity, alignment: .leading)
            }
        }
    }
    
    // MARK: - Code Block with Header and Copy
    private func renderCodeBlock(code: String, language: String) -> some View {
        VStack(spacing: 0) {
            // Header bar
            HStack {
                Text(language.isEmpty ? "CODE" : language.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(hex: "#94A3B8"))
                
                Spacer()
                
                Button(action: {
                    UIPasteboard.general.string = code
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.on.doc")
                        Text("Sao chép")
                    }
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "#38BDF8"))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color(hex: "#0F172A"))
            
            // Code content
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(Color(hex: "#F8FAFC"))
                    .lineSpacing(3)
                    .padding(14)
            }
            .background(Color(hex: "#1E293B"))
        }
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#334155"), lineWidth: 1)
        )
    }
    
    // MARK: - Math Block (Toán Học & Công Thức)
    private func renderMathBlock(formula: String) -> some View {
        let clean = formatMathFormula(formula)
        return VStack(alignment: .leading, spacing: 8) {
            // Header with badge and copy button
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "function")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppTheme.primaryDark)
                    Text("CÔNG THỨC TOÁN HỌC")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .foregroundColor(AppTheme.primaryDark)
                }
                
                Spacer()
                
                Button(action: {
                    UIPasteboard.general.string = clean
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.on.doc")
                        Text("Sao chép")
                    }
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(AppTheme.primaryMint)
                }
            }
            .padding(.bottom, 2)
            
            // Formula rendering
            ScrollView(.horizontal, showsIndicators: false) {
                Text(clean)
                    .font(.system(size: 17, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "#0F172A"))
                    .lineSpacing(4)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 2)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color(hex: "#F0FDF4"), Color(hex: "#ECFDF5")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppTheme.primaryMint.opacity(0.35), lineWidth: 1.2)
        )
        .shadow(color: AppTheme.primaryMint.opacity(0.08), radius: 6, x: 0, y: 2)
        .padding(.vertical, 4)
    }
    
    // MARK: - Tables (Phong cách tối giản, hiện đại như ChatGPT iOS - Ảnh 2)
    private func renderTableBlock(headers: [String], rows: [[String]]) -> some View {
        let colWidths = calculateColumnWidths(headers: headers, rows: rows)
        
        return ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // 1. Table Header (Tiêu đề in đậm, không viền khung bao quanh, không phân cách cột dọc)
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(headers.enumerated()), id: \.offset) { idx, header in
                        let cleanHeader = sanitizeInlineMath(header.trimmingCharacters(in: .whitespaces))
                        Text(LocalizedStringKey(cleanHeader))
                            .font(.system(size: 13.5, weight: .bold))
                            .foregroundColor(Color(hex: "#111827"))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .frame(width: colWidths[idx], alignment: .topLeading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                // 2. Đường kẻ ngang thanh mảnh ngăn cách Header (Chuẩn Ảnh 2)
                Rectangle()
                    .fill(Color(hex: "#E5E7EB"))
                    .frame(height: 1)
                
                // 3. Table Data Rows (Mỗi hàng có đường kẻ ngang mờ ngăn cách)
                ForEach(Array(rows.enumerated()), id: \.offset) { rowIdx, row in
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(Array(headers.indices), id: \.self) { colIdx in
                                let rawCell = colIdx < row.count ? row[colIdx].trimmingCharacters(in: .whitespaces) : ""
                                let cellText = sanitizeInlineMath(rawCell)
                                
                                Text(LocalizedStringKey(cellText))
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "#1F2937"))
                                    .lineSpacing(3)
                                    .padding(.vertical, 9)
                                    .padding(.horizontal, 8)
                                    .frame(width: colWidths[colIdx], alignment: .topLeading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        // Đường kẻ ngang mảnh giữa các hàng
                        Rectangle()
                            .fill(Color(hex: "#F1F5F9"))
                            .frame(height: 0.8)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    // Tính toán độ rộng cột thông minh, linh hoạt theo nội dung, không gò bó cố định quá lớn (Chuẩn Ảnh 2)
    private func calculateColumnWidths(headers: [String], rows: [[String]]) -> [CGFloat] {
        let totalCols = max(1, headers.count)
        
        return headers.indices.map { colIdx in
            let headerText = headers[colIdx].trimmingCharacters(in: .whitespaces)
            var maxWordLen = 0
            for word in headerText.components(separatedBy: .whitespacesAndNewlines) {
                maxWordLen = max(maxWordLen, word.count)
            }
            var maxLineLen = headerText.count
            var totalChars = headerText.count
            var cellCount = 1
            
            for row in rows {
                if colIdx < row.count {
                    let cell = row[colIdx].trimmingCharacters(in: .whitespaces)
                    for word in cell.components(separatedBy: .whitespacesAndNewlines) {
                        maxWordLen = max(maxWordLen, word.count)
                    }
                    let lines = cell.components(separatedBy: "\n")
                    for l in lines {
                        maxLineLen = max(maxLineLen, l.trimmingCharacters(in: .whitespaces).count)
                    }
                    totalChars += cell.count
                    cellCount += 1
                }
            }
            
            let avgChars = totalChars / max(1, cellCount)
            let contentWidth: CGFloat = CGFloat(max(maxWordLen * 9 + 16, min(maxLineLen * 8 + 16, avgChars * 8 + 24)))
            
            if totalCols == 1 {
                return max(180, min(320, contentWidth))
            } else if totalCols == 2 {
                if colIdx == 0 {
                    return max(80, min(140, contentWidth))
                } else {
                    return max(140, min(230, contentWidth))
                }
            } else if totalCols == 3 {
                if colIdx == 0 {
                    return max(70, min(110, contentWidth))
                } else if colIdx == 1 {
                    return max(110, min(170, contentWidth))
                } else {
                    return max(80, min(130, contentWidth))
                }
            } else if totalCols == 4 {
                // Tối ưu tỉ lệ hiển thị cho bảng 4 cột như Ảnh 2 (Ngày: ~70pt, Công việc: ~130pt, Thời gian: ~90pt, Trạng thái: ~75pt)
                if colIdx == 0 {
                    return max(60, min(80, contentWidth))
                } else if colIdx == 1 {
                    return max(110, min(145, contentWidth))
                } else if colIdx == 2 {
                    return max(80, min(105, contentWidth))
                } else {
                    return max(65, min(90, contentWidth))
                }
            } else {
                // Bảng từ 5 cột trở lên: tự động cuộn ngang mượt mà
                return max(70, min(140, contentWidth))
            }
        }
    }
    
    // Convert common LaTeX formula notations into clean mathematical Unicode
    private func sanitizeInlineMath(_ text: String) -> String {
        return MathSanitizer.sanitize(text)
    }
    
    private func formatMathFormula(_ formula: String) -> String {
        var f = formula.trimmingCharacters(in: .whitespacesAndNewlines)
        if f.hasPrefix("$$") && f.hasSuffix("$$") && f.count >= 4 {
            f = String(f.dropFirst(2).dropLast(2))
        } else if f.hasPrefix("\\[") && f.hasSuffix("\\]") && f.count >= 4 {
            f = String(f.dropFirst(2).dropLast(2))
        }
        f = f.replacingOccurrences(of: "\\[", with: "").replacingOccurrences(of: "\\]", with: "")
        return MathSanitizer.sanitize(f)
    }
}

// MARK: - Mathematical Formula & LaTeX Sanitizer
public struct MathSanitizer {
    public static func sanitize(_ input: String) -> String {
        var str = input
        
        // 0. Clean <br> variants into newlines
        str = str.replacingOccurrences(of: "<br>", with: "\n", options: .caseInsensitive)
        str = str.replacingOccurrences(of: "<br/>", with: "\n", options: .caseInsensitive)
        str = str.replacingOccurrences(of: "<br />", with: "\n", options: .caseInsensitive)
        
        // 1. Unpack \boxed{...}
        str = unpackBoxed(str)
        
        // 2. Remove LaTeX display / spacing macros
        str = str.replacingOccurrences(of: "\\displaystyle", with: "")
        str = str.replacingOccurrences(of: "\\qquad", with: "   ")
        str = str.replacingOccurrences(of: "\\quad", with: "  ")
        str = str.replacingOccurrences(of: "\\enspace", with: " ")
        str = str.replacingOccurrences(of: "\\!", with: "")
        str = str.replacingOccurrences(of: "\\,", with: " ")
        str = str.replacingOccurrences(of: "\\:", with: " ")
        str = str.replacingOccurrences(of: "\\;", with: " ")
        
        // 3. Process brackets & parentheses modifiers
        str = str.replacingOccurrences(of: "\\bigl[", with: "[")
        str = str.replacingOccurrences(of: "\\bigr]", with: "]")
        str = str.replacingOccurrences(of: "\\Bigl[", with: "[")
        str = str.replacingOccurrences(of: "\\Bigr]", with: "]")
        str = str.replacingOccurrences(of: "\\left[", with: "[")
        str = str.replacingOccurrences(of: "\\right]", with: "]")
        
        str = str.replacingOccurrences(of: "\\bigl(", with: "(")
        str = str.replacingOccurrences(of: "\\bigr)", with: ")")
        str = str.replacingOccurrences(of: "\\Bigl(", with: "(")
        str = str.replacingOccurrences(of: "\\Bigr)", with: ")")
        str = str.replacingOccurrences(of: "\\left(", with: "(")
        str = str.replacingOccurrences(of: "\\right)", with: ")")
        
        str = str.replacingOccurrences(of: "\\bigl\\{", with: "{")
        str = str.replacingOccurrences(of: "\\bigr\\}", with: "}")
        str = str.replacingOccurrences(of: "\\left\\{", with: "{")
        str = str.replacingOccurrences(of: "\\right\\}", with: "}")
        
        str = str.replacingOccurrences(of: "\\bigl|", with: "|")
        str = str.replacingOccurrences(of: "\\bigr|", with: "|")
        str = str.replacingOccurrences(of: "\\left|", with: "|")
        str = str.replacingOccurrences(of: "\\right|", with: "|")
        str = str.replacingOccurrences(of: "\\left.", with: "")
        str = str.replacingOccurrences(of: "\\right.", with: "")
        
        // 4. Derivatives notation: \frac{d}{dx} -> d/dx, (d) / (dx) -> d/dx
        str = str.replacingOccurrences(of: "(d) / (dx)", with: "d/dx")
        str = str.replacingOccurrences(of: "(d)/(dx)", with: "d/dx")
        str = str.replacingOccurrences(of: "\\frac{d}{dx}", with: "d/dx")
        str = str.replacingOccurrences(of: "\\frac{df}{dx}", with: "df/dx")
        str = str.replacingOccurrences(of: "\\frac{dy}{dx}", with: "dy/dx")
        str = str.replacingOccurrences(of: "\\frac{du}{dx}", with: "du/dx")
        str = str.replacingOccurrences(of: "\\frac{d}{dt}", with: "d/dt")
        
        // 5. Nested fractions: \frac{num}{denom}
        str = replaceFractions(str)
        
        // 6. Square roots: \sqrt[n]{x} and \sqrt{x}
        str = replaceRoots(str)
        
        // 7. Standard Functions
        let functions = ["\\sin", "\\cos", "\\tan", "\\cot", "\\sec", "\\csc",
                         "\\arcsin", "\\arccos", "\\arctan", "\\ln", "\\log", "\\exp",
                         "\\lim", "\\min", "\\max", "\\det"]
        for fn in functions {
            let bareName = String(fn.dropFirst())
            str = str.replacingOccurrences(of: fn + "(", with: bareName + "(")
            str = str.replacingOccurrences(of: fn + " ", with: bareName + " ")
            str = str.replacingOccurrences(of: fn, with: bareName)
        }
        
        // 8. Number sets
        str = str.replacingOccurrences(of: "\\mathbb{R}", with: "ℝ")
        str = str.replacingOccurrences(of: "\\mathbb{N}", with: "ℕ")
        str = str.replacingOccurrences(of: "\\mathbb{Z}", with: "ℤ")
        str = str.replacingOccurrences(of: "\\mathbb{Q}", with: "ℚ")
        str = str.replacingOccurrences(of: "\\mathbb{C}", with: "ℂ")
        
        // 9. Calculus & multi-letter commands (MUST BE BEFORE \\in!)
        str = str.replacingOccurrences(of: "\\iint", with: "∬")
        str = str.replacingOccurrences(of: "\\iiint", with: "∭")
        str = str.replacingOccurrences(of: "\\oint", with: "∮")
        str = str.replacingOccurrences(of: "\\int", with: "∫")
        str = str.replacingOccurrences(of: "\\infty", with: "∞")
        str = str.replacingOccurrences(of: "\\inf", with: "inf")
        str = str.replacingOccurrences(of: "\\notin", with: " ∉ ")
        str = str.replacingOccurrences(of: "\\\\in(?![a-zA-Z])", with: " ∈ ", options: .regularExpression)
        
        // 10. Set theory & logic
        str = str.replacingOccurrences(of: "\\setminus", with: " \\ ")
        str = str.replacingOccurrences(of: "\\subset", with: "⊂")
        str = str.replacingOccurrences(of: "\\subseteq", with: "⊆")
        str = str.replacingOccurrences(of: "\\supset", with: "⊃")
        str = str.replacingOccurrences(of: "\\cap", with: "∩")
        str = str.replacingOccurrences(of: "\\cup", with: "∪")
        str = str.replacingOccurrences(of: "\\emptyset", with: "∅")
        str = str.replacingOccurrences(of: "\\forall", with: "∀")
        str = str.replacingOccurrences(of: "\\exists", with: "∃")
        
        // 11. Inequalities & relations
        str = str.replacingOccurrences(of: "\\leq", with: "≤")
        str = str.replacingOccurrences(of: "\\le", with: "≤")
        str = str.replacingOccurrences(of: "\\geq", with: "≥")
        str = str.replacingOccurrences(of: "\\ge", with: "≥")
        str = str.replacingOccurrences(of: "\\neq", with: "≠")
        str = str.replacingOccurrences(of: "\\ne", with: "≠")
        str = str.replacingOccurrences(of: "\\approx", with: "≈")
        str = str.replacingOccurrences(of: "\\equiv", with: "≡")
        
        // 12. Arrows
        str = str.replacingOccurrences(of: "\\Leftrightarrow", with: "⇔")
        str = str.replacingOccurrences(of: "\\Rightarrow", with: "⇒")
        str = str.replacingOccurrences(of: "\\rightarrow", with: "→")
        str = str.replacingOccurrences(of: "\\to", with: "→")
        
        // 13. Operations & symbols
        str = str.replacingOccurrences(of: "\\times", with: "×")
        str = str.replacingOccurrences(of: "\\div", with: "÷")
        str = str.replacingOccurrences(of: "\\pm", with: "±")
        str = str.replacingOccurrences(of: "\\mp", with: "∓")
        str = str.replacingOccurrences(of: "\\cdot", with: "·")
        str = str.replacingOccurrences(of: "\\sum", with: "∑")
        str = str.replacingOccurrences(of: "\\prod", with: "∏")
        str = str.replacingOccurrences(of: "\\partial", with: "∂")
        str = str.replacingOccurrences(of: "\\nabla", with: "∇")
        
        // 13. Greek letters
        str = str.replacingOccurrences(of: "\\Delta", with: "Δ")
        str = str.replacingOccurrences(of: "\\delta", with: "δ")
        str = str.replacingOccurrences(of: "\\pi", with: "π")
        str = str.replacingOccurrences(of: "\\alpha", with: "α")
        str = str.replacingOccurrences(of: "\\beta", with: "β")
        str = str.replacingOccurrences(of: "\\gamma", with: "γ")
        str = str.replacingOccurrences(of: "\\theta", with: "θ")
        str = str.replacingOccurrences(of: "\\lambda", with: "λ")
        str = str.replacingOccurrences(of: "\\sigma", with: "σ")
        str = str.replacingOccurrences(of: "\\omega", with: "ω")
        str = str.replacingOccurrences(of: "\\Omega", with: "Ω")
        str = str.replacingOccurrences(of: "\\mu", with: "μ")
        
        // 14. Formatting wrappers: \text{...}, \mathbf{...}, etc.
        str = removeLatexWrappers(str)
        
        // 15. Superscripts & Subscripts: handles both ^{...} and ^x, _{...} and _x
        str = replaceSuperscriptsAndSubscripts(str)
        
        // 16. Clean inline LaTeX delimiters \( and \) or $ and $$
        str = cleanInlineDelimiters(str)
        
        // 17. Convert task checkboxes [ ] and [x] (Chuẩn checklist như Ảnh 2)
        str = str.replacingOccurrences(of: "[ ]", with: "⬜")
        str = str.replacingOccurrences(of: "[x]", with: "✅")
        str = str.replacingOccurrences(of: "[X]", with: "✅")
        
        // 18. Clean stray markdown header hashes in inline strings
        let rogueHashRegex = try? NSRegularExpression(pattern: "(?m)^#{1,6}\\s*(.+)$", options: [])
        if let rhr = rogueHashRegex {
            let nsRange = NSRange(str.startIndex..<str.endIndex, in: str)
            str = rhr.stringByReplacingMatches(in: str, options: [], range: nsRange, withTemplate: "**$1**")
        }
        
        // 19. Clean redundant spaces
        str = str.replacingOccurrences(of: "  +", with: " ", options: .regularExpression)
        
        return str.trimmingCharacters(in: .whitespaces)
    }
    
    private static func cleanInlineDelimiters(_ text: String) -> String {
        var str = text
        // Handle \( ... \)
        while let openRange = str.range(of: "\\(") {
            guard let closeRange = str.range(of: "\\)", range: openRange.upperBound..<str.endIndex) else {
                str.removeSubrange(openRange)
                break
            }
            let inner = String(str[openRange.upperBound..<closeRange.lowerBound]).trimmingCharacters(in: .whitespaces)
            let replacement: String
            if inner.count == 1, let ch = inner.first, ch.isLetter {
                replacement = "*\(inner)*"
            } else {
                replacement = inner
            }
            str.replaceSubrange(openRange.lowerBound..<closeRange.upperBound, with: replacement)
        }
        
        // Handle $ ... $
        str = str.replacingOccurrences(of: "$$", with: "")
        let dollarRegex = try? NSRegularExpression(pattern: "\\$([^\\$]+)\\$", options: [])
        if let regex = dollarRegex {
            let range = NSRange(str.startIndex..<str.endIndex, in: str)
            str = regex.stringByReplacingMatches(in: str, options: [], range: range, withTemplate: "$1")
        }
        
        // Remove stray \[ and \]
        str = str.replacingOccurrences(of: "\\[", with: "")
        str = str.replacingOccurrences(of: "\\]", with: "")
        str = str.replacingOccurrences(of: "\\(", with: "")
        str = str.replacingOccurrences(of: "\\)", with: "")
        
        return str
    }
    
    private static func unpackBoxed(_ text: String) -> String {
        var str = text
        while let range = str.range(of: "\\boxed{") {
            let innerStart = range.upperBound
            guard let innerEnd = findMatchingBrace(in: str, startingAt: innerStart) else {
                break
            }
            let inner = String(str[innerStart..<innerEnd])
            str.replaceSubrange(range.lowerBound...innerEnd, with: inner)
        }
        return str
    }
    
    // Balanced brace parser for fractions \frac{num}{denom}
    private static func replaceFractions(_ text: String) -> String {
        var result = text
        var searchStart = result.startIndex
        
        while let range = result.range(of: "\\frac{", range: searchStart..<result.endIndex) {
            let numStart = range.upperBound
            guard let numEnd = findMatchingBrace(in: result, startingAt: numStart) else {
                searchStart = range.upperBound
                continue
            }
            let numerator = String(result[numStart..<numEnd])
            
            let afterNum = result.index(after: numEnd)
            guard afterNum < result.endIndex, result[afterNum] == "{" else {
                searchStart = range.upperBound
                continue
            }
            let denomStart = result.index(after: afterNum)
            guard let denomEnd = findMatchingBrace(in: result, startingAt: denomStart) else {
                searchStart = range.upperBound
                continue
            }
            let denominator = String(result[denomStart..<denomEnd])
            
            // Recursively sanitize numerator and denominator
            let cleanNum = replaceFractions(numerator).trimmingCharacters(in: .whitespaces)
            let cleanDenom = replaceFractions(denominator).trimmingCharacters(in: .whitespaces)
            
            let formatted: String
            if cleanNum == "d" && cleanDenom == "dx" {
                formatted = "d/dx"
            } else if cleanNum == "df" && cleanDenom == "dx" {
                formatted = "df/dx"
            } else if cleanNum == "du" && cleanDenom == "dx" {
                formatted = "du/dx"
            } else if cleanNum == "dy" && cleanDenom == "dx" {
                formatted = "dy/dx"
            } else if cleanNum.count <= 2 && cleanDenom.count <= 2 {
                formatted = "\(cleanNum)/\(cleanDenom)"
            } else {
                formatted = "(\(cleanNum)) / (\(cleanDenom))"
            }
            let replaceRange = range.lowerBound...denomEnd
            result.replaceSubrange(replaceRange, with: formatted)
            searchStart = result.index(range.lowerBound, offsetBy: formatted.count, limitedBy: result.endIndex) ?? result.endIndex
        }
        
        return result
    }
    
    // Balanced brace parser for \sqrt{expr} and \sqrt[n]{expr}
    private static func replaceRoots(_ text: String) -> String {
        var result = text
        var searchStart = result.startIndex
        
        while let range = result.range(of: "\\sqrt{", range: searchStart..<result.endIndex) {
            let innerStart = range.upperBound
            guard let innerEnd = findMatchingBrace(in: result, startingAt: innerStart) else {
                searchStart = range.upperBound
                continue
            }
            let inner = String(result[innerStart..<innerEnd])
            let formatted = "√(\(inner))"
            result.replaceSubrange(range.lowerBound...innerEnd, with: formatted)
            searchStart = result.index(range.lowerBound, offsetBy: formatted.count, limitedBy: result.endIndex) ?? result.endIndex
        }
        
        result = result.replacingOccurrences(of: "\\sqrt", with: "√")
        return result
    }
    
    private static func findMatchingBrace(in text: String, startingAt: String.Index) -> String.Index? {
        var depth = 1
        var curr = startingAt
        while curr < text.endIndex {
            if text[curr] == "{" {
                depth += 1
            } else if text[curr] == "}" {
                depth -= 1
                if depth == 0 {
                    return curr
                }
            }
            curr = text.index(after: curr)
        }
        return nil
    }
    
    private static func removeLatexWrappers(_ text: String) -> String {
        var str = text
        let wrappers = ["\\text{", "\\mathrm{", "\\mathbf{", "\\mathit{", "\\operatorname{"]
        for w in wrappers {
            var searchStart = str.startIndex
            while let range = str.range(of: w, range: searchStart..<str.endIndex) {
                let innerStart = range.upperBound
                guard let innerEnd = findMatchingBrace(in: str, startingAt: innerStart) else {
                    searchStart = range.upperBound
                    continue
                }
                let inner = String(str[innerStart..<innerEnd])
                str.replaceSubrange(range.lowerBound...innerEnd, with: inner)
                searchStart = range.lowerBound
            }
        }
        return str
    }
    
    private static func replaceSuperscriptsAndSubscripts(_ text: String) -> String {
        var str = text
        
        let supCharMap: [Character: Character] = [
            "0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴",
            "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹",
            "+": "⁺", "-": "⁻", "=": "⁼", "(": "⁽", ")": "⁾", "/": "ᐟ",
            "a": "ᵃ", "b": "ᵇ", "c": "ᶜ", "d": "ᵈ", "e": "ᵉ",
            "f": "ᶠ", "g": "ᵍ", "h": "ʰ", "i": "ⁱ", "j": "ʲ",
            "k": "ᵏ", "l": "ˡ", "m": "ᵐ", "n": "ⁿ", "o": "ᵒ",
            "p": "ᵖ", "r": "ʳ", "s": "ˢ", "t": "ᵗ", "u": "ᵘ",
            "v": "ᵛ", "w": "ʷ", "x": "ˣ", "y": "ʸ", "z": "ᶻ"
        ]
        
        func convertSup(_ raw: String) -> String {
            let inner = raw.trimmingCharacters(in: .whitespaces)
            if inner == "1/2" { return "½" }
            if inner == "-1/2" { return "⁻½" }
            if inner == "1/3" { return "⅓" }
            if inner == "1/4" { return "¼" }
            if inner == "3/4" { return "¾" }
            
            var converted = ""
            var allOk = true
            for ch in inner {
                if let s = supCharMap[ch] {
                    converted.append(s)
                } else if ch == " " {
                    // skip
                } else {
                    allOk = false
                    break
                }
            }
            return allOk ? converted : "^(\(inner))"
        }
        
        // 1. First handle braces: ^{content}
        while let range = str.range(of: "^{") {
            let innerStart = range.upperBound
            guard let innerEnd = findMatchingBrace(in: str, startingAt: innerStart) else {
                break
            }
            let inner = String(str[innerStart..<innerEnd])
            let replacement = convertSup(inner)
            str.replaceSubrange(range.lowerBound...innerEnd, with: replacement)
        }
        
        // 2. Handle parentheses: ^(...)
        let parenRegex = try? NSRegularExpression(pattern: "\\^\\(([^\\(\\)]+)\\)", options: [])
        if let regex = parenRegex {
            var searchRange = NSRange(str.startIndex..<str.endIndex, in: str)
            while let match = regex.firstMatch(in: str, options: [], range: searchRange) {
                if let r = Range(match.range(at: 1), in: str), let fullR = Range(match.range, in: str) {
                    let inner = String(str[r])
                    let replacement = convertSup(inner)
                    str.replaceSubrange(fullR, with: replacement)
                    let newEnd = str.index(fullR.lowerBound, offsetBy: replacement.count)
                    searchRange = NSRange(newEnd..<str.endIndex, in: str)
                } else {
                    break
                }
            }
        }
        
        // 3. Handle simple single-character superscripts ^x, ^u, ^2
        for (ch, sup) in supCharMap {
            str = str.replacingOccurrences(of: "^\(ch)", with: String(sup))
        }
        
        // 4. Handle subscripts with braces: _{content}
        let subCharMap: [Character: Character] = [
            "0": "₀", "1": "₁", "2": "₂", "3": "₃", "4": "₄",
            "5": "₅", "6": "₆", "7": "₇", "8": "₈", "9": "₉",
            "+": "₊", "-": "₋", "=": "₌", "(": "₍", ")": "₎",
            "a": "ₐ", "e": "ₑ", "h": "ₕ", "i": "ᵢ", "j": "ⱼ",
            "k": "ₖ", "l": "ₗ", "m": "ₘ", "n": "ₙ", "o": "ₒ",
            "p": "ₚ", "r": "ᵣ", "s": "ₛ", "t": "ₜ", "u": "ᵤ", "v": "ᵥ", "x": "ₓ"
        ]
        while let range = str.range(of: "_{") {
            let innerStart = range.upperBound
            guard let innerEnd = findMatchingBrace(in: str, startingAt: innerStart) else {
                break
            }
            let inner = String(str[innerStart..<innerEnd]).trimmingCharacters(in: .whitespaces)
            var converted = ""
            var allConvertible = true
            for ch in inner {
                if let sub = subCharMap[ch] {
                    converted.append(sub)
                } else if ch == " " {
                    // skip
                } else {
                    allConvertible = false
                    break
                }
            }
            let replacement = allConvertible ? converted : "_(\(inner))"
            str.replaceSubrange(range.lowerBound...innerEnd, with: replacement)
        }
        
        // 5. Handle simple single-character subscripts
        for (ch, sub) in subCharMap {
            str = str.replacingOccurrences(of: "_\(ch)", with: String(sub))
        }
        
        return str
    }
}

// MARK: - Markdown Parser
class MarkdownParser {
    static func parse(_ raw: String) -> [MarkdownBlock] {
        var blocks: [MarkdownBlock] = []
        var text = raw.replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\r", with: "\n")
        
        // Tách header viết liền sau câu văn trên cùng một dòng thành dòng riêng
        let headerBreakRegex = try? NSRegularExpression(pattern: "([^\n])\\s+(#{1,6}\\s+)", options: [])
        if let regex = headerBreakRegex {
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            text = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "$1\n\n$2")
        }
        
        let lines = text.components(separatedBy: "\n")
        var i = 0
        var blockId = 0
        
        while i < lines.count {
            let line = lines[i]
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            // 1. Code Block (```)
            if trimmed.hasPrefix("```") {
                let language = String(trimmed.dropFirst(3)).trimmingCharacters(in: .whitespaces)
                var codeLines: [String] = []
                i += 1
                while i < lines.count {
                    if lines[i].trimmingCharacters(in: .whitespaces).hasPrefix("```") {
                        i += 1
                        break
                    }
                    codeLines.append(lines[i])
                    i += 1
                }
                blocks.append(.code(code: codeLines.joined(separator: "\n"), language: language, id: "code_\(blockId)"))
                blockId += 1
                continue
            }
            
            // 2. Math Block ($$ ... $$, \[ ... \], or standalone \boxed{...})
            if trimmed.hasPrefix("$$") || trimmed.hasPrefix("\\[") || trimmed.hasPrefix("\\boxed{") {
                var mathLines: [String] = [trimmed]
                if !trimmed.hasSuffix("$$") && !trimmed.hasSuffix("\\]") || trimmed == "$$" || trimmed == "\\[" {
                    i += 1
                    while i < lines.count {
                        let cur = lines[i].trimmingCharacters(in: .whitespaces)
                        mathLines.append(cur)
                        i += 1
                        if cur.hasSuffix("$$") || cur.hasSuffix("\\]") || cur.isEmpty {
                            break
                        }
                    }
                } else {
                    i += 1
                }
                blocks.append(.math(formula: mathLines.joined(separator: "\n"), id: "math_\(blockId)"))
                blockId += 1
                continue
            }
            
            // 3. Table Block (| ... | hoặc col 1 | col 2)
            if trimmed.contains("|") && i + 1 < lines.count && (lines[i + 1].contains("---") || lines[i + 1].contains("-|-")) {
                let headerCells = parseTableRow(trimmed)
                i += 2 // skip header and separator line (|---|---|)
                var rows: [[String]] = []
                while i < lines.count {
                    let tableLine = lines[i].trimmingCharacters(in: .whitespaces)
                    if tableLine.contains("|") && !tableLine.isEmpty {
                        rows.append(parseTableRow(tableLine))
                        i += 1
                    } else {
                        break
                    }
                }
                if !headerCells.isEmpty && !rows.isEmpty {
                    blocks.append(.table(headers: headerCells, rows: rows, id: "table_\(blockId)"))
                    blockId += 1
                    continue
                }
            }
            
            // 4. Header (#, ##, ###, ####, #####, ######) - Hỗ trợ đầy đủ mọi cấp độ markdown header
            if trimmed.hasPrefix("#") {
                let hashCount = trimmed.prefix(while: { $0 == "#" }).count
                if hashCount >= 1 {
                    let level = min(hashCount, 6)
                    var headerText = String(trimmed.dropFirst(hashCount)).trimmingCharacters(in: .whitespaces)
                    // Bỏ dấu thăng cuối câu nếu có (vd: "### Tiêu đề ###")
                    while headerText.hasSuffix("#") {
                        headerText.removeLast()
                    }
                    headerText = headerText.trimmingCharacters(in: .whitespaces)
                    if !headerText.isEmpty {
                        blocks.append(.header(text: headerText, level: level, id: "h\(level)_\(blockId)"))
                        blockId += 1
                        i += 1
                        continue
                    } else {
                        // Dòng chỉ toàn dấu thăng không có chữ, bỏ qua
                        i += 1
                        continue
                    }
                }
            }
            
            // 5. Divider (--- or *** or ___)
            if trimmed == "---" || trimmed == "***" || trimmed == "___" {
                blocks.append(.divider(id: "div_\(blockId)"))
                blockId += 1
                i += 1
                continue
            }
            
            // 6. Blockquote (> ...)
            if trimmed.hasPrefix(">") {
                var quoteLines: [String] = []
                while i < lines.count && lines[i].trimmingCharacters(in: .whitespaces).hasPrefix(">") {
                    let clean = String(lines[i].trimmingCharacters(in: .whitespaces).dropFirst()).trimmingCharacters(in: .whitespaces)
                    quoteLines.append(clean)
                    i += 1
                }
                blocks.append(.quote(text: quoteLines.joined(separator: " "), id: "quote_\(blockId)"))
                blockId += 1
                continue
            }
            
            // 7. Bullet List (- , * , • , + )
            if trimmed.hasPrefix("- ") || trimmed.hasPrefix("* ") || trimmed.hasPrefix("• ") || trimmed.hasPrefix("+ ") {
                var items: [String] = []
                while i < lines.count {
                    let cur = lines[i].trimmingCharacters(in: .whitespaces)
                    if cur.hasPrefix("- ") || cur.hasPrefix("* ") || cur.hasPrefix("• ") || cur.hasPrefix("+ ") {
                        items.append(String(cur.dropFirst(2)).trimmingCharacters(in: .whitespaces))
                        i += 1
                    } else {
                        break
                    }
                }
                blocks.append(.bulletList(items: items, id: "bullet_\(blockId)"))
                blockId += 1
                continue
            }
            
            // 8. Numbered List (1. , 2. )
            if let firstChar = trimmed.first, firstChar.isNumber, trimmed.contains(". ") {
                var items: [(Int, String)] = []
                while i < lines.count {
                    let cur = lines[i].trimmingCharacters(in: .whitespaces)
                    if let dotIndex = cur.firstIndex(of: "."), let num = Int(cur[..<dotIndex]) {
                        let text = String(cur[cur.index(after: dotIndex)...]).trimmingCharacters(in: .whitespaces)
                        items.append((num, text))
                        i += 1
                    } else {
                        break
                    }
                }
                if !items.isEmpty {
                    blocks.append(.numberedList(items: items, id: "numbered_\(blockId)"))
                    blockId += 1
                    continue
                }
            }
            
            // 9. Standard Paragraph (Skip pure empty lines)
            if !trimmed.isEmpty {
                var paraLines: [String] = [trimmed]
                i += 1
                while i < lines.count {
                    let next = lines[i].trimmingCharacters(in: .whitespaces)
                    if next.isEmpty || next.hasPrefix("#") || next.hasPrefix("```") || (next.contains("|") && i + 1 < lines.count && lines[i+1].contains("---")) || next.hasPrefix("- ") || next.hasPrefix("* ") || next.hasPrefix("• ") || next.hasPrefix("+ ") || next.hasPrefix(">") || (next.first?.isNumber == true && next.contains(". ")) {
                        break
                    }
                    paraLines.append(next)
                    i += 1
                }
                blocks.append(.paragraph(text: paraLines.joined(separator: "\n"), id: "para_\(blockId)"))
                blockId += 1
                continue
            }
            
            i += 1
        }
        
        return blocks
    }
    
    private static func parseTableRow(_ line: String) -> [String] {
        var trimmed = line.trimmingCharacters(in: .whitespaces)
        if trimmed.hasPrefix("|") { trimmed.removeFirst() }
        if trimmed.hasSuffix("|") { trimmed.removeLast() }
        return trimmed.components(separatedBy: "|").map { rawCell in
            var text = rawCell.trimmingCharacters(in: .whitespaces)
            text = text.replacingOccurrences(of: "<br>", with: "\n", options: .caseInsensitive)
            text = text.replacingOccurrences(of: "<br/>", with: "\n", options: .caseInsensitive)
            text = text.replacingOccurrences(of: "<br />", with: "\n", options: .caseInsensitive)
            text = text.replacingOccurrences(of: "&nbsp;", with: " ")
            return text
        }
    }
}
