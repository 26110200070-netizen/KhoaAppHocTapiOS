import SwiftUI
import WebKit

/// Trình phát video YouTube không cần khung viền bao bọc cồng kềnh, nhúng iframe chuẩn 16:9
struct YouTubePlayerView: UIViewRepresentable {
    let videoId: String
    
    init(videoId: String) {
        self.videoId = videoId
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        
        loadEmbedHTML(into: webView)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Only reload if needed
    }
    
    private func loadEmbedHTML(into webView: WKWebView) {
        let cleanId = videoId.trimmingCharacters(in: .whitespacesAndNewlines)
        let embedUrl = "https://www.youtube-nocookie.com/embed/\(cleanId)?playsinline=1&modestbranding=1&rel=0&showinfo=0"
        
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                html, body { width: 100%; height: 100%; background-color: #000000; overflow: hidden; }
                .video-container { position: relative; width: 100%; height: 100%; }
                iframe { width: 100%; height: 100%; border: none; outline: none; }
            </style>
        </head>
        <body>
            <div class="video-container">
                <iframe src="\(embedUrl)"
                        title="YouTube video player"
                        frameborder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                        allowfullscreen>
                </iframe>
            </div>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: URL(string: "https://www.youtube.com"))
    }
}
