//
//  DailyTestCard.swift
//  AmberApp
//

import SwiftUI

struct DailyTestCard: View {
    @State private var selectedEmotions: Set<String> = []
    @State private var cycleStarted = false
    @State private var energyLevel = 3
    @State private var sleepQuality = 3

    let emotions = [
        ("😊", "Happy"), ("😌", "Calm"), ("😔", "Sad"),
        ("😰", "Anxious"), ("😤", "Angry"), ("🥰", "Loved"),
        ("😴", "Tired"), ("✨", "Energized"), ("🤔", "Thoughtful")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.cyan)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Daily Check-In")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text("How are you feeling today?")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(selectedEmotions.isEmpty ? .secondary : .green)
            }

            // Emotion Tags
            VStack(alignment: .leading, spacing: 8) {
                Text("I'm feeling...")
                    .font(.subheadline)
                    .fontWeight(.medium)

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(emotions, id: \.1) { emoji, label in
                        Button {
                            if selectedEmotions.contains(label) {
                                selectedEmotions.remove(label)
                            } else {
                                selectedEmotions.insert(label)
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Text(emoji)
                                    .font(.title2)
                                Text(label)
                                    .font(.caption2)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                selectedEmotions.contains(label)
                                    ? Color.cyan.opacity(0.15)
                                    : Color(UIColor.secondarySystemBackground)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .strokeBorder(
                                        selectedEmotions.contains(label) ? Color.cyan : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Divider()

            // Quick Questions
            VStack(spacing: 12) {
                // Cycle Question
                HStack {
                    Image(systemName: "circle.circle")
                        .font(.system(size: 16))
                        .foregroundColor(.pink)

                    Text("Did your cycle start today?")
                        .font(.subheadline)

                    Spacer()

                    Toggle("", isOn: $cycleStarted)
                        .labelsHidden()
                        .tint(.pink)
                }

                // Energy Level
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.orange)

                        Text("Energy Level")
                            .font(.subheadline)

                        Spacer()

                        Text("\(energyLevel)/5")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { level in
                            Circle()
                                .fill(level <= energyLevel ? Color.orange : Color.secondary.opacity(0.2))
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    energyLevel = level
                                }
                        }
                    }
                }

                // Sleep Quality
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "moon.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.indigo)

                        Text("Sleep Quality")
                            .font(.subheadline)

                        Spacer()

                        Text("\(sleepQuality)/5")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { level in
                            Circle()
                                .fill(level <= sleepQuality ? Color.indigo : Color.secondary.opacity(0.2))
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    sleepQuality = level
                                }
                        }
                    }
                }
            }

            // Save Button
            Button {
                // Save daily check-in data
            } label: {
                Text("Complete Check-In")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.cyan.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .disabled(selectedEmotions.isEmpty)
            .opacity(selectedEmotions.isEmpty ? 0.5 : 1.0)
        }
        .padding(20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.cyan.opacity(0.3), lineWidth: 1.5)
        )
    }
}
