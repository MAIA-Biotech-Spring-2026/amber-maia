import Foundation

/// Manages Privy authentication state and token management
/// Uses Privy REST API directly (no SDK dependency)
@MainActor
public class AuthManager: ObservableObject {
    public static let shared = AuthManager()
    
    @Published public var isAuthenticated = false
    @Published public var accessToken: String?
    @Published public var userId: String?
    @Published public var configError: String?

    private let privyAppId: String
    private let backendURL: URL?

    private init() {
        // Configuration with environment-aware defaults
        guard let privyAppId = ProcessInfo.processInfo.environment["PRIVY_APP_ID"] else {
            self.privyAppId = ""
            self.backendURL = nil
            self.configError = "PRIVY_APP_ID not configured"
            print("⚠️ AuthManager: PRIVY_APP_ID environment variable is required")
            return
        }
        self.privyAppId = privyAppId

        let backendURLString = ProcessInfo.processInfo.environment["BACKEND_URL"] ?? "http://127.0.0.1:3001"
        if let url = URL(string: backendURLString) {
            self.backendURL = url
            self.configError = nil
        } else {
            self.backendURL = nil
            self.configError = "Invalid BACKEND_URL configuration: \(backendURLString)"
            print("⚠️ AuthManager: \(self.configError ?? "Unknown configuration error")")
        }

        checkStoredAuth()
    }
    
    /// Check for stored authentication
    private func checkStoredAuth() {
        do {
            let token = try KeychainManager.get(key: "privy_access_token")
            let userId = try KeychainManager.get(key: "privy_user_id")

            self.accessToken = token
            self.userId = userId
            self.isAuthenticated = true

            // Verify token is still valid
            Task {
                await verifyToken()
            }
        } catch {
            // No stored auth or keychain error - user needs to log in
            self.isAuthenticated = false
        }
    }
    
    /// Store authentication
    private func storeAuth(token: String, userId: String) {
        do {
            try KeychainManager.save(key: "privy_access_token", value: token)
            try KeychainManager.save(key: "privy_user_id", value: userId)
            self.accessToken = token
            self.userId = userId
            self.isAuthenticated = true
        } catch {
            print("⚠️ AuthManager: Failed to store credentials in keychain: \(error)")
        }
    }

    /// Clear stored authentication
    private func clearAuth() {
        do {
            try KeychainManager.delete(key: "privy_access_token")
            try KeychainManager.delete(key: "privy_user_id")
        } catch {
            print("⚠️ AuthManager: Failed to clear keychain: \(error)")
        }
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

        guard let backendURL = backendURL else {
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
            // Token verification failed - clear stored authentication
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
        guard let backendURL = backendURL else {
            throw AuthError.notConfigured
        }

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
