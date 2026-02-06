//
//  AmberIDView.swift
//  Amber
//
//  Created on 2026-01-17.
//

import SwiftUI

struct AmberIDView: View {
    @StateObject private var viewModel = AmberIDViewModel()
    @State private var journalText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Identity Card
                    VStack(spacing: 16) {
                        // Avatar with ring
                        ZStack {
                            Circle()
                                .stroke(Color.accentColor, lineWidth: 3)
                                .frame(width: 106, height: 106)

                            ContactAvatar(
                                name: viewModel.user.name,
                                imageURL: viewModel.user.avatarURL,
                                size: 100
                            )
                        }

                        Text(viewModel.user.name)
                            .font(.title2)
                            .fontWeight(.bold)

                        Button {
                            // Open web profile
                        } label: {
                            Label("View web profile", systemImage: "arrow.up.forward.square")
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.thinMaterial)
                                .clipShape(Capsule())
                        }

                        Text("dimensional.me/sagartiwari")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)

                    // Personality Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Summary")
                            .font(.headline)
                            .padding(.horizontal)

                        VStack(spacing: 0) {
                            PersonalityRow(label: "Primary Nature", value: viewModel.user.primaryNature?.rawValue ?? "Unknown")
                            PersonalityRow(label: "Social type", value: viewModel.user.socialType?.rawValue ?? "Unknown")
                            PersonalityRow(label: "Influenced by", value: viewModel.user.influencedBy?.rawValue ?? "Unknown")
                            PersonalityRow(label: "Thinking style", value: viewModel.user.thinkingStyle?.rawValue ?? "Unknown")
                            PersonalityRow(label: "Interaction style", value: viewModel.user.interactionStyle?.rawValue ?? "Unknown")
                            PersonalityRow(label: "Communication", value: viewModel.user.communicationStyle?.rawValue ?? "Unknown")
                        }
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                    }

                    // Stories
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Stories")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.stories) { story in
                                    StoryCardView(story: story)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("@sagartiwari")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Settings action
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Edit profile
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
            }
        }
    }
}

struct PersonalityRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct StoryCardView: View {
    let story: AmberStory

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(story.emoji)
                .font(.largeTitle)
            Text(story.title)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(story.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: 160, height: 120)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
