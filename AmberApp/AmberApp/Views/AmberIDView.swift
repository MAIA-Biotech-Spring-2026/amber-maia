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
    @State private var selectedDigestIndex = 0

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

                            // Move Line
                            HStack(spacing: 12) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.red)
                                    .frame(width: 24)

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Move")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text("\(Int(viewModel.moveProgress * 100))%")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.secondary.opacity(0.2))
                                                .frame(height: 4)

                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.red.gradient)
                                                .frame(width: geometry.size.width * CGFloat(viewModel.moveProgress), height: 4)
                                        }
                                    }
                                    .frame(height: 4)
                                }
                            }

                            // Exercise Line
                            HStack(spacing: 12) {
                                Image(systemName: "figure.run")
                                    .font(.system(size: 16))
                                    .foregroundColor(.green)
                                    .frame(width: 24)

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Exercise")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text("\(Int(viewModel.exerciseProgress * 100))%")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.secondary.opacity(0.2))
                                                .frame(height: 4)

                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.green.gradient)
                                                .frame(width: geometry.size.width * CGFloat(viewModel.exerciseProgress), height: 4)
                                        }
                                    }
                                    .frame(height: 4)
                                }
                            }

                            // Stand Line
                            HStack(spacing: 12) {
                                Image(systemName: "figure.stand")
                                    .font(.system(size: 16))
                                    .foregroundColor(.blue)
                                    .frame(width: 24)

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Stand")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text("\(Int(viewModel.standProgress * 100))%")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.secondary.opacity(0.2))
                                                .frame(height: 4)

                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.blue.gradient)
                                                .frame(width: geometry.size.width * CGFloat(viewModel.standProgress), height: 4)
                                        }
                                    }
                                    .frame(height: 4)
                                }
                            }

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
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.secondary.opacity(0.2))
                                                .frame(height: 4)

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
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.secondary.opacity(0.2))
                                                .frame(height: 4)

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

                    // Daily Digest
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Daily Digest")
                            .font(.headline)
                            .padding(.horizontal)

                        TabView(selection: $selectedDigestIndex) {
                            ForEach(Array(viewModel.dailyDigests.enumerated()), id: \.offset) { index, digest in
                                DailyDigestCard(digest: digest)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .frame(height: 180)
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                    }

                    // Data Sources Section (moved to bottom)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Connected Apps & Permissions")
                            .font(.headline)
                            .padding(.horizontal)

                        VStack(spacing: 12) {
                            // Apple Integrations
                            DataSourceRow(
                                icon: "apple.logo",
                                title: "Apple Contacts",
                                subtitle: "Access to your contacts",
                                isConnected: $viewModel.appleContactsConnected,
                                color: .gray
                            )

                            DataSourceRow(
                                icon: "heart.fill",
                                title: "Apple Health",
                                subtitle: "Activity, sleep, and health data",
                                isConnected: $viewModel.appleHealthConnected,
                                color: .pink
                            )

                            DataSourceRow(
                                icon: "location.fill",
                                title: "Location Services",
                                subtitle: "Background location tracking",
                                isConnected: $viewModel.locationServicesConnected,
                                color: .blue
                            )

                            DataSourceRow(
                                icon: "app.connected.to.app.below.fill",
                                title: "Activity from Other Apps",
                                subtitle: "Cross-app activity tracking",
                                isConnected: $viewModel.activityTrackingConnected,
                                color: .purple
                            )

                            // Google Integrations
                            DataSourceRow(
                                icon: "calendar",
                                title: "Google Calendar",
                                subtitle: "Events and scheduling",
                                isConnected: $viewModel.googleCalendarConnected,
                                color: .red
                            )

                            DataSourceRow(
                                icon: "envelope.fill",
                                title: "Gmail",
                                subtitle: "Email communications",
                                isConnected: $viewModel.gmailConnected,
                                color: .red
                            )

                            // Meta Integrations
                            DataSourceRow(
                                icon: "camera.fill",
                                title: "Instagram",
                                subtitle: "Posts, stories, and messages",
                                isConnected: $viewModel.instagramConnected,
                                color: .pink
                            )

                            DataSourceRow(
                                icon: "person.3.fill",
                                title: "Facebook",
                                subtitle: "Social graph and activity",
                                isConnected: $viewModel.facebookConnected,
                                color: .blue
                            )

                            // Other Social
                            DataSourceRow(
                                icon: "music.note",
                                title: "TikTok",
                                subtitle: "Videos and interactions",
                                isConnected: $viewModel.tiktokConnected,
                                color: .black
                            )

                            DataSourceRow(
                                icon: "briefcase.fill",
                                title: "LinkedIn",
                                subtitle: "Professional network",
                                isConnected: $viewModel.linkedInConnected,
                                color: .blue
                            )

                            DataSourceRow(
                                icon: "bird.fill",
                                title: "X (Twitter)",
                                subtitle: "Tweets and social activity",
                                isConnected: $viewModel.xConnected,
                                color: .black
                            )

                            DataSourceRow(
                                icon: "newspaper.fill",
                                title: "Substack",
                                subtitle: "Reading and subscriptions",
                                isConnected: $viewModel.substackConnected,
                                color: .orange
                            )

                            // AI Assistants
                            DataSourceRow(
                                icon: "sparkles",
                                title: "Claude",
                                subtitle: "AI conversations",
                                isConnected: $viewModel.claudeConnected,
                                color: .orange
                            )

                            DataSourceRow(
                                icon: "bubble.left.and.bubble.right.fill",
                                title: "ChatGPT",
                                subtitle: "AI interactions",
                                isConnected: $viewModel.chatGPTConnected,
                                color: .green
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

// MARK: - Daily Digest Card
struct DailyDigestCard: View {
    let digest: DailyDigest

    var body: some View {
        NavigationLink(destination: DigestDetailView(digest: digest)) {
            VStack(alignment: .leading, spacing: 12) {
                // Icon and Title
                HStack(spacing: 12) {
                    Image(systemName: digest.icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                        .background(digest.color.gradient)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(digest.title)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text(digest.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }

                // Score
                HStack {
                    Text("\(digest.score)/100")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(digest.color)

                    Spacer()

                    // Trend indicator
                    HStack(spacing: 4) {
                        Image(systemName: digest.trend > 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption)
                        Text("\(abs(digest.trend))%")
                            .font(.caption)
                    }
                    .foregroundColor(digest.trend > 0 ? .green : .red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                }

                // Brief insight
                Text(digest.insight)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Digest Detail View
struct DigestDetailView: View {
    let digest: DailyDigest

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: digest.icon)
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .frame(width: 64, height: 64)
                            .background(digest.color.gradient)
                            .clipShape(Circle())

                        Spacer()

                        VStack(alignment: .trailing) {
                            Text("\(digest.score)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(digest.color)
                            Text("out of 100")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Text(digest.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(digest.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()

                // Full insight
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today's Insight")
                        .font(.headline)

                    Text(digest.detailedInsight)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(digest.title)
        .navigationBarTitleDisplayMode(.inline)
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

// MARK: - Models
struct DailyDigest: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let score: Int
    let trend: Int // positive for up, negative for down
    let insight: String
    let detailedInsight: String
}
