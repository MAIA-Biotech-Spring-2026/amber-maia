//
//  DigestChatInputBar.swift
//  AmberApp
//

import SwiftUI

struct DigestChatInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let themeColor: Color
    let onSend: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            TextField("Ask follow-up...", text: $text, axis: .vertical)
                .font(.body)
                .lineLimit(1...5)
                .focused(isFocused)
                .submitLabel(.send)
                .onSubmit(onSend)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(text.isEmpty ? .secondary : themeColor)
            }
            .disabled(text.isEmpty)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
