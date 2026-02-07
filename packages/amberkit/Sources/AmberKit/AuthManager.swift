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
            // SECURITY: Don't print sensitive config errors to console
            // They are available via configError property for UI display
            return
        }
        self.privyAppId = privyAppId

        // SECURITY: No default URL - must be explicitly configured
        // Localhost URLs don't work on physical iOS devices
        guard let backendURLString = ProcessInfo.processInfo.environment["BACKEND_URL"] else {
            self.backendURL = nil
            self.configError = "BACKEND_URL not configured"
            return
        }

        if let url = URL(string: backendURLString) {
            self.backendURL = url
            self.configError = nil
        } else {
            self.backendURL = nil
            self.configError = "Invalid BACKEND_URL configuration: \(backendURLString)"
            // SECURITY: Don't print config errors - available via configError property
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
            // SECURITY: Don't print keychain errors to console (may contain sensitive info)
            // Keychain failures will manifest as authentication failures in the UI
            // Error is silently ignored - user will need to re-authenticate
        }
    }

    /// Clear stored authentication
    private func clearAuth() {
        do {
            try KeychainManager.delete(key: "privy_access_token")
            try KeychainManager.delete(key: "privy_user_id")
        } catch {
            // SECURITY: Don't print keychain errors to console
            // Silently ignore delete errors - credentials will be overwritten on next auth
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
            // SECURITY: Send token in Authorization header, not request body
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
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
        // SECURITY: Send token in Authorization header, not request body
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
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
