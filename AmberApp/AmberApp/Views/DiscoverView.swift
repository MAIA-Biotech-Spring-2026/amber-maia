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
        ZStack(alignment: .bottom) {
            // Map view (Find My Friends style)
            GeographicMapView()
                .ignoresSafeArea(edges: .top)

            // Floating info card at bottom - positioned just above input bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "map.fill")
                        .foregroundColor(.blue)
                    Text("Find My Friends")
                        .font(.headline)
                    Spacer()

                    // Location stats inline
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                            Text("12")
                                .font(.caption)
                                .fontWeight(.medium)
                        }

                        HStack(spacing: 4) {
                            Image(systemName: "globe.americas.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text("5")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 20)
            .padding(.bottom, 16) // Lower position - just above input bar with small gap
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

struct GeographicMapView: View {
    var body: some View {
        ZStack {
            // Map background gradient (simplified) with fade at bottom
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.1),
                        Color.green.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Fade to background at bottom to prevent overlap with input bar
                LinearGradient(
                    colors: [
                        Color.green.opacity(0.1),
                        Color(UIColor.systemGroupedBackground)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 200)
            }

            // Simulated map pins
            Canvas { context, size in
                let pins: [(CGFloat, CGFloat, Color)] = [
                    (0.3, 0.3, .red),
                    (0.6, 0.4, .blue),
                    (0.5, 0.6, .purple),
                    (0.7, 0.3, .green),
                    (0.4, 0.7, .orange)
                ]

                for (xRatio, yRatio, color) in pins {
                    let x = size.width * xRatio
                    let y = size.height * yRatio

                    // Pin drop shadow
                    let shadowCircle = Circle()
                        .path(in: CGRect(x: x - 12, y: y - 12, width: 24, height: 24))
                    context.fill(shadowCircle, with: .color(.black.opacity(0.2)))

                    // Pin
                    let pinCircle = Circle()
                        .path(in: CGRect(x: x - 10, y: y - 10, width: 20, height: 20))
                    context.fill(pinCircle, with: .color(color))
                    context.stroke(pinCircle, with: .color(.white), lineWidth: 2)
                }
            }

            Text("🗺️ Geographic Map")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 100)
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

