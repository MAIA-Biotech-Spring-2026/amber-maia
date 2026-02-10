//
//  DiscoverView.swift
//  Amber
//
//  Created on 2026-01-17.
//

import SwiftUI

enum NetworkViewMode: String, CaseIterable {
    case tree = "Family Tree"
    case network = "Network"
    case map = "Map"

    var icon: String {
        switch self {
        case .tree: return "figure.2.and.child.holdinghands"
        case .network: return "circle.hexagonpath.fill"
        case .map: return "map.fill"
        }
    }
}

enum NetworkSource: String, CaseIterable, Identifiable {
    case instagram = "Instagram"
    case linkedin = "LinkedIn"
    case google = "Google"
    case facebook = "Facebook"
    case twitter = "X"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .instagram: return "camera.fill"
        case .linkedin: return "briefcase.fill"
        case .google: return "magnifyingglass"
        case .facebook: return "person.3.fill"
        case .twitter: return "bird.fill"
        }
    }

    var color: Color {
        switch self {
        case .instagram: return .pink
        case .linkedin: return .blue
        case .google: return .red
        case .facebook: return .blue
        case .twitter: return .black
        }
    }
}

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @State private var messageText = ""
    @State private var networkMode: NetworkViewMode = .network
    @State private var showNetworkVisualization = true
    @State private var selectedSources: Set<NetworkSource> = [.instagram, .linkedin, .google]
    @State private var useAmberAI = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Network mode selector pill
                NetworkModePill(
                    selectedMode: $networkMode,
                    isExpanded: $showNetworkVisualization
                )
                .padding(.top, 16)
                .padding(.horizontal, 16)

                // Source toggles (only for network mode)
                if networkMode == .network && showNetworkVisualization {
                    SourceToggles(
                        selectedSources: $selectedSources,
                        useAmberAI: $useAmberAI
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }

                // Network visualization
                if showNetworkVisualization {
                    NetworkVisualizationContainer(
                        mode: networkMode,
                        selectedSources: useAmberAI ? Set(NetworkSource.allCases) : selectedSources
                    )
                    .frame(maxHeight: 400)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }

                // Chat messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.messages) { message in
                                ChatBubble(message: message)
                                    .id(message.id)
                            }

                            if viewModel.isTyping {
                                TypingIndicator()
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 20)
                    }
                    .onChange(of: viewModel.messages.count) { oldValue, newValue in
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // Perplexity-style input bar
                PerplexityChatInputBar(
                    text: $messageText,
                    isFocused: $isInputFocused,
                    onSend: sendMessage,
                    onAttachment: {},
                    onVoice: {}
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 100)
            }
        }
        .task {
            await viewModel.loadMessages()
        }
    }

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let message = messageText
        messageText = ""
        isInputFocused = false

        Task {
            await viewModel.sendMessage(message)
        }
    }
}

// MARK: - Network Mode Pill
struct NetworkModePill: View {
    @Binding var selectedMode: NetworkViewMode
    @Binding var isExpanded: Bool

    var body: some View {
        HStack(spacing: 0) {
            ForEach(NetworkViewMode.allCases, id: \.self) { mode in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedMode = mode
                        if !isExpanded {
                            isExpanded = true
                        }
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: mode.icon)
                            .font(.system(size: mode == selectedMode ? 20 : 18, weight: .medium))
                            .foregroundColor(mode == selectedMode ? .amberBlue : .secondary)

                        Text(mode.rawValue)
                            .font(.caption2)
                            .foregroundColor(mode == selectedMode ? .amberBlue : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
            }
        }
        .background(.regularMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(Color.amberBlue.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Source Toggles
struct SourceToggles: View {
    @Binding var selectedSources: Set<NetworkSource>
    @Binding var useAmberAI: Bool

    var body: some View {
        VStack(spacing: 12) {
            // Amber AI override toggle
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundColor(.amberBlue)

                    Text("Amber AI")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Text("All Sources")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Toggle("", isOn: $useAmberAI)
                    .labelsHidden()
                    .tint(.amberBlue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Individual source toggles
            if !useAmberAI {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(NetworkSource.allCases) { source in
                            SourceToggleChip(
                                source: source,
                                isSelected: selectedSources.contains(source)
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    if selectedSources.contains(source) {
                                        selectedSources.remove(source)
                                    } else {
                                        selectedSources.insert(source)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SourceToggleChip: View {
    let source: NetworkSource
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: source.icon)
                    .font(.system(size: 12, weight: .semibold))

                Text(source.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : source.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isSelected
                    ? source.color
                    : source.color.opacity(0.15)
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Network Visualization Container
struct NetworkVisualizationContainer: View {
    let mode: NetworkViewMode
    let selectedSources: Set<NetworkSource>

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.amberBlue.opacity(0.15), lineWidth: 1)
                )

            switch mode {
            case .tree:
                BeautifulFamilyTreeView()
            case .network:
                BeautifulNetworkGraphView(sources: selectedSources)
            case .map:
                FindMyFriendsMapView()
            }
        }
    }
}

// MARK: - Beautiful Family Tree View
struct BeautifulFamilyTreeView: View {
    @State private var selectedPerson: String?

    var body: some View {
        Canvas { context, size in
            let centerX = size.width / 2
            let centerY = size.height / 2

            // Draw you (center)
            drawPerson(context: context, x: centerX, y: centerY, name: "You", size: 50, isCenter: true)

            // Parents generation
            let parentY = centerY - 80
            drawPerson(context: context, x: centerX - 80, y: parentY, name: "Mom", size: 40)
            drawPerson(context: context, x: centerX + 80, y: parentY, name: "Dad", size: 40)

            // Connect to parents
            drawConnection(context: context, from: (centerX, centerY), to: (centerX - 80, parentY))
            drawConnection(context: context, from: (centerX, centerY), to: (centerX + 80, parentY))

            // Siblings
            drawPerson(context: context, x: centerX - 100, y: centerY, name: "Sister", size: 45)
            drawPerson(context: context, x: centerX + 100, y: centerY, name: "Brother", size: 45)

            // Grandparents
            let grandparentY = centerY - 160
            drawPerson(context: context, x: centerX - 140, y: grandparentY, name: "GM", size: 35)
            drawPerson(context: context, x: centerX - 20, y: grandparentY, name: "GD", size: 35)
            drawPerson(context: context, x: centerX + 20, y: grandparentY, name: "GM", size: 35)
            drawPerson(context: context, x: centerX + 140, y: grandparentY, name: "GD", size: 35)

            // Connect grandparents to parents
            drawConnection(context: context, from: (centerX - 80, parentY), to: (centerX - 140, grandparentY))
            drawConnection(context: context, from: (centerX - 80, parentY), to: (centerX - 20, grandparentY))
            drawConnection(context: context, from: (centerX + 80, parentY), to: (centerX + 20, grandparentY))
            drawConnection(context: context, from: (centerX + 80, parentY), to: (centerX + 140, grandparentY))
        }
        .padding()
    }

    private func drawPerson(context: GraphicsContext, x: CGFloat, y: CGFloat, name: String, size: CGFloat, isCenter: Bool = false) {
        // Circle
        let circle = Circle().path(in: CGRect(x: x - size/2, y: y - size/2, width: size, height: size))
        context.fill(circle, with: .color(isCenter ? .amberBlue : .white))
        context.stroke(circle, with: .color(.amberBlue), lineWidth: isCenter ? 3 : 2)

        // Name label (simplified for Canvas)
        var text = context.resolve(Text(name).font(.caption).foregroundColor(isCenter ? .white : .primary))
        text.shading = .color(isCenter ? .white : .primary)
        context.draw(text, at: CGPoint(x: x, y: y + size/2 + 12))
    }

    private func drawConnection(context: GraphicsContext, from: (CGFloat, CGFloat), to: (CGFloat, CGFloat)) {
        var path = Path()
        path.move(to: CGPoint(x: from.0, y: from.1))
        path.addLine(to: CGPoint(x: to.0, y: to.1))
        context.stroke(path, with: .color(.amberBlue.opacity(0.3)), lineWidth: 2)
    }
}

// MARK: - Beautiful Network Graph View
struct BeautifulNetworkGraphView: View {
    let sources: Set<NetworkSource>
    @State private var positions: [(String, CGFloat, CGFloat, CGFloat, NetworkSource?)] = []

    var body: some View {
        Canvas { context, size in
            let centerX = size.width / 2
            let centerY = size.height / 2

            // Generate positions if needed
            if positions.isEmpty {
                var newPositions: [(String, CGFloat, CGFloat, CGFloat, NetworkSource?)] = []

                let peopleCount = 15
                for i in 0..<peopleCount {
                    let angle = Double(i) * .pi * 2 / Double(peopleCount)
                    let radius = CGFloat.random(in: 60...120)
                    let x = centerX + cos(angle) * radius
                    let y = centerY + sin(angle) * radius
                    let nodeSize = CGFloat.random(in: 8...16)
                    let source = sources.randomElement()
                    newPositions.append(("Person \(i+1)", x, y, nodeSize, source))
                }
                positions = newPositions
            }

            // Draw connections
            for i in 0..<positions.count {
                for j in (i+1)..<positions.count {
                    if Double.random(in: 0...1) > 0.6 {
                        var path = Path()
                        path.move(to: CGPoint(x: positions[i].1, y: positions[i].2))
                        path.addLine(to: CGPoint(x: positions[j].1, y: positions[j].2))
                        context.stroke(path, with: .color(.amberBlue.opacity(0.1)), lineWidth: 1)
                    }
                }
            }

            // Draw nodes
            for pos in positions {
                let color = pos.4?.color ?? .amberBlue
                let circle = Circle().path(in: CGRect(x: pos.1 - pos.3/2, y: pos.2 - pos.3/2, width: pos.3, height: pos.3))

                // Glow effect
                context.fill(circle, with: .color(color.opacity(0.3)))
                context.fill(
                    Circle().path(in: CGRect(x: pos.1 - pos.3/2 + 2, y: pos.2 - pos.3/2 + 2, width: pos.3 - 4, height: pos.3 - 4)),
                    with: .color(color)
                )
            }

            // Draw center node (you)
            let centerSize: CGFloat = 24
            let centerCircle = Circle().path(in: CGRect(x: centerX - centerSize/2, y: centerY - centerSize/2, width: centerSize, height: centerSize))
            context.fill(centerCircle, with: .color(.white))
            context.stroke(centerCircle, with: .color(.amberBlue), lineWidth: 3)
        }
        .padding()
    }
}

// MARK: - Find My Friends Map View
struct FindMyFriendsMapView: View {
    @State private var locationPins: [(String, CGFloat, CGFloat, Color)] = []

    var body: some View {
        ZStack {
            // Map background (simplified)
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.green.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Canvas { context, size in
                // Generate pins if needed
                if locationPins.isEmpty {
                    var pins: [(String, CGFloat, CGFloat, Color)] = []
                    for i in 0..<8 {
                        let x = CGFloat.random(in: 40...(size.width - 40))
                        let y = CGFloat.random(in: 40...(size.height - 40))
                        let colors: [Color] = [.red, .blue, .green, .purple, .orange, .pink]
                        pins.append(("Person \(i+1)", x, y, colors.randomElement()!))
                    }
                    locationPins = pins
                }

                // Draw location pins
                for pin in locationPins {
                    // Pin circle
                    let pinSize: CGFloat = 40
                    let circle = Circle().path(in: CGRect(x: pin.1 - pinSize/2, y: pin.2 - pinSize/2, width: pinSize, height: pinSize))
                    context.fill(circle, with: .color(pin.3.opacity(0.3)))

                    let innerCircle = Circle().path(in: CGRect(x: pin.1 - 8, y: pin.2 - 8, width: 16, height: 16))
                    context.fill(innerCircle, with: .color(.white))
                    context.stroke(innerCircle, with: .color(pin.3), lineWidth: 3)
                }
            }

            // Location labels overlay
            ForEach(Array(locationPins.enumerated()), id: \.offset) { index, pin in
                VStack(spacing: 2) {
                    Text(pin.0)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                .position(x: pin.1, y: pin.2 + 30)
            }

            // User location (center)
            VStack(spacing: 4) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.blue.opacity(0.3), lineWidth: 12)
                    )

                Text("You")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .position(x: 180, y: 180)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding()
    }
}

// MARK: - Perplexity-Style Chat Input Bar
struct PerplexityChatInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let onSend: () -> Void
    let onAttachment: () -> Void
    let onVoice: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            // Attachment button
            Button(action: onAttachment) {
                Image(systemName: "paperclip")
                    .font(.system(size: 20))
                    .foregroundColor(.secondary)
                    .frame(width: 36, height: 36)
            }

            // Text input
            HStack(spacing: 8) {
                TextField("Ask anything...", text: $text, axis: .vertical)
                    .font(.body)
                    .lineLimit(1...5)
                    .focused(isFocused)
                    .submitLabel(.send)
                    .onSubmit(onSend)

                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            // Voice/Send button
            Button(action: text.isEmpty ? onVoice : onSend) {
                Image(systemName: text.isEmpty ? "waveform" : "arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(text.isEmpty ? Color.secondary : Color.amberBlue)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

// MARK: - Chat Bubble
struct ChatBubble: View {
    let message: ChatMessage

    var isUser: Bool {
        message.isFromUser
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 60) }

            if !isUser {
                Image(systemName: "sparkles")
                    .font(.system(size: 20))
                    .foregroundColor(.amberBlue)
                    .frame(width: 32, height: 32)
                    .background(.ultraThinMaterial, in: Circle())
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .foregroundColor(isUser ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        isUser
                            ? AnyShapeStyle(.linearGradient(colors: [.amberBlue, .amberBlue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            : AnyShapeStyle(.regularMaterial)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }

            if !isUser { Spacer(minLength: 60) }
        }
    }
}

// MARK: - Typing Indicator
struct TypingIndicator: View {
    @State private var animatingDot = 0

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 20))
                .foregroundColor(.amberBlue)
                .frame(width: 32, height: 32)
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
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Spacer(minLength: 60)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                animatingDot = (animatingDot + 1) % 3
            }
        }
    }
}

// MARK: - Chat Message Model
struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
    let timestamp: Date
}
