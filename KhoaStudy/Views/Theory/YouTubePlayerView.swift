import SwiftUI
import WebKit

/// Trình phát video YouTube chuẩn 16:9, tối ưu theo kiến trúc thư viện chính thức `youtube-ios-player-helper` của Google
struct YouTubePlayerView: UIViewRepresentable {
    let videoId: String
    
    init(videoId: String) {
        self.videoId = videoId
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsAirPlayForMediaPlayback = true
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.navigationDelegate = context.coordinator
        
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
        
        // Tải trực tiếp trang Embed chính thức của YouTube để bảo đảm 100% Header Referer và Origin hợp lệ,
        // chấm dứt hoàn toàn lỗi Error 150/152-4 (Missing HTTP Referer/Embedder Verification).
        let urlString = "https://www.youtube.com/embed/\(cleanId)?playsinline=1&controls=1&rel=0&modestbranding=1&enablejsapi=1&origin=https://www.youtube.com"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("https://www.youtube.com", forHTTPHeaderField: "Referer")
        request.setValue("https://www.youtube.com", forHTTPHeaderField: "Origin")
        webView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            
            let urlString = url.absoluteString.lowercased()
            // Cho phép các request nội bộ của YouTube player (embed, video chunks, telemetry)
            if urlString.contains("youtube.com/embed") ||
               urlString.contains("googlevideo.com") ||
               urlString.contains("youtube.com/generate_204") ||
               urlString.contains("youtube.com/api") ||
               urlString.contains("ytimg.com") {
                decisionHandler(.allow)
                return
            }
            
            // Nếu học sinh bấm vào logo YouTube hoặc link ngoài -> mở trong YouTube app hoặc Safari
            if navigationAction.navigationType == .linkActivated {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
            
            decisionHandler(.allow)
        }
    }
}

