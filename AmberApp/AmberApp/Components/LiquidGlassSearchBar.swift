//
//  LiquidGlassSearchBar.swift
//  Amber
//
//  Created on 2026-01-17.
//

import SwiftUI

struct LiquidGlassSearchBar: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    @State private var showAttachmentMenu = false

    var body: some View {
        HStack(spacing: 12) {
            // Camera button
            Button {
                // Camera action
            } label: {
                Image(systemName: "camera.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isFocused ? .amberBlue : .secondary)
            }

            // Voice button
            Button {
                // Voice input
            } label: {
                Image(systemName: "waveform")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isFocused ? .amberBlue : .secondary)
            }

            // Search icon and text field
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)

                TextField("Search", text: $searchText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .focused($isFocused)

                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            // Plus button
            Button {
                showAttachmentMenu = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.amberBlue)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(isFocused ? Color.amberBlue.opacity(0.3) : Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .confirmationDialog("Add Attachment", isPresented: $showAttachmentMenu) {
            Button("Photo Library") { }
            Button("Take Photo") { }
            Button("Document") { }
            Button("Cancel", role: .cancel) { }
        }
    }
}
