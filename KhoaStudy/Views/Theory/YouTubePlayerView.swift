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
        configuration.allowsPictureInPictureMediaPlayback = true
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.navigationDelegate = context.coordinator
        
        // Cung cấp User-Agent Mobile Safari tiêu chuẩn để YouTube cấp phép phát mượt mà
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1"
        
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
        let cleanId = videoId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanId.isEmpty else { return }
        
        // Nhúng chuẩn qua domain privacy youtube-nocookie.com, loại bỏ các tham số origin/widget_referrer giả lập gây lỗi
        let embedURL = "https://www.youtube-nocookie.com/embed/\(cleanId)?playsinline=1&controls=1&rel=0&modestbranding=1&enablejsapi=1"
        
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
                allowfullscreen>
            </iframe>
        </body>
        </html>
        """
        
        guard let baseURL = URL(string: "https://www.youtube-nocookie.com") else { return }
        webView.loadHTMLString(html, baseURL: baseURL)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            
            // Nếu người dùng bấm vào các liên kết ngoài hoặc tab mới
            if navigationAction.navigationType == .linkActivated || navigationAction.targetFrame == nil {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
            
            // Cho phép tất cả các tài nguyên và iframe bên trong tải bình thường
            decisionHandler(.allow)
        }
    }
}
