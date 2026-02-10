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
    @Published var messages: [ChatMessage] = []
    @Published var isTyping = false

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

    func loadMessages() async {
        // Load initial welcome message
        messages = [
            ChatMessage(
                content: "Hi! I'm Amber, your personal relationship intelligence assistant. I can help you understand your social network, strengthen connections, and gain insights about your relationships. What would you like to know?",
                isFromUser: false,
                timestamp: Date()
            )
        ]
    }

    func sendMessage(_ text: String) async {
        // Add user message
        let userMessage = ChatMessage(
            content: text,
            isFromUser: true,
            timestamp: Date()
        )
        messages.append(userMessage)

        // Show typing indicator
        isTyping = true

        // Simulate AI response delay
        try? await Task.sleep(nanoseconds: 1_500_000_000)

        isTyping = false

        // Generate response based on user input
        let response = generateResponse(for: text)
        let aiMessage = ChatMessage(
            content: response,
            isFromUser: false,
            timestamp: Date()
        )
        messages.append(aiMessage)
    }

    private func generateResponse(for query: String) -> String {
        let lowercaseQuery = query.lowercased()

        if lowercaseQuery.contains("relationship") || lowercaseQuery.contains("connection") {
            return "Based on your data, you have 47 active connections. Your strongest relationships are with Sarah, Michael, and Emma. You've been particularly active with your professional network this month, with a 23% increase in meaningful interactions."
        } else if lowercaseQuery.contains("health") || lowercaseQuery.contains("wellbeing") {
            return "Your overall relationship health score is 82/100. Your emotional and social dimensions are performing well at 85 and 88 respectively. I notice you could benefit from strengthening your spiritual connections - consider scheduling deeper conversations with close friends."
        } else if lowercaseQuery.contains("pattern") || lowercaseQuery.contains("insight") {
            return "I've noticed an interesting pattern: you tend to reach out to people most on Tuesday and Wednesday mornings. Your response rate is highest for voice calls compared to text messages. You also have a 'core 5' group that you interact with weekly."
        } else if lowercaseQuery.contains("improve") || lowercaseQuery.contains("help") {
            return "Here are three personalized recommendations: 1) Reconnect with James - you haven't spoken in 3 weeks. 2) Your communication with family has decreased by 15% this month. 3) Consider joining the book club that Sarah mentioned - it aligns with your intellectual interests."
        } else {
            return "That's a great question! Based on your relationship data and patterns, I can provide insights about your social network, health scores, communication patterns, and personalized recommendations. What specific aspect would you like to explore?"
        }
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
