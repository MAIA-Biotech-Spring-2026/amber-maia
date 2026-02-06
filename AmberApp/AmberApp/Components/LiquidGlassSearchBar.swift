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
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
                .scaleEffect(isFocused ? 1.1 : 1.0)

            TextField("Search", text: $searchText)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .focused($isFocused)

            if !searchText.isEmpty {
                Button(action: {
                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                        searchText = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .transition(.scale.combined(with: .opacity))
            }

            Button(action: {
                withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                    isFocused = true
                }
            }) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.amberBlue)
                    .scaleEffect(isPressed ? 0.85 : 1.0)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation(.easeOut(duration: 0.1)) {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                            isPressed = false
                        }
                    }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            .ultraThinMaterial,
            in: Capsule()
        )
        .overlay(
            Capsule()
                .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(isFocused ? 0.15 : 0.08), radius: isFocused ? 16 : 8, x: 0, y: 4)
        .scaleEffect(isFocused ? 1.02 : 1.0)
        .animation(.interpolatingSpring(stiffness: 300, damping: 20), value: searchText.isEmpty)
        .animation(.interpolatingSpring(stiffness: 300, damping: 20), value: isFocused)
        .animation(.interpolatingSpring(stiffness: 300, damping: 20), value: isPressed)
    }
}
