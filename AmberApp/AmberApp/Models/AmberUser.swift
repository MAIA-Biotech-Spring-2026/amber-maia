//
//  AmberUser.swift
//  Amber
//
//  Created on 2026-01-17.
//

import Foundation

struct AmberUser: Codable, Identifiable {
    let id: UUID
    var phone: String
    var email: String?
    var name: String
    var avatarURL: String?
    var createdAt: Date

    // Personality Profile
    var primaryNature: PrimaryNature?
    var socialType: SocialType?
    var influencedBy: InfluencedBy?
    var thinkingStyle: ThinkingStyle?
    var interactionStyle: InteractionStyle?
    var communicationStyle: CommunicationStyle?

    // Health Scores (0-100)
    var spiritualScore: Int
    var emotionalScore: Int
    var physicalScore: Int
    var intellectualScore: Int
    var socialScore: Int
    var financialScore: Int
}

extension AmberUser {
    static let placeholder = AmberUser(
        id: UUID(),
        phone: "+1234567890",
        email: "sagar@example.com",
        name: "Sagar Tiwari",
        avatarURL: nil,
        createdAt: Date(),
        primaryNature: .tranquility,
        socialType: .extrovert,
        influencedBy: .feelings,
        thinkingStyle: .abstract,
        interactionStyle: .dominant,
        communicationStyle: .expressive,
        spiritualScore: 75,
        emotionalScore: 82,
        physicalScore: 68,
        intellectualScore: 90,
        socialScore: 85,
        financialScore: 72
    )
}
