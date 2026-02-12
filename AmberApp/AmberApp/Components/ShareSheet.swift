//
//  ShareSheet.swift
//  AmberApp
//

import SwiftUI

// MARK: - Custom Share Sheet (half-screen modal)
struct ShareSheet: View {
    let userName: String
    @Environment(\.dismiss) private var dismiss

    // Mock contacts for the people row
    private let shareContacts: [(String, String?, Color)] = [
        ("Sagar's\nMacBook Pro", "laptopcomputer", .gray),
        ("Sindhu\nTiwari", nil, .purple),
        ("Andi\nGuite", nil, .blue),
        ("Karthik\nD.", nil, .orange),
        ("Mom", nil, .pink),
        ("Dad", nil, .green),
    ]

    // Share apps row
    private let shareApps: [(String, String, Color)] = [
        ("AirDrop", "antenna.radiowaves.left.and.right", .gray),
        ("Messages", "message.fill", .green),
        ("Notes", "note.text", .gray),
        ("Instagram", "camera.fill", .purple),
        ("WhatsApp", "phone.fill", .green),
        ("Mail", "envelope.fill", .blue),
    ]

    // Action row
    private let shareActions: [(String, String, Color)] = [
        ("Copy", "doc.on.doc", .gray),
        ("Add to\nReadlist", "bookmark", .gray),
        ("Save to\nFiles", "folder", .gray),
        ("Print", "printer", .gray),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Drag handle
            Capsule()
                .fill(Color.secondary.opacity(0.4))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 12)

            // Header — thumbnail + title + close
            HStack(spacing: 12) {
                // Profile thumbnail
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.amberBlue.opacity(0.15))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.amberBlue)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(userName)'s Amber Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    Text("amber.app")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            Divider()
                .padding(.horizontal, 16)

            // People / Devices row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(shareContacts.enumerated()), id: \.offset) { _, contact in
                        ShareContactItem(
                            name: contact.0,
                            systemIcon: contact.1,
                            color: contact.2
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }

            Divider()
                .padding(.horizontal, 16)

            // Apps row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(shareApps.enumerated()), id: \.offset) { _, app in
                        ShareAppItem(
                            name: app.0,
                            icon: app.1,
                            color: app.2
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }

            Divider()
                .padding(.horizontal, 16)

            // Action row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(shareActions.enumerated()), id: \.offset) { _, action in
                        ShareActionItem(
                            name: action.0,
                            icon: action.1,
                            color: action.2
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }

            Spacer()
        }
        .background(Color(UIColor.systemBackground))
    }
}

// MARK: - Share Contact Item (circular avatar + name)
private struct ShareContactItem: View {
    let name: String
    let systemIcon: String?
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)

                if let icon = systemIcon {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                } else {
                    // Initials avatar
                    Text(initials(from: name))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(color)
                }

                // Device badge (for AirDrop targets)
                if systemIcon != nil {
                    Circle()
                        .fill(Color(UIColor.systemBackground))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        )
                        .offset(x: 20, y: 20)
                }
            }

            Text(name)
                .font(.system(size: 10))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 64)
        }
    }

    private func initials(from name: String) -> String {
        let parts = name.replacingOccurrences(of: "\n", with: " ").split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }
}

// MARK: - Share App Item (rounded square icon + name)
private struct ShareAppItem: View {
    let name: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(color.opacity(0.12))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color == .gray ? .secondary : color)
                )

            Text(name)
                .font(.system(size: 10))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .frame(width: 64)
        }
    }
}

// MARK: - Share Action Item (rounded square icon + name)
private struct ShareActionItem: View {
    let name: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(.secondary)
                )

            Text(name)
                .font(.system(size: 10))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 64)
        }
    }
}
