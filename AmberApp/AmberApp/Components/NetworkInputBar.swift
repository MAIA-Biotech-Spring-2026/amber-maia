//
//  NetworkInputBar.swift
//  Amber
//
//  Created on 2026-01-18.
//

import SwiftUI

struct NetworkInputBar: View {
    @Binding var inputText: String
    @FocusState.Binding var isInputFocused: Bool
    @State private var showAttachmentMenu = false

    var body: some View {
        VStack(spacing: 0) {
            // Input container
            HStack(spacing: 12) {
                // Camera button
                Button {
                    // Camera action
                } label: {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isInputFocused ? .amberBlue : .secondary)
                }

                // Voice button
                Button {
                    if !inputText.isEmpty {
                        // Send message
                        sendMessage()
                    } else {
                        // Voice input
                    }
                } label: {
                    Image(systemName: inputText.isEmpty ? "waveform" : "arrow.up.circle.fill")
                        .font(.system(size: inputText.isEmpty ? 16 : 24, weight: .medium))
                        .foregroundColor(inputText.isEmpty ? (isInputFocused ? .amberBlue : .secondary) : .amberBlue)
                }

                // Text input field
                HStack(spacing: 8) {
                    Image(systemName: "bubble.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)

                    TextField("Add context to your network...", text: $inputText, axis: .vertical)
                        .font(.body)
                        .focused($isInputFocused)
                        .lineLimit(1...4)

                    if !inputText.isEmpty {
                        Button {
                            inputText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18))
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
                    .strokeBorder(isInputFocused ? Color.amberBlue.opacity(0.3) : Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            .padding(.horizontal, 20)
        }
        .confirmationDialog("Add to Network", isPresented: $showAttachmentMenu) {
            Button("Photo Library") { }
            Button("Take Photo") { }
            Button("Document") { }
            Button("Location") { }
            Button("Cancel", role: .cancel) { }
        }
    }

    private func sendMessage() {
        // Process message with @ mentions
        // Update network based on input
        // Trigger animations
        inputText = ""
    }
}
