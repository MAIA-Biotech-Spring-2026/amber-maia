//
//  ConnectionsViewModel.swift
//  Amber
//
//  Created on 2026-01-17.
//

import Foundation
import Combine

@MainActor
class ConnectionsViewModel: ObservableObject {
    @Published var connections: [Connection] = []
    @Published var selectedConnection: Connection?

    init() {
        loadMockData()
    }

    var groupedConnections: [String: [Connection]] {
        Dictionary(grouping: connections.sorted { $0.name < $1.name }) { connection in
            String(connection.name.prefix(1)).uppercased()
        }
    }

    func filteredConnections(searchText: String) -> [String: [Connection]] {
        guard !searchText.isEmpty else { return groupedConnections }
        let filtered = connections.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        return Dictionary(grouping: filtered.sorted { $0.name < $1.name }) { connection in
            String(connection.name.prefix(1)).uppercased()
        }
    }

    func selectConnection(_ connection: Connection) {
        selectedConnection = connection
    }

    func loadConnections() async {
        // Simulate loading from Supabase
    }

    private func loadMockData() {
        let userId = UUID()
        connections = [
            Connection(
                id: UUID(),
                userId: userId,
                name: "Alex Thompson",
                phone: "+1234567890",
                email: "alex@example.com",
                linkedinURL: nil,
                avatarURL: nil,
                company: "Tech Innovations Inc",
                title: "Software Engineer",
                notes: nil,
                createdAt: Date(),
                lastInteraction: Date(),
                relationshipType: .colleague,
                howMet: "Conference",
                closenessScore: 7,
                spiritualImpact: 3,
                emotionalImpact: 5,
                physicalImpact: 2,
                intellectualImpact: 8,
                socialImpact: 6,
                financialImpact: 4
            ),
            Connection(
                id: UUID(),
                userId: userId,
                name: "Sarah Johnson",
                phone: "+1234567891",
                email: "sarah@example.com",
                linkedinURL: nil,
                avatarURL: nil,
                company: "Design Studio",
                title: "Creative Director",
                notes: nil,
                createdAt: Date(),
                lastInteraction: Date(),
                relationshipType: .friend,
                howMet: "College",
                closenessScore: 9,
                spiritualImpact: 7,
                emotionalImpact: 8,
                physicalImpact: 5,
                intellectualImpact: 6,
                socialImpact: 9,
                financialImpact: 3
            ),
            Connection(
                id: UUID(),
                userId: userId,
                name: "Michael Chen",
                phone: "+1234567892",
                email: "michael@example.com",
                linkedinURL: nil,
                avatarURL: nil,
                company: "Global Ventures",
                title: "Investment Analyst",
                notes: nil,
                createdAt: Date(),
                lastInteraction: Date(),
                relationshipType: .business,
                howMet: "Networking Event",
                closenessScore: 6,
                spiritualImpact: 2,
                emotionalImpact: 4,
                physicalImpact: 1,
                intellectualImpact: 7,
                socialImpact: 5,
                financialImpact: 9
            )
        ]
    }
}
