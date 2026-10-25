import SwiftUI
import WebKit

/// Trình hiển thị Markdown & LaTeX toán học toàn diện trên toàn ứng dụng bằng KaTeX + Marked.js
/// Hỗ trợ đầy đủ: $...$, \(...\), $$...$$, \[...\], \mathbb{N}, \dots, \cdots, \frac, \sqrt, aligned, cases, ma trận, bảng biểu và tiếng Việt
struct MarkdownRendererView: View {
    let content: String
    var fontSize: CGFloat = 15.0
    
    @State private var dynamicHeight: CGFloat = 36
    
    init(content: String, fontSize: CGFloat = 15.0) {
        self.content = content
        self.fontSize = fontSize
    }
    
    var body: some View {
        KaTeXMarkdownWebView(
            content: content,
            fontSize: fontSize,
            dynamicHeight: $dynamicHeight
        )
        .frame(height: max(26, dynamicHeight))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - WKWebView KaTeX & Marked.js Engine
struct KaTeXMarkdownWebView: UIViewRepresentable {
    let content: String
    var fontSize: CGFloat
    @Binding var dynamicHeight: CGFloat
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        if #available(iOS 14.0, *) {
            config.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        
        let contentController = config.userContentController
        contentController.add(context.coordinator, name: "heightHandler")
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.navigationDelegate = context.coordinator
        
        context.coordinator.webView = webView
        context.coordinator.loadHTML(content: content, fontSize: fontSize)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if context.coordinator.lastRenderedContent != content {
            context.coordinator.updateContent(content: content)
        }
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: KaTeXMarkdownWebView
        weak var webView: WKWebView?
        var lastRenderedContent: String = ""
        var isLoaded: Bool = false
        
        init(_ parent: KaTeXMarkdownWebView) {
            self.parent = parent
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "heightHandler", let height = message.body as? CGFloat, height > 10 {
                DispatchQueue.main.async {
                    if abs(self.parent.dynamicHeight - height) > 2 {
                        self.parent.dynamicHeight = height
                    }
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoaded = true
            updateContent(content: parent.content)
        }
        
        func loadHTML(content: String, fontSize: CGFloat) {
            lastRenderedContent = content
            let html = buildHTMLTemplate(fontSize: fontSize)
            webView?.loadHTMLString(html, baseURL: URL(string: "https://cdn.jsdelivr.net"))
        }
        
        func updateContent(content: String) {
            lastRenderedContent = content
            guard isLoaded else { return }
            
            // Encode content to JSON string for safe JavaScript transfer
            if let jsonData = try? JSONSerialization.data(withJSONObject: [content], options: []),
               let jsonString = String(data: jsonData, encoding: .utf8),
               let singleEncoded = jsonString.dropFirst().dropLast().description as String? {
                let js = "renderContent(\(singleEncoded));"
                webView?.evaluateJavaScript(js, completionHandler: nil)
            }
        }
        
        private func buildHTMLTemplate(fontSize: CGFloat) -> String {
            return """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
                <script src="https://cdn.jsdelivr.net/npm/marked@11.1.1/marked.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js"></script>
                <style>
                    * { margin: 0; padding: 0; box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
                    html, body {
                        font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                        font-size: \(fontSize)px;
                        line-height: 1.6;
                        color: #1F2937;
                        background-color: transparent;
                        word-wrap: break-word;
                        overflow-x: hidden;
                    }
                    #content { padding: 1px 1px; }
                    h1, h2, h3, h4 { color: #111827; margin-top: 14px; margin-bottom: 8px; font-weight: 700; }
                    h1 { font-size: 1.35em; border-bottom: 1px solid #E5E7EB; padding-bottom: 4px; }
                    h2 { font-size: 1.2em; }
                    h3 { font-size: 1.05em; }
                    p { margin-bottom: 8px; }
                    ul, ol { padding-left: 22px; margin-bottom: 8px; }
                    li { margin-bottom: 4px; }
                    .table-wrapper { width: 100%; overflow-x: auto; margin: 12px 0; -webkit-overflow-scrolling: touch; }
                    table { border-collapse: collapse; width: 100%; min-width: 260px; font-size: \(fontSize - 1)px; margin: 0; }
                    th, td { border-bottom: 1px solid #E5E7EB; border-right: 1px solid #E5E7EB; padding: 9px 12px; text-align: left; vertical-align: middle; }
                    th:last-child, td:last-child { border-right: none; }
                    th { font-weight: 700; color: #111827; background-color: #F9FAFB; border-top: 1px solid #E5E7EB; border-bottom: 2px solid #D1D5DB; }
                    tr:last-child td { border-bottom: 1px solid #E5E7EB; }
                    code { background-color: #F3F4F6; padding: 2px 6px; border-radius: 4px; font-size: 13px; font-family: ui-monospace, SFMono-Regular, monospace; }
                    pre { background-color: #1F2937; color: #F9FAFB; padding: 12px; border-radius: 8px; overflow-x: auto; margin: 10px 0; }
                    pre code { background-color: transparent; padding: 0; }
                    blockquote { border-left: 3px solid #10B981; padding-left: 12px; color: #4B5563; margin: 8px 0; font-style: italic; }
                    .katex { font-size: 1.06em; text-rendering: auto; }
                    .katex-display { margin: 8px 0; overflow-x: auto; overflow-y: hidden; padding: 4px 0; }
                </style>
            </head>
            <body>
                <div id="content"></div>
                <script>
                    function renderContent(text) {
                        try {
                            if (!text) {
                                document.getElementById('content').innerHTML = "";
                                notifyHeight();
                                return;
                            }
                            
                            // 1. Bảo vệ khối code nguồn
                            var codeBlocks = [];
                            var s = text.replace(/```[\\s\\S]*?```|`[^`]+`/g, function(match) {
                                codeBlocks.push(match);
                                return "%%CODEBLOCK" + (codeBlocks.length - 1) + "%%";
                            });
                            
                            // 2. Bảo vệ và chuẩn hóa các khối công thức toán học
                            var mathList = [];
                            function stashMath(str) {
                                mathList.push(str);
                                return "%%MATHBLOCK" + (mathList.length - 1) + "%%";
                            }
                            
                            // Chuẩn hóa lỗi typo dấu dollar không cân bằng: $$...$ hoặc $...$$
                            s = s.replace(/\\$\\$([^$\\n]+)\\$/g, function(_, p1) { return "$" + p1 + "$"; });
                            s = s.replace(/\\$([^$\\n]+)\\$\\$/g, function(_, p1) { return "$" + p1 + "$"; });
                            
                            // Display math: $$...$$ và \\[...\\]
                            s = s.replace(/\\$\\$[\\s\\S]*?\\$\\$/g, function(m) { return stashMath(m); });
                            s = s.replace(/\\\\\\[[\\s\\S]*?\\\\\\\\]/g, function(m) { return stashMath(m); });
                            
                            // Environments: \\begin{cases}...\\end{cases}, aligned, matrix, etc.
                            s = s.replace(/\\\\begin\\{(cases|aligned|matrix|pmatrix|bmatrix)\\}[\\s\\S]*?\\\\end\\{\\1\\}/g, function(m) {
                                return stashMath("$$" + m + "$$");
                            });
                            
                            // Inline math: \\(...\\) và $...$
                            s = s.replace(/\\\\\\([\\s\\S]*?\\\\\\)/g, function(m) { return stashMath(m); });
                            s = s.replace(/\\$[^$\\n]+\\$/g, function(m) { return stashMath(m); });
                            
                            // 3. Chuẩn hóa ký hiệu Unicode đặc trưng: ℕ^*, ℕ, ℤ, ℚ, ℝ
                            s = s.replace(/ℕ\\s*\\^\\s*\\*|ℕ\\*/g, function() { return stashMath("$\\mathbb{N}^*$"); });
                            s = s.replace(/ℕ/g, function() { return stashMath("$\\mathbb{N}$"); });
                            s = s.replace(/ℤ/g, function() { return stashMath("$\\mathbb{Z}$"); });
                            s = s.replace(/ℚ/g, function() { return stashMath("$\\mathbb{Q}$"); });
                            s = s.replace(/ℝ/g, function() { return stashMath("$\\mathbb{R}$"); });
                            
                            // 4. Ký hiệu tập hợp: e.g. {0, 1, 2, 3, \\dots}
                            s = s.replace(/\\{[^{}\\n]*?\\\\(?:dots|cdots)[^{}\\n]*?\\}/g, function(m) {
                                return stashMath("$\\\\{" + m.slice(1, -1) + "\\\\}$");
                            });
                            
                            // 5. Bare LaTeX commands: \\frac, \\sqrt, \\vec, \\sum, \\mathbb, lone commands
                            s = s.replace(/\\\\frac\\{[^{}]*\\}\\{[^{}]*\\}/g, function(m) { return stashMath("$" + m + "$"); });
                            s = s.replace(/\\\\sqrt(?:\\[[^\\]]*\\])?\\{[^{}]*\\}/g, function(m) { return stashMath("$" + m + "$"); });
                            s = s.replace(/\\\\(?:vec|overrightarrow)\\{[^{}]*\\}/g, function(m) { return stashMath("$" + m + "$"); });
                            s = s.replace(/\\\\(?:sum|prod|int|lim)(?:_\\{[^{}]*\\}|_[0-9a-zA-Z])?(?:\\^\\{[^{}]*\\}|\\^[0-9a-zA-Z*])?/g, function(m) { return stashMath("$" + m + "$"); });
                            s = s.replace(/\\\\(?:mathbb|mathcal|mathbf|mathrm)\\{[^{}]*\\}(?:\\^\\{[^{}]*\\}|\\^[\\*0-9a-zA-Z]|\\_[0-9a-zA-Z])?/g, function(m) { return stashMath("$" + m + "$"); });
                            
                            var loneCmds = /\\\\(?:dots|cdots|ldots|vdots|ddots|infty|empty|emptyset|cap|cup|setminus|subset|supset|subseteq|supseteq|in|notin|le|ge|ne|neq|approx|equiv|times|div|cdot|pm|mp|to|rightarrow|Rightarrow|leftarrow|Leftarrow|Leftrightarrow|alpha|beta|gamma|delta|epsilon|theta|lambda|mu|pi|sigma|tau|phi|omega|Delta|Gamma|Theta|Lambda|Sigma|Phi|Omega)/g;
                            s = s.replace(loneCmds, function(m) { return stashMath("$" + m + "$"); });
                            
                            // 6. Cho Marked xử lý Markdown
                            if (window.marked) {
                                marked.setOptions({ gfm: true, breaks: true });
                                var html = marked.parse(s);
                                html = html.replace(/<table/g, '<div class="table-wrapper"><table').replace(/<\\/table>/g, '</table></div>');
                                
                                // 7. Khôi phục lại khối toán học nguyên vẹn sau khi Marked xong
                                for (var i = 0; i < mathList.length; i++) {
                                    html = html.split("%%MATHBLOCK" + i + "%%").join(mathList[i]);
                                }
                                
                                // 8. Khôi phục khối code
                                for (var j = 0; j < codeBlocks.length; j++) {
                                    html = html.split("%%CODEBLOCK" + j + "%%").join(codeBlocks[j]);
                                }
                                
                                // 9. Gán vào DOM và chạy KaTeX render
                                var container = document.getElementById('content');
                                container.innerHTML = html;
                                
                                if (window.renderMathInElement) {
                                    renderMathInElement(container, {
                                        delimiters: [
                                            {left: "$$", right: "$$", display: true},
                                            {left: "\\\\[", right: "\\\\]", display: true},
                                            {left: "$", right: "$", display: false},
                                            {left: "\\\\(", right: "\\\\)", display: false}
                                        ],
                                        throwOnError: false
                                    });
                                }
                            } else {
                                document.getElementById('content').innerText = text;
                            }
                        } catch (e) {
                            document.getElementById('content').innerText = text;
                        }
                        notifyHeight();
                    }
                    
                    function notifyHeight() {
                        setTimeout(function() {
                            var h = Math.ceil(document.documentElement.scrollHeight || document.body.scrollHeight || 0);
                            if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.heightHandler) {
                                window.webkit.messageHandlers.heightHandler.postMessage(h);
                            }
                        }, 50);
                    }
                    
                    window.addEventListener('resize', notifyHeight);
                </script>
            </body>
            </html>
            """
        }
    }
}
