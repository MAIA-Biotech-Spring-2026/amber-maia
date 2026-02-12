//
//  DigestChatBubble.swift
//  AmberApp
//

import SwiftUI

struct DigestChatBubble: View {
    let message: DigestChatMessage
    let themeColor: Color

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromUser { Spacer(minLength: 60) }

            if !message.isFromUser {
                Image(systemName: "sparkles")
                    .font(.system(size: 16))
                    .foregroundColor(themeColor)
                    .frame(width: 28, height: 28)
                    .background(.ultraThinMaterial, in: Circle())
            }

            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .foregroundColor(message.isFromUser ? .white : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        message.isFromUser
                            ? AnyShapeStyle(themeColor.gradient)
                            : AnyShapeStyle(.regularMaterial)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }

            if !message.isFromUser { Spacer(minLength: 60) }
        }
    }
}
