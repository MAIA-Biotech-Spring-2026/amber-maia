//
//  JourneyViewModel.swift
//  Amber
//
//  Created on 2026-02-10.
//

import SwiftUI
import Combine

@MainActor
class JourneyViewModel: ObservableObject {
    @Published var entries: [JourneyEntry] = []
    @Published var selectedMood: MoodType?
    @Published var hasLoggedToday: Bool = false

    init() {
        loadMockData()
        checkTodayEntry()
    }

    var daySummaries: [DaySummary] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.startOfDay(for: entry.timestamp)
        }

        return grouped.map { date, entries in
            DaySummary(date: date, entries: entries.sorted { $0.timestamp > $1.timestamp })
        }
        .sorted { $0.date > $1.date }
    }

    var last7DaysMoods: [JourneyMood?] {
        let calendar = Calendar.current
        var moods: [JourneyMood?] = []

        for i in (0..<7).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let dayStart = calendar.startOfDay(for: date)
                let dayEntries = entries.filter {
                    calendar.isDate($0.timestamp, inSameDayAs: dayStart)
                }

                if !dayEntries.isEmpty {
                    let moodCounts = Dictionary(grouping: dayEntries, by: { $0.mood.type })
                    let dominantMood = moodCounts.max(by: { $0.value.count < $1.value.count })?.key ?? .calm
                    let avgIntensity = dayEntries.reduce(0) { $0 + $1.mood.intensity } / dayEntries.count
                    moods.append(JourneyMood(type: dominantMood, intensity: avgIntensity))
                } else {
                    moods.append(nil)
                }
            }
        }

        return moods
    }

    var weeklyStats: (interactions: Int, people: Int, dominantMood: String) {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let weekEntries = entries.filter { $0.timestamp >= weekAgo }

        let uniquePeople = Set(weekEntries.map { $0.personId }).count
        let moodCounts = Dictionary(grouping: weekEntries, by: { $0.mood.type })
        let dominantMood = moodCounts.max(by: { $0.value.count < $1.value.count })?.key ?? .calm

        return (weekEntries.count, uniquePeople, dominantMood.emoji)
    }

    var insights: [String] {
        var insightsList: [String] = []

        // Most positive person
        let happyEntries = entries.filter { $0.mood.type == .happy || $0.mood.type == .grateful }
        let personMoodCounts = Dictionary(grouping: happyEntries, by: { $0.personName })
        if let happiest = personMoodCounts.max(by: { $0.value.count < $1.value.count }) {
            insightsList.append("💡 You feel happiest after seeing \(happiest.key) — \(happiest.value.count) positive interactions")
        }

        // Streak
        if entries.count >= 3 {
            let calendar = Calendar.current
            let uniqueDays = Set(entries.map { calendar.startOfDay(for: $0.timestamp) })
            insightsList.append("🔥 \(uniqueDays.count)-day streak of logging! Keep it going")
        }

        // Day of week pattern
        let calendar = Calendar.current
        let dayOfWeekCounts = Dictionary(grouping: entries, by: { calendar.component(.weekday, from: $0.timestamp) })
        if let lowestDay = dayOfWeekCounts.min(by: { $0.value.count < $1.value.count }) {
            let dayName = calendar.weekdaySymbols[lowestDay.key - 1]
            insightsList.append("📉 Your energy dips on \(dayName)s — consider scheduling lighter interactions")
        }

        return insightsList
    }

    func addEntry(_ entry: JourneyEntry) {
        entries.insert(entry, at: 0)
        checkTodayEntry()
    }

    func selectTodayMood(_ mood: MoodType) {
        selectedMood = mood
    }

    private func checkTodayEntry() {
        let calendar = Calendar.current
        hasLoggedToday = entries.contains { calendar.isDateInToday($0.timestamp) }
    }

    private func loadMockData() {
        let calendar = Calendar.current

        // Today
        entries.append(JourneyEntry(
            timestamp: calendar.date(byAdding: .hour, value: -2, to: Date())!,
            personId: UUID(),
            personName: "Sarah",
            interactionType: .inPerson,
            mood: JourneyMood(type: .happy, intensity: 5),
            note: "Had a great deep conversation about life goals and dreams",
            tags: ["deep talk", "coffee"]
        ))

        // Yesterday
        entries.append(JourneyEntry(
            timestamp: calendar.date(byAdding: .day, value: -1, to: Date())!,
            personId: UUID(),
            personName: "Michael",
            interactionType: .call,
            mood: JourneyMood(type: .energized, intensity: 4),
            note: "Quick catch-up call about the project"
        ))

        entries.append(JourneyEntry(
            timestamp: calendar.date(byAdding: .day, value: -1, to: Date())!,
            personId: UUID(),
            personName: "Emma",
            interactionType: .text,
            mood: JourneyMood(type: .calm, intensity: 3),
            note: nil
        ))

        // 2 days ago
        entries.append(JourneyEntry(
            timestamp: calendar.date(byAdding: .day, value: -2, to: Date())!,
            personId: UUID(),
            personName: "James",
            interactionType: .video,
            mood: JourneyMood(type: .frustrated, intensity: 2),
            note: "Disagreement about plans, but we worked it out"
        ))

        // 3 days ago
        entries.append(JourneyEntry(
            timestamp: calendar.date(byAdding: .day, value: -3, to: Date())!,
            personId: UUID(),
            personName: "Sarah",
            interactionType: .inPerson,
            mood: JourneyMood(type: .grateful, intensity: 5),
            note: "Celebrated her promotion!",
            tags: ["celebration", "dinner"]
        ))

        checkTodayEntry()
    }
}
