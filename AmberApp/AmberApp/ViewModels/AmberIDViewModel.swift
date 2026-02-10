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

    // Live tracking data
    @Published var moveProgress: Double = 0.75       // 75% of move goal
    @Published var exerciseProgress: Double = 0.60   // 60% of exercise goal
    @Published var standProgress: Double = 0.85      // 85% of stand goal
    @Published var sleepHours: Double = 7.2          // 7.2 hours of sleep
    @Published var screenTimeHours: Double = 3.5     // 3.5 hours screen time

    init() {
        loadMockData()
        startLiveTracking()
    }

    private func startLiveTracking() {
        // In production, this would connect to HealthKit and Screen Time APIs
        // For now, we'll simulate realistic data
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateLiveData()
            }
        }
    }

    private func updateLiveData() {
        // Simulate gradual progress throughout the day
        moveProgress = min(moveProgress + 0.05, 1.0)
        exerciseProgress = min(exerciseProgress + 0.03, 1.0)
        standProgress = min(standProgress + 0.02, 1.0)
        sleepHours = Double.random(in: 6.5...8.5)
        screenTimeHours = min(screenTimeHours + 0.1, 8.0)
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
