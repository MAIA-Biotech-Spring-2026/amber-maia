//
//  ContactListView.swift
//  Amber
//
//  Created on 2026-01-18.
//

import SwiftUI

struct ContactListView: View {
    @ObservedObject var viewModel: ConnectionsViewModel
    @Binding var searchText: String

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(viewModel.filteredConnections(searchText: searchText).keys.sorted(), id: \.self) { letter in
                    Section {
                        ForEach(viewModel.filteredConnections(searchText: searchText)[letter] ?? []) { connection in
                            ContactRowView(connection: connection)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                        }
                    } header: {
                        Text(letter)
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color(UIColor.systemGroupedBackground))
                    }
                }
            }
        }
    }
}
