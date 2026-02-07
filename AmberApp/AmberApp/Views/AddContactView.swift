//
//  AddContactView.swift
//  Amber
//
//  Created on 2026-01-20.
//

import SwiftUI
import AmberKit

struct AddContactView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var authManager = AuthManager.shared
    @State private var name = ""
    @State private var company = ""
    @State private var linkedinURL = ""
    @State private var notes = ""
    @State private var isSubmitting = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Contact Information") {
                    TextField("Name", text: $name)
                    TextField("Company", text: $company)
                    TextField("LinkedIn URL", text: $linkedinURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await submitContact()
                        }
                    }
                    .disabled(name.isEmpty || linkedinURL.isEmpty || isSubmitting)
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    private func submitContact() async {
        isSubmitting = true
        defer { isSubmitting = false }

        // Validate LinkedIn URL format
        if !isValidLinkedInURL(linkedinURL) {
            errorMessage = "Please enter a valid LinkedIn profile URL (e.g., linkedin.com/in/username)"
            showError = true
            return
        }

        let backendURL = ProcessInfo.processInfo.environment["BACKEND_URL"] ?? "https://127.0.0.1:3001"
        guard let url = URL(string: "\(backendURL)/api/v1/amber/submit") else {
            errorMessage = "Invalid backend URL"
            showError = true
            return
        }

        guard let apiKey = ProcessInfo.processInfo.environment["AMBER_API_KEY"], !apiKey.isEmpty else {
            errorMessage = "API key not configured"
            showError = true
            return
        }

        // Get user identity from auth manager
        let submittedBy = authManager.userId ?? "anonymous"
        // TODO: Get organizationId from user profile when implemented
        let organizationId = ProcessInfo.processInfo.environment["ORGANIZATION_ID"] ?? "default_org"

        let submission: [String: Any] = [
            "linkedinUrl": linkedinURL,
            "submittedName": name,
            "submittedCompany": company.isEmpty ? nil : company,
            "notes": notes.isEmpty ? nil : notes,
            "submittedBy": submittedBy,
            "sourceChannel": "ios_app",
            "organizationId": organizationId
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: submission.compactMapValues { $0 })

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
            request.httpBody = jsonData

            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                errorMessage = "Failed to submit contact"
                showError = true
                return
            }
            dismiss()
        } catch let error as NSError {
            if error.domain == NSURLErrorDomain {
                errorMessage = "Network error: \(error.localizedDescription)"
            } else {
                errorMessage = "Failed to encode submission: \(error.localizedDescription)"
            }
            showError = true
        }
    }

    private func isValidLinkedInURL(_ urlString: String) -> Bool {
        // Check if URL is valid
        guard let url = URL(string: urlString.lowercased()) else {
            return false
        }

        // Check if it's a linkedin.com domain
        guard let host = url.host else {
            return false
        }

        // Accept linkedin.com or any subdomain
        if !host.hasSuffix("linkedin.com") {
            return false
        }

        // Check if it contains /in/ or /company/ path
        let path = url.path
        return path.contains("/in/") || path.contains("/company/")
    }
}
