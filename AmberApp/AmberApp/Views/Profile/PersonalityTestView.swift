//
//  PersonalityTestView.swift
//  AmberApp
//

import SwiftUI

struct PersonalityTestView: View {
    let testTitle: String
    let testColor: Color
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(testColor.opacity(0.15))
                                .frame(width: 80, height: 80)

                            Image(systemName: iconForTest(testTitle))
                                .font(.system(size: 36, weight: .semibold))
                                .foregroundColor(testColor)
                        }

                        Text(testTitle)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Discover more about your personality")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)

                    // Test content placeholder
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About This Test")
                            .font(.headline)

                        Text("This personality assessment will help you understand your unique traits and characteristics. Take your time and answer honestly for the most accurate results.")
                            .font(.body)
                            .foregroundColor(.secondary)

                        Button {
                            // Start test
                        } label: {
                            Text("Start Test")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(testColor.gradient)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .padding(.top, 8)
                    }
                    .padding(20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.amberBlue)
                }
            }
        }
    }

    private func iconForTest(_ title: String) -> String {
        switch title {
        case "Daily Test": return "calendar.badge.clock"
        case "Big Five": return "chart.bar.fill"
        case "Myers-Briggs": return "person.fill"
        case "Enneagram": return "circle.grid.3x3.fill"
        case "Love Language": return "heart.fill"
        case "Attachment Style": return "link.circle.fill"
        case "Zodiac Signs": return "sparkles"
        default: return "questionmark.circle.fill"
        }
    }
}
