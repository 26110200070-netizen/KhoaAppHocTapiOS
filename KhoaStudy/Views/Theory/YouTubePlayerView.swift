import SwiftUI
import WebKit

/// Trình phát video YouTube chuẩn 16:9, nhúng iframe tối ưu cho iOS WKWebView
struct YouTubePlayerView: UIViewRepresentable {
    let videoId: String
    
    init(videoId: String) {
        self.videoId = videoId
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        // User Agent chuẩn iOS Safari Mobile để YouTube chấp nhận nhúng iframe
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1"
        
        loadEmbedHTML(into: webView, with: videoId)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Kiểm tra nếu videoId thay đổi thì tải lại
        let cleanId = videoId.trimmingCharacters(in: .whitespacesAndNewlines)
        if uiView.accessibilityIdentifier != cleanId {
            uiView.accessibilityIdentifier = cleanId
            loadEmbedHTML(into: uiView, with: cleanId)
        }
    }
    
    private func loadEmbedHTML(into webView: WKWebView, with id: String) {
        let cleanId = id.trimmingCharacters(in: .whitespacesAndNewlines)
        let embedUrl = "https://www.youtube.com/embed/\(cleanId)?playsinline=1&enablejsapi=1&rel=0&modestbranding=1"
        
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                html, body { width: 100%; height: 100%; background: #000; overflow: hidden; }
                .player-box { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
                iframe { width: 100%; height: 100%; border: 0; outline: none; }
            </style>
        </head>
        <body>
            <div class="player-box">
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
