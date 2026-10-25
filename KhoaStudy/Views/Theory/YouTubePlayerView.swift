import SwiftUI
import WebKit

/// Trình phát video YouTube chuẩn 16:9, nhúng tối ưu cho iOS WKWebView
struct YouTubePlayerView: UIViewRepresentable {
    let videoId: String
    
    init(videoId: String) {
        self.videoId = videoId
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsAirPlayForMediaPlayback = true
        if #available(iOS 14.5, *) {
            configuration.preferences.isTextInteractionEnabled = false
        }
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        
        loadVideo(into: webView, videoId: videoId)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let cleanId = videoId.trimmingCharacters(in: .whitespacesAndNewlines)
        if uiView.accessibilityIdentifier != cleanId {
            uiView.accessibilityIdentifier = cleanId
            loadVideo(into: uiView, videoId: cleanId)
        }
    }
    
    private func loadVideo(into webView: WKWebView, videoId: String) {
        let cleanId = videoId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanId.isEmpty else { return }
        
        // Nhúng HTML chuẩn với meta referrer và origin để tránh lỗi YouTube Error 152-4
        let embedUrl = "https://www.youtube.com/embed/\(cleanId)?playsinline=1&enablejsapi=1&rel=0&modestbranding=1&origin=https://www.youtube.com"
        
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <meta name="referrer" content="strict-origin-when-cross-origin">
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
                        title="YouTube Video Player"
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

