import SwiftUI

struct MarkdownMessageView: View {
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(parseBlocks(content), id: \.id) { block in
                switch block.type {
                case .header(let level, let text):
                    Text(text)
                        .font(.system(size: level == 1 ? 18 : (level == 2 ? 16 : 14), weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.primaryDark)
                        .padding(.top, 2)
                    
                case .codeBlock(let code):
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Code / Công thức")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primaryMint)
                            Spacer()
                        }
                        Text(code)
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundColor(Color(hex: "#1E293B"))
                            .lineSpacing(3)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#F1F5F9"))
                    )
                    
                case .bullet(let text):
                    HStack(alignment: .top, spacing: 6) {
                        Text("•")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.primaryMint)
                        Text(LocalizedStringKey(text))
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textPrimary)
                            .lineSpacing(3)
                    }
                    
                case .paragraph(let text):
                    Text(LocalizedStringKey(text))
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textPrimary)
                        .lineSpacing(3)
                }
            }
        }
    }
    
    private func parseBlocks(_ text: String) -> [TextBlock] {
        var blocks: [TextBlock] = []
        let lines = text.components(separatedBy: "\n")
        var insideCode = false
        var codeAccumulator: [String] = []
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            if trimmed.hasPrefix("```") {
                if insideCode {
                    insideCode = false
                    blocks.append(TextBlock(type: .codeBlock(codeAccumulator.joined(separator: "\n"))))
                    codeAccumulator.removeAll()
                } else {
                    insideCode = true
                }
                continue
            }
            
            if insideCode {
                codeAccumulator.append(line)
                continue
            }
            
            if trimmed.isEmpty { continue }
            
            if trimmed.hasPrefix("### ") {
                blocks.append(TextBlock(type: .header(3, String(trimmed.dropFirst(4)))))
            } else if trimmed.hasPrefix("## ") {
                blocks.append(TextBlock(type: .header(2, String(trimmed.dropFirst(3)))))
            } else if trimmed.hasPrefix("# ") {
                blocks.append(TextBlock(type: .header(1, String(trimmed.dropFirst(2)))))
            } else if trimmed.hasPrefix("* ") || trimmed.hasPrefix("- ") {
                blocks.append(TextBlock(type: .bullet(String(trimmed.dropFirst(2)))))
            } else {
                blocks.append(TextBlock(type: .paragraph(trimmed)))
            }
        }
        
        if insideCode && !codeAccumulator.isEmpty {
            blocks.append(TextBlock(type: .codeBlock(codeAccumulator.joined(separator: "\n"))))
        }
        
        return blocks
    }
}

enum BlockType {
    case header(Int, String)
    case codeBlock(String)
    case bullet(String)
    case paragraph(String)
}

struct TextBlock: Identifiable {
    let id = UUID()
    let type: BlockType
}
