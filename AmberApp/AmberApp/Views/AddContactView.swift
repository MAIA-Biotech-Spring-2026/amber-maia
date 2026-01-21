//
//  AddContactView.swift
//  Amber
//
//  Created on 2026-01-20.
//

import SwiftUI

struct AddContactView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var company = ""
    @State private var linkedinURL = ""
    @State private var notes = ""

    var body: some View {
        NavigationView {
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
                        // TODO: Integrate with Togari API
                        // POST /api/v1/amber/submit
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
