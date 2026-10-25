import SwiftUI
import WebKit

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
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let cleanId = videoId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanId.isEmpty else { return }
        
        if uiView.accessibilityIdentifier != cleanId {
            uiView.accessibilityIdentifier = cleanId
            loadVideo(into: uiView, videoId: cleanId)
        }
    }
    
    private func loadVideo(into webView: WKWebView, videoId: String) {
        // 1. Tạo định danh Origin hợp lệ dựa trên Bundle ID của App (bắt buộc viết thường)
        let bundleId = (Bundle.main.bundleIdentifier ?? "com.khoastudy.app").lowercased()
        let origin = "https://\(bundleId)"
        guard let baseURL = URL(string: origin) else { return }
        
        // 2. Đường dẫn nhúng kèm theo origin trùng khớp với baseURL
        let embedURL = "https://www.youtube.com/embed/\(videoId)?playsinline=1&controls=1&rel=0&modestbranding=1&enablejsapi=1&origin=\(origin)&widget_referrer=\(origin)"
        
        // 3. Khởi tạo trang HTML bao bọc IFrame chuẩn kiến trúc youtube-ios-player-helper
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                html, body { width: 100%; height: 100%; background-color: #000; overflow: hidden; }
                iframe { width: 100%; height: 100%; border: none; }
            </style>
        </head>
        <body>
            <iframe
                src="\(embedURL)"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                referrerpolicy="strict-origin-when-cross-origin"
                allowfullscreen>
            </iframe>
        </body>
        </html>
        """
        
        // 4. Nạp HTML với baseURL để WebKit tự động duy trì Referer và Origin cho mọi request
        webView.loadHTMLString(html, baseURL: baseURL)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            
            // Nếu học sinh bấm vào logo YouTube hoặc tiêu đề để mở link ngoài -> mở trong YouTube app hoặc Safari
            if navigationAction.navigationType == .linkActivated {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
            
            // Cho phép tất cả các luồng tải iframe và tài nguyên ngầm của trình phát
            decisionHandler(.allow)
        }
    }
}
