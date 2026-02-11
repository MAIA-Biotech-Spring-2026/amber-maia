//
//  JourneyView.swift
//  Amber
//
//  Created on 2026-02-10.
//

import SwiftUI

struct JourneyView: View {
    @StateObject private var viewModel = JourneyViewModel()
    @State private var showAddEntry = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Mood streak bar
                        MoodStreakBar(moods: viewModel.last7DaysMoods)
                            .padding(.horizontal)

                        // Today's mood check-in (if not logged)
                        if !viewModel.hasLoggedToday {
                            TodayMoodCheckIn(viewModel: viewModel, showAddEntry: $showAddEntry)
                                .padding(.horizontal)
                        }

                        // Weekly mood graph
                        WeeklyMoodGraph(entries: viewModel.entries, stats: viewModel.weeklyStats)
                            .padding(.horizontal)

                        // Timeline feed
                        if viewModel.daySummaries.isEmpty {
                            JourneyEmptyState(showAddEntry: $showAddEntry)
                                .padding(.top, 40)
                        } else {
                            JourneyTimeline(daySummaries: viewModel.daySummaries)
                                .padding(.horizontal)
                        }

                        // Insights
                        if !viewModel.insights.isEmpty {
                            InsightsSection(insights: viewModel.insights)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    .padding(.bottom, 140)
                }
            }
            .navigationTitle("Journey")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddEntry = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.amberBlue)
                    }
                }
            }
            .sheet(isPresented: $showAddEntry) {
                AddJourneyEntrySheet(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Mood Streak Bar
struct MoodStreakBar: View {
    let moods: [JourneyMood?]
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<moods.count, id: \.self) { index in
                ZStack {
                    if let mood = moods[index] {
                        Circle()
                            .fill(mood.color)
                            .frame(width: index == moods.count - 1 ? 14 : 10, height: index == moods.count - 1 ? 14 : 10)
                            .scaleEffect(index == moods.count - 1 ? pulseScale : 1.0)
                    } else {
                        Circle()
                            .strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1.5)
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .padding(.vertical, 12)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseScale = 1.15
            }
        }
    }
}

// MARK: - Today's Mood Check-In
struct TodayMoodCheckIn: View {
    @ObservedObject var viewModel: JourneyViewModel
    @Binding var showAddEntry: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How are you feeling right now?")
                .font(.title3)
                .fontWeight(.semibold)

            HStack(spacing: 12) {
                ForEach(MoodType.allCases, id: \.self) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: viewModel.selectedMood == mood
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectTodayMood(mood)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showAddEntry = true
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [
                    Color.amberBlue.opacity(0.06),
                    Color.purple.opacity(0.06)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.amberBlue.opacity(0.1), lineWidth: 1)
        )
    }
}

struct MoodButton: View {
    let mood: MoodType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(mood.emoji)
                    .font(.system(size: 28))

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(mood.color)
                }
            }
            .frame(width: 44, height: 44)
            .background(isSelected ? mood.backgroundColor : Color.clear)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(isSelected ? mood.color : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.1 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Weekly Mood Graph
struct WeeklyMoodGraph: View {
    let entries: [JourneyEntry]
    let stats: (interactions: Int, people: Int, dominantMood: String)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("This Week")
                    .font(.headline)

                Spacer()

                // Toggle for Week/Month (placeholder)
                HStack(spacing: 8) {
                    Text("Week")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.amberBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.amberBlue.opacity(0.15))
                        .clipShape(Capsule())

                    Text("Month")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                }
            }

            // Simplified graph visualization
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
                    .frame(height: 120)

                Text("📊 Graph Visualization")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Stats
            HStack(spacing: 20) {
                StatPill(label: "\(stats.interactions) interactions")
                StatPill(label: "\(stats.people) people")
                StatPill(label: "Mostly \(stats.dominantMood)")
            }
        }
        .padding(16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct StatPill: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(Capsule())
    }
}

// MARK: - Journey Timeline
struct JourneyTimeline: View {
    let daySummaries: [DaySummary]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(daySummaries) { summary in
                DayGroupHeader(summary: summary)

                ForEach(summary.entries) { entry in
                    InteractionCard(entry: entry, isLast: entry.id == summary.entries.last?.id)
                }
            }
        }
    }
}

struct DayGroupHeader: View {
    let summary: DaySummary

    var body: some View {
        HStack {
            Text(summary.dateString.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .tracking(0.5)

            Spacer()

            Circle()
                .fill(summary.overallMood.color)
                .frame(width: 10, height: 10)
        }
        .padding(.vertical, 12)
    }
}

struct InteractionCard: View {
    let entry: JourneyEntry
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Avatar column
            VStack(spacing: 0) {
                ContactAvatar(
                    name: entry.personName,
                    imageURL: entry.personAvatar,
                    size: 40
                )

                if !isLast {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.2))
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 40)

            // Content column
            VStack(alignment: .leading, spacing: 8) {
                // Name + type + time
                HStack {
                    Text(entry.personName)
                        .font(.body)
                        .fontWeight(.semibold)

                    Image(systemName: entry.interactionType.icon)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Text(entry.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Mood pill
                HStack(spacing: 4) {
                    Text(entry.mood.emoji)
                        .font(.caption)
                    Text(entry.mood.label)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(entry.mood.color.opacity(0.15))
                .clipShape(Capsule())

                // Note
                if let note = entry.note {
                    Text(note)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }

                // Tags
                if !entry.tags.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(entry.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(UIColor.tertiarySystemFill))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .padding(.vertical, 12)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // TODO: Show detail view
        }
    }
}

// MARK: - Empty State
struct JourneyEmptyState: View {
    @Binding var showAddEntry: Bool

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.walk.circle")
                .font(.system(size: 64))
                .foregroundColor(.secondary)

            VStack(spacing: 8) {
                Text("Your journey starts here")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Tag an interaction to begin tracking how your relationships make you feel")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 280)
            }

            Button(action: { showAddEntry = true }) {
                Text("Log First Interaction")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.amberBlue.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 32)
        }
        .padding(.vertical, 40)
    }
}

// MARK: - Insights Section
struct InsightsSection: View {
    let insights: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(.title3)
                .fontWeight(.bold)

            ForEach(insights, id: \.self) { insight in
                InsightCard(text: insight)
            }
        }
        .padding(.top, 20)
    }
}

struct InsightCard: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.amberBlue.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
