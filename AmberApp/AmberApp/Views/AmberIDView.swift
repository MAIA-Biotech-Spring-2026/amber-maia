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
                    // Identity Card with Live Tracking
                    VStack(spacing: 16) {
                        // Avatar with ring
                        ZStack {
                            Circle()
                                .stroke(Color.amberBlue, lineWidth: 3)
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

                        Text("@sagartiwari")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        // Live Tracking Insights
                        VStack(spacing: 12) {
                            Text("Today's Activity")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            // Activity Rings as Lines
                            HStack(spacing: 16) {
                                ActivityLineIndicator(
                                    label: "Move",
                                    value: viewModel.moveProgress,
                                    color: .red
                                )
                                ActivityLineIndicator(
                                    label: "Exercise",
                                    value: viewModel.exerciseProgress,
                                    color: .green
                                )
                                ActivityLineIndicator(
                                    label: "Stand",
                                    value: viewModel.standProgress,
                                    color: .blue
                                )
                            }

                            Divider()
                                .padding(.vertical, 4)

                            // Sleep Line
                            HStack(spacing: 12) {
                                Image(systemName: "moon.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.indigo)
                                    .frame(width: 24)

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Sleep")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text("\(viewModel.sleepHours, specifier: "%.1f")h")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            // Background
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.secondary.opacity(0.2))
                                                .frame(height: 4)

                                            // Progress
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.indigo.gradient)
                                                .frame(width: geometry.size.width * CGFloat(min(viewModel.sleepHours / 8.0, 1.0)), height: 4)
                                        }
                                    }
                                    .frame(height: 4)
                                }
                            }

                            // Screen Time Line
                            HStack(spacing: 12) {
                                Image(systemName: "iphone")
                                    .font(.system(size: 16))
                                    .foregroundColor(.orange)
                                    .frame(width: 24)

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Screen Time")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text("\(viewModel.screenTimeHours, specifier: "%.1f")h")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            // Background
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.secondary.opacity(0.2))
                                                .frame(height: 4)

                                            // Progress (inverted color - less is better)
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(viewModel.screenTimeHours > 4 ? Color.orange.gradient : Color.green.gradient)
                                                .frame(width: geometry.size.width * CGFloat(min(viewModel.screenTimeHours / 8.0, 1.0)), height: 4)
                                        }
                                    }
                                    .frame(height: 4)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)

                    // Personality Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Personality Summary")
                            .font(.headline)
                            .padding(.horizontal)

                        VStack(spacing: 0) {
                            PersonalityRow(label: "Primary Nature", value: viewModel.user.primaryNature?.rawValue ?? "Unknown")
                            Divider().padding(.leading, 16)
                            PersonalityRow(label: "Social type", value: viewModel.user.socialType?.rawValue ?? "Unknown")
                            Divider().padding(.leading, 16)
                            PersonalityRow(label: "Influenced by", value: viewModel.user.influencedBy?.rawValue ?? "Unknown")
                            Divider().padding(.leading, 16)
                            PersonalityRow(label: "Thinking style", value: viewModel.user.thinkingStyle?.rawValue ?? "Unknown")
                            Divider().padding(.leading, 16)
                            PersonalityRow(label: "Interaction style", value: viewModel.user.interactionStyle?.rawValue ?? "Unknown")
                            Divider().padding(.leading, 16)
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

                    // Data Sources Section (moved to bottom)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Connected Data Sources")
                            .font(.headline)
                            .padding(.horizontal)

                        VStack(spacing: 12) {
                            DataSourceRow(
                                icon: "calendar",
                                title: "Calendar",
                                subtitle: "Google Calendar, Apple Calendar",
                                isConnected: $viewModel.calendarConnected,
                                color: .red
                            )

                            DataSourceRow(
                                icon: "envelope.fill",
                                title: "Email",
                                subtitle: "Gmail, Outlook",
                                isConnected: $viewModel.emailConnected,
                                color: .blue
                            )

                            DataSourceRow(
                                icon: "person.2.fill",
                                title: "Contacts",
                                subtitle: "Apple Contacts",
                                isConnected: $viewModel.contactsConnected,
                                color: .green
                            )

                            DataSourceRow(
                                icon: "heart.fill",
                                title: "Health",
                                subtitle: "Apple HealthKit",
                                isConnected: $viewModel.healthKitConnected,
                                color: .pink
                            )

                            DataSourceRow(
                                icon: "logo.linkedin",
                                title: "LinkedIn",
                                subtitle: "Professional network",
                                isConnected: $viewModel.linkedInConnected,
                                color: .blue
                            )

                            DataSourceRow(
                                icon: "flame.fill",
                                title: "Fitness",
                                subtitle: "Fitbit, Strava",
                                isConnected: $viewModel.fitnessConnected,
                                color: .orange
                            )

                            DataSourceRow(
                                icon: "note.text",
                                title: "Notes",
                                subtitle: "Notion, Evernote",
                                isConnected: $viewModel.notesConnected,
                                color: .indigo
                            )

                            DataSourceRow(
                                icon: "message.fill",
                                title: "Messaging",
                                subtitle: "Slack, Discord",
                                isConnected: $viewModel.messagingConnected,
                                color: .purple
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .padding(.bottom, 140) // Space for tab bar
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Settings action
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
}

// MARK: - Activity Line Indicator
struct ActivityLineIndicator: View {
    let label: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)

            ZStack {
                // Background circle
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 3)
                    .frame(width: 32, height: 32)

                // Progress circle
                Circle()
                    .trim(from: 0, to: value)
                    .stroke(color.gradient, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(-90))

                // Percentage text
                Text("\(Int(value * 100))")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(color)
            }

            // Line visualization
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color.opacity(0.2))
                        .frame(height: 4)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(color.gradient)
                        .frame(width: geometry.size.width * CGFloat(value), height: 4)
                }
            }
            .frame(height: 4)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Supporting Views
struct DataSourceRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isConnected: Bool
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(color.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            // Title and subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Toggle
            Toggle("", isOn: $isConnected)
                .labelsHidden()
                .tint(.amberBlue)
        }
        .padding(12)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
                .font(.subheadline)
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
