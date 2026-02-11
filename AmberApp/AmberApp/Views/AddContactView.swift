//
//  AddContactView.swift
//  Amber
//
//  Created on 2026-01-20.
//

import SwiftUI
import PhotosUI

struct AddContactView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var company = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var linkedinURL = ""
    @State private var notes = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: Image?

    var body: some View {
        NavigationStack {
            List {
                // Photo section
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                ZStack {
                                    if let profileImage {
                                        profileImage
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .fill(Color(.systemGray5))
                                            .frame(width: 100, height: 100)
                                            .overlay {
                                                Image(systemName: "camera.fill")
                                                    .font(.system(size: 32))
                                                    .foregroundColor(.secondary)
                                            }
                                    }
                                }
                            }

                            Text("add photo")
                                .font(.subheadline)
                                .foregroundColor(.amberBlue)
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 8)
                }

                // Name section
                Section {
                    HStack {
                        Text("First")
                            .foregroundColor(.primary)
                            .frame(width: 80, alignment: .leading)
                        TextField("", text: $firstName)
                    }

                    HStack {
                        Text("Last")
                            .foregroundColor(.primary)
                            .frame(width: 80, alignment: .leading)
                        TextField("", text: $lastName)
                    }

                    HStack {
                        Text("Company")
                            .foregroundColor(.primary)
                            .frame(width: 80, alignment: .leading)
                        TextField("", text: $company)
                    }
                }

                // Phone section
                Section {
                    HStack {
                        Text("mobile")
                            .foregroundColor(.secondary)
                            .frame(width: 80, alignment: .leading)
                        TextField("", text: $phoneNumber)
                            .keyboardType(.phonePad)
                    }

                    Button {
                        // Add phone number
                    } label: {
                        Text("add phone")
                            .foregroundColor(.amberBlue)
                    }
                }

                // Email section
                Section {
                    HStack {
                        Text("email")
                            .foregroundColor(.secondary)
                            .frame(width: 80, alignment: .leading)
                        TextField("", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }

                    Button {
                        // Add email
                    } label: {
                        Text("add email")
                            .foregroundColor(.amberBlue)
                    }
                }

                // Social section
                Section {
                    HStack {
                        Text("LinkedIn")
                            .foregroundColor(.primary)
                            .frame(width: 80, alignment: .leading)
                        TextField("URL", text: $linkedinURL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                    }

                    Button {
                        // Add social profile
                    } label: {
                        Text("add social profile")
                            .foregroundColor(.amberBlue)
                    }
                }

                // Notes section
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notes")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextEditor(text: $notes)
                            .frame(height: 80)
                    }
                }
            }
            .navigationTitle("New Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        // TODO: Save contact
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(firstName.isEmpty && lastName.isEmpty)
                }
            }
        }
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}
