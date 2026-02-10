//
//  AmberIDView.swift
//  Amber
//
//  Created on 2026-01-17.
//

import SwiftUI
import Combine

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
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Daily Digest")
                            .font(.headline)
                            .padding(.horizontal)

                        VStack(spacing: 16) {
                            ForEach(viewModel.dailyDigests) { digest in
                                DailyDigestCard(digest: digest)
                            }
                        }
                        .padding(.horizontal)
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
                        // Share action
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
            }
        }
    }
}

// MARK: - Daily Digest Card (Perplexity Newsfeed Style)
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

// MARK: - Digest Detail View with Chat
struct DigestDetailView: View {
    let digest: DailyDigest
    @StateObject private var viewModel = DigestChatViewModel()
    @State private var messageText = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: digest.icon)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(digest.color.gradient)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 4) {
                            Text(digest.title)
                                .font(.title3)
                                .fontWeight(.bold)

                            Text(digest.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(digest.score)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(digest.color)
                            Text("/100")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Text(digest.detailedInsight)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
                .padding(20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                .padding(.top, 16)

                // Chat interface
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.messages) { message in
                                DigestChatBubble(message: message, themeColor: digest.color)
                                    .id(message.id)
                            }

                            if viewModel.isTyping {
                                DigestTypingIndicator(themeColor: digest.color)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                    .onChange(of: viewModel.messages.count) { oldValue, newValue in
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // Input bar
                DigestChatInputBar(
                    text: $messageText,
                    isFocused: $isInputFocused,
                    themeColor: digest.color,
                    onSend: {
                        sendMessage()
                    }
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .navigationTitle(digest.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadInitialMessage(for: digest)
        }
    }

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let message = messageText
        messageText = ""
        isInputFocused = false

        Task {
            await viewModel.sendMessage(message, digest: digest)
        }
    }
}

// MARK: - Digest Chat Components
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

// MARK: - Digest Chat ViewModel
@MainActor
class DigestChatViewModel: ObservableObject {
    @Published var messages: [DigestChatMessage] = []
    @Published var isTyping = false

    func loadInitialMessage(for digest: DailyDigest) async {
        messages = [
            DigestChatMessage(
                content: "I've analyzed your \(digest.title.lowercased()) data. \(digest.detailedInsight)\n\nWhat would you like to explore further?",
                isFromUser: false,
                timestamp: Date()
            )
        ]
    }

    func sendMessage(_ text: String, digest: DailyDigest) async {
        let userMessage = DigestChatMessage(
            content: text,
            isFromUser: true,
            timestamp: Date()
        )
        messages.append(userMessage)

        isTyping = true
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        isTyping = false

        let response = generateResponse(for: text, digest: digest)
        let aiMessage = DigestChatMessage(
            content: response,
            isFromUser: false,
            timestamp: Date()
        )
        messages.append(aiMessage)
    }

    private func generateResponse(for query: String, digest: DailyDigest) -> String {
        let lowercaseQuery = query.lowercased()

        // Generate contextual responses based on health dimension
        switch digest.title {
        case "Spiritual Health":
            if lowercaseQuery.contains("improve") || lowercaseQuery.contains("help") {
                return "To improve your spiritual health, I recommend: 1) Morning meditation (start with 5 minutes), 2) Weekly reflection journal, 3) Deep conversations with close friends about values and meaning. Your recent 8% increase shows you're on the right path."
            } else if lowercaseQuery.contains("meditation") {
                return "Your meditation practice has been consistent for 3 weeks. Try expanding to guided visualizations or exploring mindfulness apps like Headspace or Calm. Consider joining a local meditation group for community support."
            }
        case "Emotional Health":
            if lowercaseQuery.contains("improve") || lowercaseQuery.contains("help") {
                return "Your emotional health is strong! To maintain it: 1) Continue regular check-ins with Sarah and Michael, 2) Keep journaling about your feelings, 3) Practice gratitude daily. You're doing great with emotional boundaries."
            } else if lowercaseQuery.contains("sarah") || lowercaseQuery.contains("michael") {
                return "Sarah and Michael are your primary emotional support network. You connect with them 3-4 times per week. These relationships provide strong emotional stability and mutual support. Consider planning a deeper activity together soon."
            }
        case "Physical Health":
            if lowercaseQuery.contains("improve") || lowercaseQuery.contains("workout") {
                return "To boost your physical health: 1) Schedule morning workouts (you're most consistent then), 2) Try a fitness class for variety, 3) Find a workout buddy for accountability. Your move goal is strong, but exercise frequency needs attention."
            }
        case "Social Health":
            if lowercaseQuery.contains("james") {
                return "You haven't connected with James in 3 weeks - your longest gap this year. He's typically responsive to voice calls. Consider reaching out today to maintain that connection. Your friendship history shows strong bonds that benefit from regular check-ins."
            }
        default:
            break
        }

        return "That's a great question about your \(digest.title.lowercased()). Based on your recent patterns, I can provide more specific insights. What aspect would you like to explore - recent trends, specific recommendations, or comparisons with your historical data?"
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
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(color.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

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
    let trend: Int
    let insight: String
    let detailedInsight: String
}

struct DigestChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
    let timestamp: Date
}
