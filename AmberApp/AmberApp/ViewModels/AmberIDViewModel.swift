//
//  AmberIDViewModel.swift
//  Amber
//
//  Created on 2026-01-17.
//

import SwiftUI
import Combine

@MainActor
class AmberIDViewModel: ObservableObject {
    @Published var user: AmberUser = .placeholder
    @Published var stories: [AmberStory] = []

    // Data source integration toggles
    @Published var calendarConnected = false
    @Published var emailConnected = false
    @Published var contactsConnected = false
    @Published var healthKitConnected = false
    @Published var linkedInConnected = false
    @Published var fitnessConnected = false
    @Published var notesConnected = false
    @Published var messagingConnected = false

    init() {
        loadMockData()
    }

    private func loadMockData() {
        stories = [
            AmberStory(
                emoji: "🧠",
                title: "Top 10%",
                subtitle: "Emotional intelligence",
                color: .healthEmotional
            ),
            AmberStory(
                emoji: "📈",
                title: "+23%",
                subtitle: "Network growth",
                color: .healthFinancial
            ),
            AmberStory(
                emoji: "🦉",
                title: "Wise Owl",
                subtitle: "Your spirit animal",
                color: .healthSpiritual
            )
        ]
    }
}
