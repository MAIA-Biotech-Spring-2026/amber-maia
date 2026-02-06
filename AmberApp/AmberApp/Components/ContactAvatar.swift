//
//  ContactAvatar.swift
//  Amber
//
//  Created on 2026-01-17.
//

import SwiftUI

struct ContactAvatar: View {
    let name: String
    let imageURL: String?
    let size: CGFloat

    var body: some View {
        if let url = imageURL, let imageUrl = URL(string: url) {
            AsyncImage(url: imageUrl) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                InitialsAvatar(name: name, size: size)
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
        } else {
            InitialsAvatar(name: name, size: size)
        }
    }
}

struct InitialsAvatar: View {
    let name: String
    let size: CGFloat

    private var initials: String {
        let components = name.components(separatedBy: " ")
        let first = components.first?.prefix(1) ?? ""
        let last = components.count > 1 ? components.last?.prefix(1) ?? "" : ""
        return "\(first)\(last)".uppercased()
    }

    private var backgroundColor: Color {
        let colors: [Color] = [.amberBlue, .healthSpiritual, .healthEmotional,
                               .healthPhysical, .healthIntellectual, .healthFinancial]
        let index = abs(name.hashValue) % colors.count
        return colors[index]
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
            Text(initials)
                .font(.system(size: size * 0.4, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(width: size, height: size)
    }
}
