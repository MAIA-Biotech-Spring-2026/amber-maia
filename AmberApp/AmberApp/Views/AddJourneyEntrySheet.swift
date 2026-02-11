//
//  AddJourneyEntrySheet.swift
//  Amber
//
//  Created on 2026-02-10.
//

import SwiftUI

struct AddJourneyEntrySheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JourneyViewModel

    @State private var currentStep = 0
    @State private var selectedPerson: String?
    @State private var selectedInteractionType: InteractionType?
    @State private var selectedMood: MoodType?
    @State private var moodIntensity: Int = 3
    @State private var note: String = ""
    @State private var tags: [String] = []

    let steps = ["Who?", "How?", "Feel?", "Note"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Circle()
                            .fill(index <= currentStep ? Color.amberBlue : Color.secondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 20)

                // Step content
                TabView(selection: $currentStep) {
                    // Step 1: Who
                    SelectPersonStep(selectedPerson: $selectedPerson)
                        .tag(0)

                    // Step 2: How
                    SelectInteractionTypeStep(selectedType: $selectedInteractionType)
                        .tag(1)

                    // Step 3: Feel
                    SelectMoodStep(selectedMood: $selectedMood, intensity: $moodIntensity)
                        .tag(2)

                    // Step 4: Note
                    NoteStep(note: $note, tags: $tags)
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Navigation buttons
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                currentStep -= 1
                            }
                        }
                        .font(.body)
                        .foregroundColor(.amberBlue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.amberBlue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button(currentStep == 3 ? "Save" : "Next") {
                        if currentStep == 3 {
                            saveEntry()
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                currentStep += 1
                            }
                        }
                    }
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(canProceed ? Color.amberBlue : Color.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(!canProceed)
                }
                .padding()
            }
            .navigationTitle(steps[currentStep])
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    var canProceed: Bool {
        switch currentStep {
        case 0: return selectedPerson != nil
        case 1: return selectedInteractionType != nil
        case 2: return selectedMood != nil
        case 3: return true
        default: return false
        }
    }

    func saveEntry() {
        guard let person = selectedPerson,
              let type = selectedInteractionType,
              let mood = selectedMood else {
            return
        }

        let entry = JourneyEntry(
            personId: UUID(),
            personName: person,
            interactionType: type,
            mood: JourneyMood(type: mood, intensity: moodIntensity),
            note: note.isEmpty ? nil : note,
            tags: tags
        )

        viewModel.addEntry(entry)
        dismiss()
    }
}

// MARK: - Step 1: Select Person
struct SelectPersonStep: View {
    @Binding var selectedPerson: String?

    let recentPeople = ["Sarah", "Michael", "Emma", "James", "Alex", "Taylor"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Who did you interact with?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(recentPeople, id: \.self) { person in
                        PersonSelectionButton(
                            name: person,
                            isSelected: selectedPerson == person
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedPerson = person
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

struct PersonSelectionButton: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ContactAvatar(name: name, imageURL: nil, size: 56)

                Text(name)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.amberBlue.opacity(0.1) : Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? Color.amberBlue : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Step 2: Select Interaction Type
struct SelectInteractionTypeStep: View {
    @Binding var selectedType: InteractionType?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("How did you connect?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(InteractionType.allCases, id: \.self) { type in
                        InteractionTypeButton(
                            type: type,
                            isSelected: selectedType == type
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedType = type
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

struct InteractionTypeButton: View {
    let type: InteractionType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: type.icon)
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? .amberBlue : .secondary)

                Text(type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(isSelected ? Color.amberBlue.opacity(0.1) : Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? Color.amberBlue : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Step 3: Select Mood
struct SelectMoodStep: View {
    @Binding var selectedMood: MoodType?
    @Binding var intensity: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("How did it make you feel?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(MoodType.allCases, id: \.self) { mood in
                        MoodSelectionButton(
                            mood: mood,
                            isSelected: selectedMood == mood
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedMood = mood
                            }
                        }
                    }
                }
                .padding(.horizontal)

                if selectedMood != nil {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Intensity")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        HStack(spacing: 12) {
                            ForEach(1...5, id: \.self) { level in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        intensity = level
                                    }
                                }) {
                                    Circle()
                                        .fill(level <= intensity ? selectedMood!.color : Color.secondary.opacity(0.2))
                                        .frame(width: 32, height: 32)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.vertical)
        }
    }
}

struct MoodSelectionButton: View {
    let mood: MoodType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(mood.emoji)
                    .font(.system(size: 48))

                Text(mood.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(isSelected ? mood.backgroundColor : Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? mood.color : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.1 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Step 4: Note
struct NoteStep: View {
    @Binding var note: String
    @Binding var tags: [String]
    @State private var newTag: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Anything to remember?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)

                VStack(alignment: .trailing, spacing: 8) {
                    TextEditor(text: $note)
                        .frame(height: 120)
                        .padding(12)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            Group {
                                if note.isEmpty {
                                    Text("Had a great deep conversation about...")
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 16)
                                        .padding(.top, 20)
                                }
                            },
                            alignment: .topLeading
                        )

                    Text("\(note.count)/280")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Tags (optional)")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    HStack {
                        TextField("Add tag", text: $newTag)
                            .textFieldStyle(.plain)
                            .padding(8)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onSubmit {
                                if !newTag.isEmpty {
                                    tags.append(newTag)
                                    newTag = ""
                                }
                            }

                        Button(action: {
                            if !newTag.isEmpty {
                                tags.append(newTag)
                                newTag = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.amberBlue)
                        }
                    }

                    if !tags.isEmpty {
                        FlowLayout(spacing: 8) {
                            ForEach(tags, id: \.self) { tag in
                                HStack(spacing: 4) {
                                    Text(tag)
                                        .font(.caption)
                                    Button(action: {
                                        tags.removeAll { $0 == tag }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.caption2)
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color(UIColor.tertiarySystemFill))
                                .clipShape(Capsule())
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// Simple flow layout for tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}
