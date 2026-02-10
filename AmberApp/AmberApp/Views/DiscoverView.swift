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
    case globe = "Globe"

    var icon: String {
        switch self {
        case .tree: return "figure.2.and.child.holdinghands"
        case .network: return "circle.hexagonpath.fill"
        case .globe: return "globe.americas.fill"
        }
    }
}

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @State private var messageText = ""
    @State private var networkMode: NetworkViewMode = .network
    @State private var showNetworkVisualization = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(UIColor.systemBackground),
                    Color(UIColor.systemBackground).opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Network visualization mode selector
                NetworkModePill(selectedMode: $networkMode, isExpanded: $showNetworkVisualization)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)

                // Spatial network visualization overlay
                if showNetworkVisualization {
                    NetworkVisualizationView(mode: networkMode)
                        .frame(height: 250)
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
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

                // Input bar at bottom
                ChatInputBar(
                    text: $messageText,
                    isFocused: $isInputFocused,
                    onSend: sendMessage
                )
                .padding(.horizontal, 16)
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
    @State private var longPressActive = false

    var body: some View {
        HStack(spacing: 0) {
            // Tree view (left)
            ModeButton(
                mode: .tree,
                isSelected: selectedMode == .tree,
                isExpanded: longPressActive
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedMode = .tree
                    isExpanded = true
                }
            }

            Spacer()

            // Network view (center) - default
            ModeButton(
                mode: .network,
                isSelected: selectedMode == .network,
                isExpanded: longPressActive,
                isCenter: true
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedMode = .network
                    isExpanded = true
                }
            }

            Spacer()

            // Globe view (right)
            ModeButton(
                mode: .globe,
                isSelected: selectedMode == .globe,
                isExpanded: longPressActive
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedMode = .globe
                    isExpanded = true
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule()
                .strokeBorder(Color.amberBlue.opacity(isExpanded ? 0.3 : 0), lineWidth: 2)
        )
        .onLongPressGesture(minimumDuration: 0.5) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isExpanded.toggle()
                longPressActive = true
            }
        }
        .onTapGesture {
            if isExpanded {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded = false
                }
            }
        }
    }
}

struct ModeButton: View {
    let mode: NetworkViewMode
    let isSelected: Bool
    let isExpanded: Bool
    var isCenter: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: mode.icon)
                    .font(.system(size: isCenter ? 24 : 20, weight: .medium))
                    .foregroundColor(isSelected ? .amberBlue : .secondary)
                    .scaleEffect(isSelected ? 1.1 : 1.0)

                if isExpanded {
                    Text(mode.rawValue)
                        .font(.caption2)
                        .foregroundColor(isSelected ? .amberBlue : .secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Network Visualization
struct NetworkVisualizationView: View {
    let mode: NetworkViewMode
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(Color.amberBlue.opacity(0.2), lineWidth: 1)
                )

            switch mode {
            case .tree:
                TreeVisualization()
            case .network:
                NetworkVisualization()
            case .globe:
                GlobeVisualization(rotationAngle: rotationAngle)
            }
        }
        .onAppear {
            if mode == .globe {
                withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
        }
    }
}

struct TreeVisualization: View {
    var body: some View {
        Canvas { context, size in
            let centerX = size.width / 2
            let centerY = size.height / 2

            // Draw tree structure
            drawTreeNode(context: context, x: centerX, y: centerY - 60, generation: 0, maxGen: 2)
        }
        .padding()
    }

    private func drawTreeNode(context: GraphicsContext, x: CGFloat, y: CGFloat, generation: Int, maxGen: Int) {
        let nodeSize: CGFloat = 12 - CGFloat(generation) * 2
        let circle = Circle().path(in: CGRect(x: x - nodeSize/2, y: y - nodeSize/2, width: nodeSize, height: nodeSize))
        context.fill(circle, with: .color(.amberBlue.opacity(1.0 - Double(generation) * 0.2)))

        if generation < maxGen {
            let spacing: CGFloat = 50 - CGFloat(generation) * 15
            let childY = y + 40

            for i in 0...1 {
                let childX = x + (i == 0 ? -spacing : spacing)

                var path = Path()
                path.move(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: childX, y: childY))
                context.stroke(path, with: .color(.amberBlue.opacity(0.3)), lineWidth: 2)

                drawTreeNode(context: context, x: childX, y: childY, generation: generation + 1, maxGen: maxGen)
            }
        }
    }
}

struct NetworkVisualization: View {
    @State private var positions: [(CGFloat, CGFloat, CGFloat)] = []

    var body: some View {
        Canvas { context, size in
            let centerX = size.width / 2
            let centerY = size.height / 2

            // Generate positions if needed
            if positions.isEmpty {
                positions = (0..<12).map { i in
                    let angle = Double(i) * .pi * 2 / 12
                    let radius = CGFloat.random(in: 40...80)
                    let x = centerX + cos(angle) * radius
                    let y = centerY + sin(angle) * radius
                    let size = CGFloat.random(in: 6...14)
                    return (x, y, size)
                }
            }

            // Draw connections
            for i in 0..<positions.count {
                for j in (i+1)..<positions.count {
                    if Double.random(in: 0...1) > 0.7 {
                        var path = Path()
                        path.move(to: CGPoint(x: positions[i].0, y: positions[i].1))
                        path.addLine(to: CGPoint(x: positions[j].0, y: positions[j].1))
                        context.stroke(path, with: .color(.amberBlue.opacity(0.15)), lineWidth: 1)
                    }
                }
            }

            // Draw nodes
            for pos in positions {
                let circle = Circle().path(in: CGRect(x: pos.0 - pos.2/2, y: pos.1 - pos.2/2, width: pos.2, height: pos.2))
                context.fill(circle, with: .color(.amberBlue))
            }

            // Draw center node (you)
            let centerCircle = Circle().path(in: CGRect(x: centerX - 10, y: centerY - 10, width: 20, height: 20))
            context.fill(centerCircle, with: .color(.white))
            context.stroke(centerCircle, with: .color(.amberBlue), lineWidth: 3)
        }
        .padding()
    }
}

struct GlobeVisualization: View {
    let rotationAngle: Double

    var body: some View {
        Canvas { context, size in
            let centerX = size.width / 2
            let centerY = size.height / 2
            let radius: CGFloat = 70

            // Draw globe outline
            let globe = Circle().path(in: CGRect(x: centerX - radius, y: centerY - radius, width: radius * 2, height: radius * 2))
            context.stroke(globe, with: .color(.amberBlue.opacity(0.3)), lineWidth: 2)

            // Draw latitude lines
            for i in 1...3 {
                let yOffset = CGFloat(i - 2) * radius / 2
                let ellipseHeight: CGFloat = 20
                let ellipse = Ellipse().path(in: CGRect(
                    x: centerX - radius,
                    y: centerY + yOffset - ellipseHeight/2,
                    width: radius * 2,
                    height: ellipseHeight
                ))
                context.stroke(ellipse, with: .color(.amberBlue.opacity(0.2)), lineWidth: 1)
            }

            // Draw points on globe
            for i in 0..<8 {
                let angle = Double(i) * .pi * 2 / 8 + rotationAngle * .pi / 180
                let x = centerX + cos(angle) * radius * 0.8
                let y = centerY + sin(angle) * radius * 0.4

                let point = Circle().path(in: CGRect(x: x - 4, y: y - 4, width: 8, height: 8))
                context.fill(point, with: .color(.amberBlue))
            }
        }
        .padding()
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

// MARK: - Chat Input Bar
struct ChatInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let onSend: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Plus button
            Button(action: {}) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.secondary)
            }

            // Text input
            HStack(spacing: 8) {
                TextField("Ask Amber anything...", text: $text, axis: .vertical)
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
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            // Send button
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(text.isEmpty ? .secondary : .amberBlue)
            }
            .disabled(text.isEmpty)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.separator.opacity(0.5), lineWidth: 0.5)
        )
    }
}

// MARK: - Chat Message Model
struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
    let timestamp: Date
}
