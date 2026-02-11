//
//  DailyDigestCard.swift
//  AmberApp
//

import SwiftUI

struct DailyDigestCard: View {
    let digest: DailyDigest

    var body: some View {
        NavigationLink(destination: DigestDetailView(digest: digest)) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with icon and title
                HStack(spacing: 10) {
                    Image(systemName: digest.icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(digest.color)
                        .frame(width: 32, height: 32)
                        .background(digest.color.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(digest.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)

                        Text(digest.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    // Score badge
                    HStack(spacing: 4) {
                        Text("\(digest.score)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(digest.color)
                        Text("/100")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                // Main insight text
                Text(digest.insight)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                // Footer with trend and sources
                HStack {
                    // Trend indicator
                    HStack(spacing: 4) {
                        Image(systemName: digest.trend > 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption2)
                        Text("\(abs(digest.trend))%")
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(digest.trend > 0 ? .green : .red)

                    Spacer()

                    // Sources indicator
                    HStack(spacing: 4) {
                        Image(systemName: "doc.text.fill")
                            .font(.caption2)
                        Text("3 sources")
                            .font(.caption2)
                    }
                    .foregroundColor(.secondary)
                }
            }
            .padding(16)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(digest.color.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
