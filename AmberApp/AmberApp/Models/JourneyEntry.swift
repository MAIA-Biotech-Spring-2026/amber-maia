//
//  JourneyEntry.swift
//  Amber
//
//  Created on 2026-02-10.
//

import Foundation
import SwiftUI

enum InteractionType: String, Codable, CaseIterable {
    case inPerson = "In Person"
    case call = "Call"
    case text = "Text"
    case video = "Video"
    case socialMedia = "Social Media"
    case email = "Email"
    case group = "Group"

    var icon: String {
        switch self {
        case .inPerson: return "figure.2"
        case .call: return "phone.fill"
        case .text: return "message.fill"
        case .video: return "video.fill"
        case .socialMedia: return "at"
        case .email: return "envelope.fill"
        case .group: return "person.3.fill"
        }
    }
}

enum MoodType: String, Codable, CaseIterable {
    case happy = "Happy"
    case sad = "Sad"
    case calm = "Calm"
    case energized = "Energized"
    case grateful = "Grateful"
    case frustrated = "Frustrated"

    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .sad: return "😔"
        case .calm: return "😌"
        case .energized: return "⚡"
        case .grateful: return "🥰"
        case .frustrated: return "😤"
        }
    }

    var color: Color {
        switch self {
        case .happy: return .green
        case .sad: return .blue
        case .calm: return Color(red: 0.0, green: 0.48, blue: 1.0)
        case .energized: return .orange
        case .grateful: return .pink
        case .frustrated: return .red
        }
    }

    var backgroundColor: Color {
        color.opacity(0.15)
    }
}

struct JourneyMood: Codable {
    let type: MoodType
    let intensity: Int // 1-5

    var emoji: String { type.emoji }
    var label: String { type.rawValue }
    var color: Color { type.color }
}

struct JourneyEntry: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let personId: UUID
    let personName: String
    let personAvatar: String?
    let interactionType: InteractionType
    let mood: JourneyMood
    let note: String?
    let duration: Int? // minutes
    let location: String?
    let tags: [String]

    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        personId: UUID,
        personName: String,
        personAvatar: String? = nil,
        interactionType: InteractionType,
        mood: JourneyMood,
        note: String? = nil,
        duration: Int? = nil,
        location: String? = nil,
        tags: [String] = []
    ) {
        self.id = id
        self.timestamp = timestamp
        self.personId = personId
        self.personName = personName
        self.personAvatar = personAvatar
        self.interactionType = interactionType
        self.mood = mood
        self.note = note
        self.duration = duration
        self.location = location
        self.tags = tags
    }
}

struct DaySummary: Identifiable {
    let id = UUID()
    let date: Date
    let entries: [JourneyEntry]

    var overallMood: JourneyMood {
        guard !entries.isEmpty else {
            return JourneyMood(type: .calm, intensity: 3)
        }

        // Calculate average mood
        let moodCounts = Dictionary(grouping: entries, by: { $0.mood.type })
        let dominantMood = moodCounts.max(by: { $0.value.count < $1.value.count })?.key ?? .calm
        let avgIntensity = entries.reduce(0) { $0 + $1.mood.intensity } / entries.count

        return JourneyMood(type: dominantMood, intensity: avgIntensity)
    }

    var dominantPerson: String? {
        let personCounts = Dictionary(grouping: entries, by: { $0.personName })
        return personCounts.max(by: { $0.value.count < $1.value.count })?.key
    }

    var entryCount: Int {
        entries.count
    }

    var dateString: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, MMM d"
            return formatter.string(from: date)
        }
    }
}
