//
//  DiscoverView.swift
//  Amber
//
//  Created on 2026-01-18.
//

import SwiftUI

enum NetworkView: String, CaseIterable {
    case family = "Family"
    case amber = "Amber"
    case geography = "Geography"

    var icon: String {
        switch self {
        case .family: return "tree.fill"
        case .amber: return "network"
        case .geography: return "map.fill"
        }
    }
}

struct DiscoverView: View {
    @State private var selectedView: NetworkView = .amber
    @State private var showFilterSheet = false
    @State private var enabledSources: Set<NetworkSource> = Set(NetworkSource.allCases)

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Network view selector
                    NetworkViewPicker(selectedView: $selectedView)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    // Full screen network visualization
                    TabView(selection: $selectedView) {
                        FamilyNetworkView()
                            .tag(NetworkView.family)

                        AmberNetworkView()
                            .tag(NetworkView.amber)

                        GeographyNetworkView()
                            .tag(NetworkView.geography)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                .padding(.bottom, 140) // Space for input bar + tab bar
            }
            .navigationTitle("Network")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showFilterSheet = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.amberBlue)
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                NetworkFilterSheet(enabledSources: $enabledSources)
                    .presentationDetents([.medium])
            }
        }
    }
}

// MARK: - Network Source
enum NetworkSource: String, CaseIterable, Identifiable {
    case instagram = "Instagram"
    case linkedin = "LinkedIn"
    case appleContacts = "Apple Contacts"
    case facebook = "Facebook"
    case twitter = "X"
    case google = "Google"
    case whatsapp = "WhatsApp"
    case telegram = "Telegram"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .instagram: return "camera.fill"
        case .linkedin: return "briefcase.fill"
        case .appleContacts: return "person.crop.circle.fill"
        case .facebook: return "person.2.fill"
        case .twitter: return "bird.fill"
        case .google: return "envelope.fill"
        case .whatsapp: return "message.fill"
        case .telegram: return "paperplane.fill"
        }
    }

    var color: Color {
        switch self {
        case .instagram: return .purple
        case .linkedin: return .blue
        case .appleContacts: return .gray
        case .facebook: return .blue
        case .twitter: return .black
        case .google: return .red
        case .whatsapp: return .green
        case .telegram: return .cyan
        }
    }
}

// MARK: - Network View Picker
struct NetworkViewPicker: View {
    @Binding var selectedView: NetworkView
    @Namespace private var animation

    var body: some View {
        HStack(spacing: 8) {
            ForEach(NetworkView.allCases, id: \.self) { view in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedView = view
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: view.icon)
                            .font(.system(size: 14, weight: .medium))

                        Text(view.rawValue)
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundStyle(selectedView == view ? Color.amberBlue : Color.primary.opacity(0.6))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background {
                        if selectedView == view {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.amberBlue.opacity(0.12))
                                .matchedGeometryEffect(id: "NETWORK_PICKER", in: animation)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
        )
    }
}

// MARK: - Family Network View
struct FamilyNetworkView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Beautiful family tree visualization
                FamilyTreeCanvas()
                    .frame(height: 500)
                    .padding(.horizontal)

                // Family connections info
                VStack(alignment: .leading, spacing: 12) {
                    Text("Family Connections")
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("Your family network shows relationships across generations, helping you understand your heritage and connections.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Amber Network View
struct AmberNetworkView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Interactive network graph
                NetworkGraphCanvas()
                    .frame(height: 500)
                    .padding(.horizontal)

                // Network stats
                HStack(spacing: 16) {
                    NetworkStatCard(value: "247", label: "Connections", icon: "person.2.fill", color: .blue)
                    NetworkStatCard(value: "12", label: "Communities", icon: "person.3.fill", color: .purple)
                    NetworkStatCard(value: "4.2", label: "Avg Degree", icon: "arrow.triangle.branch", color: .green)
                }
                .padding(.horizontal)

                // Network insights
                VStack(alignment: .leading, spacing: 12) {
                    Text("Network Insights")
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("Your Amber network visualizes all your connections and how they relate to each other, revealing hidden communities and bridges.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Geography Network View
struct GeographyNetworkView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Find My Friends visualization canvas
                FindMyFriendsCanvas()
                    .frame(height: 500)
                    .padding(.horizontal)

                // Geography connections info
                VStack(alignment: .leading, spacing: 12) {
                    Text("Geographic Connections")
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("Your geographic network maps where your friends and connections are located, helping you plan meetups and stay connected across distances.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Network Stat Card
struct NetworkStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Canvas Views (Placeholders with better styling)
struct FamilyTreeCanvas: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.regularMaterial)

            Canvas { context, size in
                // Draw a beautiful family tree structure
                let centerX = size.width / 2
                let topY = size.height * 0.15
                let midY = size.height * 0.45
                let bottomY = size.height * 0.75

                // Draw connecting lines
                let linePath = Path { path in
                    // Grandparents to parents
                    path.move(to: CGPoint(x: centerX - 80, y: topY + 20))
                    path.addLine(to: CGPoint(x: centerX - 80, y: midY - 20))

                    path.move(to: CGPoint(x: centerX + 80, y: topY + 20))
                    path.addLine(to: CGPoint(x: centerX + 80, y: midY - 20))

                    // Parents to you
                    path.move(to: CGPoint(x: centerX - 80, y: midY + 20))
                    path.addLine(to: CGPoint(x: centerX, y: bottomY - 20))

                    path.move(to: CGPoint(x: centerX + 80, y: midY + 20))
                    path.addLine(to: CGPoint(x: centerX, y: bottomY - 20))
                }

                context.stroke(linePath, with: .color(.secondary.opacity(0.3)), lineWidth: 2)

                // Draw nodes (circles)
                let nodes: [(CGPoint, Color)] = [
                    // Grandparents
                    (CGPoint(x: centerX - 80, y: topY), .blue),
                    (CGPoint(x: centerX + 80, y: topY), .purple),
                    // Parents
                    (CGPoint(x: centerX - 80, y: midY), .green),
                    (CGPoint(x: centerX + 80, y: midY), .orange),
                    // You
                    (CGPoint(x: centerX, y: bottomY), .pink)
                ]

                for (point, color) in nodes {
                    let circle = Circle()
                        .path(in: CGRect(x: point.x - 20, y: point.y - 20, width: 40, height: 40))
                    context.fill(circle, with: .color(color.opacity(0.7)))
                    context.stroke(circle, with: .color(.white), lineWidth: 2)
                }
            }

            VStack {
                Spacer()
                Text("🌳 Family Tree Visualization")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct NetworkGraphCanvas: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.regularMaterial)

            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius: CGFloat = 120

                // Draw central node (you)
                let centralCircle = Circle()
                    .path(in: CGRect(x: center.x - 25, y: center.y - 25, width: 50, height: 50))
                context.fill(centralCircle, with: .color(Color.amberBlue))
                context.stroke(centralCircle, with: .color(.white), lineWidth: 3)

                // Draw surrounding nodes in circle
                let nodeCount = 8
                for i in 0..<nodeCount {
                    let angle = (CGFloat(i) / CGFloat(nodeCount)) * 2 * .pi - .pi / 2
                    let x = center.x + cos(angle) * radius
                    let y = center.y + sin(angle) * radius

                    // Draw connecting line
                    var linePath = Path()
                    linePath.move(to: center)
                    linePath.addLine(to: CGPoint(x: x, y: y))
                    context.stroke(linePath, with: .color(.secondary.opacity(0.2)), lineWidth: 1.5)

                    // Draw node
                    let nodeCircle = Circle()
                        .path(in: CGRect(x: x - 15, y: y - 15, width: 30, height: 30))
                    let colors: [Color] = [.blue, .green, .purple, .orange, .pink, .red, .yellow, .cyan]
                    context.fill(nodeCircle, with: .color(colors[i].opacity(0.7)))
                    context.stroke(nodeCircle, with: .color(.white), lineWidth: 2)
                }
            }

            VStack {
                Spacer()
                Text("🕸️ Network Graph Visualization")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
        }
        .rotation3DEffect(
            .degrees(animate ? 2 : -2),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

struct FindMyFriendsCanvas: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.regularMaterial)

            Canvas { context, size in
                let centerX = size.width / 2
                let centerY = size.height / 2

                // Draw map-like grid lines
                let gridColor = Color.secondary.opacity(0.1)
                for i in stride(from: 0, through: size.width, by: 40) {
                    var path = Path()
                    path.move(to: CGPoint(x: i, y: 0))
                    path.addLine(to: CGPoint(x: i, y: size.height))
                    context.stroke(path, with: .color(gridColor), lineWidth: 0.5)
                }
                for i in stride(from: 0, through: size.height, by: 40) {
                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: i))
                    path.addLine(to: CGPoint(x: size.width, y: i))
                    context.stroke(path, with: .color(gridColor), lineWidth: 0.5)
                }

                // Draw connection lines between pins
                let pins: [(CGFloat, CGFloat, Color, CGFloat)] = [
                    (0.25, 0.25, .red, 14),
                    (0.65, 0.20, .blue, 12),
                    (0.50, 0.50, .amberBlue, 18),    // "You" — central
                    (0.75, 0.45, .green, 10),
                    (0.30, 0.65, .orange, 12),
                    (0.70, 0.70, .purple, 10),
                    (0.15, 0.45, .pink, 10),
                    (0.55, 0.80, .cyan, 8),
                    (0.85, 0.30, .yellow, 8),
                    (0.40, 0.35, .mint, 10),
                    (0.20, 0.80, .indigo, 8),
                    (0.80, 0.60, .teal, 10)
                ]

                // Draw dashed connection lines from center "You" to others
                let youX = size.width * 0.50
                let youY = size.height * 0.50
                for (xR, yR, _, _) in pins {
                    let x = size.width * xR
                    let y = size.height * yR
                    if x == youX && y == youY { continue }

                    var linePath = Path()
                    linePath.move(to: CGPoint(x: youX, y: youY))
                    linePath.addLine(to: CGPoint(x: x, y: y))
                    context.stroke(
                        linePath,
                        with: .color(.secondary.opacity(0.15)),
                        style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                    )
                }

                // Draw pins
                for (xR, yR, color, radius) in pins {
                    let x = size.width * xR
                    let y = size.height * yR

                    // Glow
                    let glowCircle = Circle()
                        .path(in: CGRect(x: x - radius * 1.5, y: y - radius * 1.5, width: radius * 3, height: radius * 3))
                    context.fill(glowCircle, with: .color(color.opacity(0.15)))

                    // Pin
                    let pinCircle = Circle()
                        .path(in: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
                    context.fill(pinCircle, with: .color(color.opacity(0.8)))
                    context.stroke(pinCircle, with: .color(.white), lineWidth: 2)
                }
            }

            VStack {
                Spacer()
                Text("📍 Find My Friends Visualization")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Network Filter Sheet
struct NetworkFilterSheet: View {
    @Binding var enabledSources: Set<NetworkSource>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(NetworkSource.allCases) { source in
                        Toggle(isOn: Binding(
                            get: { enabledSources.contains(source) },
                            set: { isEnabled in
                                if isEnabled {
                                    enabledSources.insert(source)
                                } else {
                                    enabledSources.remove(source)
                                }
                            }
                        )) {
                            HStack(spacing: 12) {
                                Image(systemName: source.icon)
                                    .font(.system(size: 18))
                                    .foregroundColor(source.color)
                                    .frame(width: 28)

                                Text(source.rawValue)
                                    .font(.body)
                            }
                        }
                        .tint(.amberBlue)
                    }
                } header: {
                    Text("Data Sources")
                } footer: {
                    Text("Select which sources to include in your network visualization")
                }
            }
            .navigationTitle("Filter Network")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.amberBlue)
                }
            }
        }
    }
}

