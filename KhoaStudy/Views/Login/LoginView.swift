import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var usernameInput: String = "Anh Khoa Dev"
    @State private var apiKeyInput: String = ""
    @State private var serverUrlInput: String = "http://localhost:8000/v1"
    @State private var useLocalDeepSeek: Bool = true
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    Spacer(minLength: 40)
                    
                    // App Logo & Mascot
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 96, height: 96)
                                .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.white)
                        }
                        
                        Text("KhoaStudy")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.primaryDark)
                        
                        Text(appState.t("Học tập thông minh & Tích hợp DeepSeek AI"))
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    // Login Form Card
                    VStack(alignment: .leading, spacing: 18) {
                        Text(appState.t("Đăng nhập tài khoản"))
                            .font(.headline)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        // Username Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Tên đăng nhập")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary)
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(AppTheme.primaryMint)
                                TextField("Nhập tên đăng nhập...", text: $usernameInput)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppTheme.secondaryBg)
                            )
                        }
                        
                        // DeepSeek API Configuration
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("DeepSeek API Token")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                                Spacer()
                                Text("Deepseek-API")
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Capsule().fill(AppTheme.primaryLight))
                                    .foregroundColor(AppTheme.primary)
                            }
                            HStack {
                                Image(systemName: "key.fill")
                                    .foregroundColor(AppTheme.accentOrange)
                                SecureField("Nhập API Key hoặc để trống dùng Local...", text: $apiKeyInput)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppTheme.secondaryBg)
                            )
                        }
                        
                        // Server URL
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Endpoint Server (Deepseek-API local)")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary)
                            HStack {
                                Image(systemName: "network")
                                    .foregroundColor(AppTheme.accentBlue)
                                TextField("http://localhost:8000/v1", text: $serverUrlInput)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppTheme.secondaryBg)
                            )
                        }
                        
                        // Login Action Button
                        Button(action: {
                            appState.deepSeekServerUrl = serverUrlInput
                            appState.login(username: usernameInput, apiKey: apiKeyInput)
                        }) {
                            HStack {
                                Spacer()
                                Text("Đăng Nhập Với DeepSeek")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primary], startPoint: .leading, endPoint: .trailing))
                            )
                            .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.top, 6)
                    }
                    .cleanCard(cornerRadius: 24, padding: 22)
                    
                    // Language Switch Pill
                    HStack(spacing: 8) {
                        ForEach(AppLanguage.allCases, id: \.self) { lang in
                            Button(action: {
                                withAnimation {
                                    appState.currentLanguage = lang
                                }
                            }) {
                                HStack(spacing: 6) {
                                    Text(lang.flag)
                                    Text(lang.rawValue)
                                        .font(.caption)
                                        .fontWeight(appState.currentLanguage == lang ? .bold : .regular)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(appState.currentLanguage == lang ? AppTheme.primaryDark : Color.white)
                                )
                                .foregroundColor(appState.currentLanguage == lang ? .white : AppTheme.textPrimary)
                                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
}
