//
//  DiscoverViewModel.swift
//  Amber
//
//  Created on 2026-01-17.
//

import Foundation
import Combine

@MainActor
class DiscoverViewModel: ObservableObject {
    @Published var insights: [Insight] = []
    @Published var selectedInsight: Insight?

    init() {
        loadMockData()
    }

    func filteredInsights(for dimension: HealthDimension?) -> [Insight] {
        guard let dimension = dimension else { return insights }
        return insights.filter { $0.healthDimension == dimension }
    }

    func selectInsight(_ insight: Insight) {
        selectedInsight = insight
    }

    func loadInsights() async {
        // Simulate loading from Supabase
    }

    private func loadMockData() {
        insights = [
            Insight(
                id: UUID(),
                userId: UUID(),
                type: .recommendation,
                healthDimension: .emotional,
                title: "Strengthen Your Bond with Sarah",
                body: "You haven't connected with Sarah in 3 weeks. Research shows maintaining regular contact improves emotional well-being by 34%.",
                imageURL: nil,
                actionURL: nil,
                priority: 8,
                createdAt: Date(),
                readAt: nil,
                dismissedAt: nil,
                connectionId: UUID(),
                connectionName: "Sarah Johnson"
            ),
            Insight(
                id: UUID(),
                userId: UUID(),
                type: .article,
                healthDimension: .intellectual,
                title: "The Science of Deep Conversations",
                body: "New research reveals how meaningful dialogue strengthens neural pathways and enhances cognitive function.",
                imageURL: nil,
                actionURL: nil,
                priority: 6,
                createdAt: Date(),
                readAt: nil,
                dismissedAt: nil,
                connectionId: nil,
                connectionName: nil
            ),
            Insight(
                id: UUID(),
                userId: UUID(),
                type: .milestone,
                healthDimension: .social,
                title: "Connection Streak: 30 Days!",
                body: "You've maintained consistent contact with your top 5 connections for an entire month. Keep it up!",
                imageURL: nil,
                actionURL: nil,
                priority: 7,
                createdAt: Date(),
                readAt: nil,
                dismissedAt: nil,
                connectionId: nil,
                connectionName: nil
            ),
            Insight(
                id: UUID(),
                userId: UUID(),
                type: .healthUpdate,
                healthDimension: .spiritual,
                title: "Your Spiritual Score Increased",
                body: "Regular reflection and meaningful conversations have boosted your spiritual health by 12 points this month.",
                imageURL: nil,
                actionURL: nil,
                priority: 5,
                createdAt: Date(),
                readAt: nil,
                dismissedAt: nil,
                connectionId: nil,
                connectionName: nil
            ),
            Insight(
                id: UUID(),
                userId: UUID(),
                type: .recommendation,
                healthDimension: .financial,
                title: "Network Opportunity",
                body: "Michael Chen in your network works at the company you're interested in. Consider reaching out for an informational interview.",
                imageURL: nil,
                actionURL: nil,
                priority: 9,
                createdAt: Date(),
                readAt: nil,
                dismissedAt: nil,
                connectionId: UUID(),
                connectionName: "Michael Chen"
            )
        ]
    }
}
