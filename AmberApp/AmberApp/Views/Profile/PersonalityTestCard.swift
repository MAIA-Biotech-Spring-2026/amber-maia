//
//  PersonalityTestCard.swift
//  AmberApp
//

import SwiftUI

struct PersonalityTestCard: View {
    let title: String
    let icon: String
    let color: Color
    let isCompleted: Bool
    @State private var showTest = false

    var body: some View {
        Button {
            showTest = true
        } label: {
            VStack(spacing: 12) {
                // Icon with background
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 60, height: 60)

                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(color)
                }

                // Title
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                // Status indicator
                HStack(spacing: 4) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle.dashed")
                        .font(.system(size: 12))
                        .foregroundColor(isCompleted ? .green : .secondary)

                    Text(isCompleted ? "Complete" : "Not taken")
                        .font(.caption2)
                        .foregroundColor(isCompleted ? .green : .secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isCompleted ? color.opacity(0.3) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showTest) {
            PersonalityTestView(testTitle: title, testColor: color)
        }
    }
}
