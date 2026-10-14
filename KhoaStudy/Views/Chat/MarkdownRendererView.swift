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
    
    // MARK: - Headers
    private func renderHeader(text: String, level: Int) -> some View {
        let size: CGFloat = level == 1 ? 20 : (level == 2 ? 17 : 15)
        let weight: Font.Weight = level == 1 ? .heavy : .bold
        
        return VStack(alignment: .leading, spacing: 4) {
            Text(LocalizedStringKey(text))
                .font(.system(size: size, weight: weight, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
                .padding(.top, level == 1 ? 8 : 4)
            
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
        HStack {
            Spacer()
            VStack(spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "function")
                        .font(.caption2)
                        .foregroundColor(AppTheme.primary)
                    Text("CÔNG THỨC TOÁN HỌC")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(AppTheme.primary)
                }
                
                Text(formatMathFormula(formula))
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundColor(Color(hex: "#0F172A"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "#F0FDF4"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(AppTheme.primaryMint.opacity(0.3), lineWidth: 1)
            )
            Spacer()
        }
    }
    
    // MARK: - Tables (KẺ BẢNG MARKDOWN)
    private func renderTableBlock(headers: [String], rows: [[String]]) -> some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 0) {
                // Table Header
                HStack(spacing: 0) {
                    ForEach(Array(headers.enumerated()), id: \.offset) { idx, header in
                        Text(header.trimmingCharacters(in: .whitespaces))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(hex: "#111827"))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .frame(minWidth: 100, alignment: .leading)
                        
                        if idx < headers.count - 1 {
                            Divider().frame(height: 24)
                        }
                    }
                }
                .background(Color(hex: "#E0F2FE"))
                
                Divider()
                
                // Table Rows
                ForEach(Array(rows.enumerated()), id: \.offset) { rowIdx, row in
                    HStack(spacing: 0) {
                        ForEach(Array(headers.indices), id: \.self) { colIdx in
                            let cellText = colIdx < row.count ? row[colIdx].trimmingCharacters(in: .whitespaces) : ""
                            Text(LocalizedStringKey(sanitizeInlineMath(cellText)))
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#374151"))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .frame(minWidth: 100, alignment: .leading)
                            
                            if colIdx < headers.count - 1 {
                                Divider().frame(height: 20)
                            }
                        }
                    }
                    .background(rowIdx % 2 == 0 ? Color.white : Color(hex: "#F8FAFC"))
                    
                    if rowIdx < rows.count - 1 {
                        Divider()
                    }
                }
            }
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#CBD5E1"), lineWidth: 1)
            )
        }
        .padding(.vertical, 4)
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
        return MathSanitizer.sanitize(f)
    }
}

// MARK: - Mathematical Formula & LaTeX Sanitizer
public struct MathSanitizer {
    public static func sanitize(_ input: String) -> String {
        var str = input
        
        // 1. Process nested fractions: \frac{num}{denom}
        str = replaceFractions(str)
        
        // 2. Process square roots: \sqrt[n]{x} and \sqrt{x}
        str = replaceRoots(str)
        
        // 3. Number set symbols
        str = str.replacingOccurrences(of: "\\mathbb{R}", with: "ℝ")
        str = str.replacingOccurrences(of: "\\mathbb{N}", with: "ℕ")
        str = str.replacingOccurrences(of: "\\mathbb{Z}", with: "ℤ")
        str = str.replacingOccurrences(of: "\\mathbb{Q}", with: "ℚ")
        str = str.replacingOccurrences(of: "\\mathbb{C}", with: "ℂ")
        
        // 4. Set theory & logic operations
        str = str.replacingOccurrences(of: "\\setminus", with: " \\ ")
        str = str.replacingOccurrences(of: "\\subset", with: "⊂")
        str = str.replacingOccurrences(of: "\\subseteq", with: "⊆")
        str = str.replacingOccurrences(of: "\\supset", with: "⊃")
        str = str.replacingOccurrences(of: "\\cap", with: "∩")
        str = str.replacingOccurrences(of: "\\cup", with: "∪")
        str = str.replacingOccurrences(of: "\\notin", with: "∉")
        str = str.replacingOccurrences(of: "\\in", with: "∈")
        str = str.replacingOccurrences(of: "\\emptyset", with: "∅")
        str = str.replacingOccurrences(of: "\\forall", with: "∀")
        str = str.replacingOccurrences(of: "\\exists", with: "∃")
        
        // 5. Inequalities & equivalences
        str = str.replacingOccurrences(of: "\\leq", with: "≤")
        str = str.replacingOccurrences(of: "\\le", with: "≤")
        str = str.replacingOccurrences(of: "\\geq", with: "≥")
        str = str.replacingOccurrences(of: "\\ge", with: "≥")
        str = str.replacingOccurrences(of: "\\neq", with: "≠")
        str = str.replacingOccurrences(of: "\\ne", with: "≠")
        str = str.replacingOccurrences(of: "\\approx", with: "≈")
        str = str.replacingOccurrences(of: "\\equiv", with: "≡")
        
        // 6. Arrows
        str = str.replacingOccurrences(of: "\\Leftrightarrow", with: "⇔")
        str = str.replacingOccurrences(of: "\\Rightarrow", with: "⇒")
        str = str.replacingOccurrences(of: "\\rightarrow", with: "→")
        str = str.replacingOccurrences(of: "\\to", with: "→")
        
        // 7. Operations & constants
        str = str.replacingOccurrences(of: "\\times", with: "×")
        str = str.replacingOccurrences(of: "\\div", with: "÷")
        str = str.replacingOccurrences(of: "\\pm", with: "±")
        str = str.replacingOccurrences(of: "\\mp", with: "∓")
        str = str.replacingOccurrences(of: "\\cdot", with: "·")
        str = str.replacingOccurrences(of: "\\infty", with: "∞")
        str = str.replacingOccurrences(of: "\\int", with: "∫")
        str = str.replacingOccurrences(of: "\\sum", with: "∑")
        
        // 8. Greek letters
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
        
        // 9. Formatting wrappers: \text{...}, \mathbf{...}, \mathrm{...}
        str = removeLatexWrappers(str)
        
        // 10. Superscripts & subscripts
        str = replaceSuperscriptsAndSubscripts(str)
        
        // 11. Clean dollar signs $...$ and $$...$$
        str = str.replacingOccurrences(of: "$$", with: "")
        let dollarRegex = try? NSRegularExpression(pattern: "\\$([^\\$]+)\\$", options: [])
        if let regex = dollarRegex {
            let range = NSRange(str.startIndex..<str.endIndex, in: str)
            str = regex.stringByReplacingMatches(in: str, options: [], range: range, withTemplate: "$1")
        }
        
        // 12. Normalize multiple spaces
        str = str.replacingOccurrences(of: "  +", with: " ", options: .regularExpression)
        
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
            
            let formatted = "(\(cleanNum)) / (\(cleanDenom))"
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
        let superscripts: [(String, String)] = [
            ("^0", "⁰"), ("^1", "¹"), ("^2", "²"), ("^3", "³"), ("^4", "⁴"),
            ("^5", "⁵"), ("^6", "⁶"), ("^7", "⁷"), ("^8", "⁸"), ("^9", "⁹"),
            ("^+", "⁺"), ("^-", "⁻"), ("^n", "ⁿ"), ("^x", "ˣ"), ("^y", "ʸ")
        ]
        for (pattern, replacement) in superscripts {
            str = str.replacingOccurrences(of: pattern, with: replacement)
        }
        
        let subscripts: [(String, String)] = [
            ("_0", "₀"), ("_1", "₁"), ("_2", "₂"), ("_3", "₃"), ("_4", "₄"),
            ("_5", "₅"), ("_6", "₆"), ("_7", "₇"), ("_8", "₈"), ("_9", "₉"),
            ("_n", "ₙ"), ("_i", "ᵢ"), ("_j", "ⱼ")
        ]
        for (pattern, replacement) in subscripts {
            str = str.replacingOccurrences(of: pattern, with: replacement)
        }
        return str
    }
}

// MARK: - Markdown Parser
class MarkdownParser {
    static func parse(_ raw: String) -> [MarkdownBlock] {
        var blocks: [MarkdownBlock] = []
        let lines = raw.components(separatedBy: "\n")
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
            
            // 2. Math Block ($$ ... $$)
            if trimmed.hasPrefix("$$") || trimmed.hasPrefix("\\[") {
                var mathLines: [String] = [trimmed]
                if !trimmed.hasSuffix("$$") && !trimmed.hasSuffix("\\]") || trimmed == "$$" || trimmed == "\\[" {
                    i += 1
                    while i < lines.count {
                        let cur = lines[i].trimmingCharacters(in: .whitespaces)
                        mathLines.append(cur)
                        i += 1
                        if cur.hasSuffix("$$") || cur.hasSuffix("\\]") {
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
            
            // 3. Table Block (| ... |)
            if trimmed.hasPrefix("|") && trimmed.hasSuffix("|") && i + 1 < lines.count && lines[i + 1].contains("---") {
                let headerCells = parseTableRow(trimmed)
                i += 2 // skip header and separator line (|---|---|)
                var rows: [[String]] = []
                while i < lines.count {
                    let tableLine = lines[i].trimmingCharacters(in: .whitespaces)
                    if tableLine.hasPrefix("|") && tableLine.hasSuffix("|") {
                        rows.append(parseTableRow(tableLine))
                        i += 1
                    } else {
                        break
                    }
                }
                blocks.append(.table(headers: headerCells, rows: rows, id: "table_\(blockId)"))
                blockId += 1
                continue
            }
            
            // 4. Header (#, ##, ###)
            if trimmed.hasPrefix("# ") {
                blocks.append(.header(text: String(trimmed.dropFirst(2)), level: 1, id: "h1_\(blockId)"))
                blockId += 1
                i += 1
                continue
            } else if trimmed.hasPrefix("## ") {
                blocks.append(.header(text: String(trimmed.dropFirst(3)), level: 2, id: "h2_\(blockId)"))
                blockId += 1
                i += 1
                continue
            } else if trimmed.hasPrefix("### ") {
                blocks.append(.header(text: String(trimmed.dropFirst(4)), level: 3, id: "h3_\(blockId)"))
                blockId += 1
                i += 1
                continue
            }
            
            // 5. Divider (--- or ***)
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
            
            // 7. Bullet List (- , * , • )
            if trimmed.hasPrefix("- ") || trimmed.hasPrefix("* ") || trimmed.hasPrefix("• ") {
                var items: [String] = []
                while i < lines.count {
                    let cur = lines[i].trimmingCharacters(in: .whitespaces)
                    if cur.hasPrefix("- ") || cur.hasPrefix("* ") || cur.hasPrefix("• ") {
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
                    if next.isEmpty || next.hasPrefix("#") || next.hasPrefix("```") || next.hasPrefix("|") || next.hasPrefix("- ") || next.hasPrefix("* ") || next.hasPrefix(">") || (next.first?.isNumber == true && next.contains(". ")) {
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
        return trimmed.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces) }
    }
}
