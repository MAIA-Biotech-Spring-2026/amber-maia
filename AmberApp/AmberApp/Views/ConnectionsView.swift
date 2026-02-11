//
//  ConnectionsView.swift
//  Amber
//
//  Created on 2026-01-17.
//

import SwiftUI

struct ConnectionsView: View {
    @StateObject private var viewModel = ConnectionsViewModel()
    @Binding var searchText: String
    @State private var showAddContact = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                ContactListView(viewModel: viewModel, searchText: $searchText)
                    .padding(.bottom, 140) // Space for tab bar
            }
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddContact = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.amberBlue)
                    }
                }
            }
        }
        .task {
            await viewModel.loadConnections()
        }
        .sheet(isPresented: $showAddContact) {
            AddContactView()
        }
    }
}

struct ContactRowView: View {
    let connection: Connection

    var body: some View {
        NavigationLink(destination: ContactDetailView(connection: connection)) {
            HStack(spacing: 12) {
                ContactAvatar(
                    name: connection.name,
                    imageURL: connection.avatarURL,
                    size: 40
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text(connection.name)
                        .font(.body)
                        .foregroundColor(.primary)

                    if let company = connection.company {
                        Text(company)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()
            }
        }
    }
}

struct ContactDetailView: View {
    let connection: Connection

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    ContactAvatar(
                        name: connection.name,
                        imageURL: connection.avatarURL,
                        size: 100
                    )

                    Text(connection.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    if let company = connection.company {
                        Text(company)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 32)

                // Contact Info
                VStack(spacing: 0) {
                    if let phone = connection.phone {
                        ContactInfoRow(icon: "phone.fill", label: "phone", value: phone)
                        Divider().padding(.leading, 56)
                    }

                    if let email = connection.email {
                        ContactInfoRow(icon: "envelope.fill", label: "email", value: email)
                        Divider().padding(.leading, 56)
                    }

                    ContactInfoRow(icon: "message.fill", label: "message", value: "Send Message")
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Contact")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContactInfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.amberBlue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
