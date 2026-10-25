import SwiftUI
import WebKit

/// Trình phát video YouTube chuẩn 16:9, tối ưu theo kiến trúc thư viện chính thức `youtube-ios-player-helper` của Google
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
        // Đặt User Agent Mobile Safari chuẩn iOS để YouTube không chặn nhúng
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1"
        
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
        
        let originUrlString = "https://www.youtube.com"
        
        // Template HTML chuẩn chính thức từ Google youtube-ios-player-helper (YTPlayerView)
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                html, body { width: 100%; height: 100%; background-color: #000000; overflow: hidden; }
                .embed-container { position: relative; width: 100%; height: 100%; }
                .embed-container iframe,
                .embed-container object,
                .embed-container embed {
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100% !important;
                    height: 100% !important;
                    border: 0;
                }
            </style>
        </head>
        <body>
            <div class="embed-container">
                <div id="player"></div>
            </div>
            <script src="https://www.youtube.com/iframe_api"></script>
            <script>
                var player;
                function createPlayer() {
                    if (player) return;
                    player = new YT.Player('player', {
                        width: '100%',
                        height: '100%',
                        videoId: '\(cleanId)',
                        playerVars: {
                            'playsinline': 1,
                            'controls': 1,
                            'rel': 0,
                            'modestbranding': 1,
                            'fs': 1,
                            'autoplay': 0,
                            'origin': '\(originUrlString)'
                        }
                    });
                }
                function onYouTubeIframeAPIReady() {
                    createPlayer();
                }
                if (window.YT && window.YT.ready) {
                    YT.ready(function() {
                        createPlayer();
                    });
                }
            </script>
        </body>
        </html>
        """
        
        let originURL = URL(string: originUrlString)!
        webView.loadHTMLString(html, baseURL: originURL)
    }
}
