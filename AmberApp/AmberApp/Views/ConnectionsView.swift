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
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar with title and add button
                HStack {
                    Text("Connections")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Spacer()

                    Button {
                        showAddContact = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.amberBlue)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.amberBlue.opacity(0.15))
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)

                // Contact list
                ContactListView(viewModel: viewModel, searchText: $searchText)
                    .padding(.bottom, 140) // Space for tab bar + search

                Spacer()
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
        HStack(spacing: 12) {
            ContactAvatar(
                name: connection.name,
                imageURL: connection.avatarURL,
                size: 40
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(connection.name)
                    .font(.body)

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
