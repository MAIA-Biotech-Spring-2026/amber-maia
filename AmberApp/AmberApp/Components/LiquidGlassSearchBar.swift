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
    @State private var isPressed: Bool = false

    var body: some View {
        HStack(spacing: 12) {
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

            Button(action: {
                isFocused = true
            }) {
                Image(systemName: "waveform")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isFocused ? .amberBlue : .secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(isFocused ? Color.amberBlue.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}
