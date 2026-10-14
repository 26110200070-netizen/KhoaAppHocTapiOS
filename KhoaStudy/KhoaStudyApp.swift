import SwiftUI

@main
struct KhoaStudyApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            MainRootView()
                .environmentObject(appState)
                .preferredColorScheme(.light) // Crisp Light UI matching the video reference
        }
    }
}
