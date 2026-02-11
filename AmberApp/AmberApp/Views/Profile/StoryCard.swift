//
//  StoryCard.swift
//  AmberApp
//

import SwiftUI

struct StoryCard: View {
    let digest: DailyDigest
    @State private var showDetail = false

    var body: some View {
        Button {
            showDetail = true
        } label: {
            ZStack(alignment: .bottomLeading) {
                // Gradient background
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [digest.color.opacity(0.8), digest.color],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 340)

                // Icon overlay
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: digest.icon)
                            .font(.system(size: 100, weight: .ultraLight))
                            .foregroundColor(.white.opacity(0.15))
                            .padding(24)
                    }
                }
                .frame(width: 200, height: 340)

                // Content
                VStack(alignment: .leading, spacing: 12) {
                    // Score badge
                    HStack(spacing: 4) {
                        Text("\(digest.score)")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Text("/100")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())

                    Spacer()
                        .frame(height: 140)

                    // Title and subtitle
                    VStack(alignment: .leading, spacing: 6) {
                        Text(digest.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(2)

                        Text(digest.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .lineLimit(2)
                    }
                }
                .padding(20)
                .frame(width: 200, height: 340, alignment: .topLeading)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: digest.color.opacity(0.3), radius: 20, x: 0, y: 10)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDetail) {
            DigestDetailView(digest: digest)
        }
    }
}
