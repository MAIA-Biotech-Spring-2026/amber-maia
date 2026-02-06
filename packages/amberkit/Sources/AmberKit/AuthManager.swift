import Foundation

/// Manages Privy authentication state and token management
/// Uses Privy REST API directly (no SDK dependency)
@MainActor
public class AuthManager: ObservableObject {
    public static let shared = AuthManager()
    
    @Published public var isAuthenticated = false
    @Published public var accessToken: String?
    @Published public var userId: String?
    
    private let privyAppId = "cmisgt8wr00enjj0dkasj2xsz"
    private let backendURL = URL(string: "http://127.0.0.1:3001")!
    
    private init() {
        checkStoredAuth()
    }
    
    /// Check for stored authentication
    private func checkStoredAuth() {
        if let token = UserDefaults.standard.string(forKey: "privy_access_token"),
           let userId = UserDefaults.standard.string(forKey: "privy_user_id") {
            self.accessToken = token
            self.userId = userId
            self.isAuthenticated = true
            // Verify token is still valid
            Task {
                await verifyToken()
            }
        }
    }
    
    /// Store authentication
    private func storeAuth(token: String, userId: String) {
        UserDefaults.standard.set(token, forKey: "privy_access_token")
        UserDefaults.standard.set(userId, forKey: "privy_user_id")
        self.accessToken = token
        self.userId = userId
        self.isAuthenticated = true
    }
    
    /// Clear stored authentication
    private func clearAuth() {
        UserDefaults.standard.removeObject(forKey: "privy_access_token")
        UserDefaults.standard.removeObject(forKey: "privy_user_id")
        self.accessToken = nil
        self.userId = nil
        self.isAuthenticated = false
    }
    
    /// Verify token with backend
    private func verifyToken() async {
        guard let token = accessToken else {
            clearAuth()
            return
        }
        
        do {
            var request = URLRequest(url: backendURL.appendingPathComponent("auth/verify"))
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(["accessToken": token])
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                clearAuth()
                return
            }
            
            let result = try JSONDecoder().decode(AuthVerifyResponse.self, from: data)
            storeAuth(token: token, userId: result.privyUserId)
        } catch {
            print("Token verification failed: \(error)")
            clearAuth()
        }
    }
    
    /// Login with Privy (opens web view)
    /// For now, this is a placeholder - you'll need to implement web-based Privy login
    public func login() async throws {
        // TODO: Open Privy web login in Safari View Controller
        // For now, we'll use a mock flow that requires manual token entry
        throw AuthError.notImplemented
    }
    
    /// Login with access token (for testing/manual entry)
    public func loginWithToken(_ token: String) async throws {
        var request = URLRequest(url: backendURL.appendingPathComponent("auth/verify"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["accessToken": token])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AuthError.invalidToken
        }
        
        let result = try JSONDecoder().decode(AuthVerifyResponse.self, from: data)
        storeAuth(token: token, userId: result.privyUserId)
    }
    
    /// Logout
    public func logout() async {
        clearAuth()
    }
    
    /// Refresh access token
    public func refreshToken() async {
        await verifyToken()
    }
}

private struct AuthVerifyResponse: Codable {
    let userId: Int
    let privyUserId: String
    let linkedAccounts: [LinkedAccount]
}

private struct LinkedAccount: Codable {
    let type: String
    let address: String?
    let walletClientType: String?
}

public enum AuthError: Error {
    case notConfigured
    case notAuthenticated
    case tokenExpired
    case invalidToken
    case notImplemented
}
