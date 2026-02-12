//
//  DigestTypingIndicator.swift
//  AmberApp
//

import SwiftUI

struct DigestTypingIndicator: View {
    let themeColor: Color
    @State private var animatingDot = 0

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 16))
                .foregroundColor(themeColor)
                .frame(width: 28, height: 28)
                .background(.ultraThinMaterial, in: Circle())

            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 6, height: 6)
                        .scaleEffect(animatingDot == index ? 1.2 : 0.8)
                        .animation(.easeInOut(duration: 0.5).repeatForever(), value: animatingDot)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Spacer(minLength: 60)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                animatingDot = (animatingDot + 1) % 3
            }
        }
    }
}
