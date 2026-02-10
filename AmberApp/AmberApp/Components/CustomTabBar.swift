//
//  CustomTabBar.swift
//  Amber
//
//  Created on 2026-01-18.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var searchText: String
    @State private var pressedTab: Int? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Search bar extension - only shows when on Connections tab (now tab 0)
            if selectedTab == 0 {
                LiquidGlassSearchBar(searchText: $searchText)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            }

            // Main tab bar island
            HStack(spacing: 0) {
                // Connections (LEFT)
                Button {
                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                        selectedTab = 0
                        pressedTab = nil
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 22, weight: selectedTab == 0 ? .semibold : .regular))
                            .foregroundColor(selectedTab == 0 ? .amberBlue : .primary.opacity(0.6))
                            .scaleEffect(pressedTab == 0 ? 0.85 : 1.0)

                        Text("Connections")
                            .font(.system(size: 10, weight: selectedTab == 0 ? .semibold : .regular))
                            .foregroundColor(selectedTab == 0 ? .amberBlue : .primary.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedTab == 0 ? Color.amberBlue.opacity(0.15) : Color.clear)
                            .scaleEffect(pressedTab == 0 ? 0.95 : 1.0)
                    )
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation(.easeOut(duration: 0.1)) {
                                pressedTab = 0
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                                pressedTab = nil
                            }
                        }
                )

                // Discover (CENTER)
                Button {
                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                        selectedTab = 1
                        pressedTab = nil
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == 1 ? "sparkles" : "sparkles")
                            .font(.system(size: 22, weight: selectedTab == 1 ? .semibold : .regular))
                            .foregroundColor(selectedTab == 1 ? .amberBlue : .primary.opacity(0.6))
                            .scaleEffect(pressedTab == 1 ? 0.85 : 1.0)

                        Text("Discover")
                            .font(.system(size: 10, weight: selectedTab == 1 ? .semibold : .regular))
                            .foregroundColor(selectedTab == 1 ? .amberBlue : .primary.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedTab == 1 ? Color.amberBlue.opacity(0.15) : Color.clear)
                            .scaleEffect(pressedTab == 1 ? 0.95 : 1.0)
                    )
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation(.easeOut(duration: 0.1)) {
                                pressedTab = 1
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                                pressedTab = nil
                            }
                        }
                )

                // Profile (RIGHT)
                Button {
                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                        selectedTab = 2
                        pressedTab = nil
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 22, weight: selectedTab == 2 ? .semibold : .regular))
                            .foregroundColor(selectedTab == 2 ? .amberBlue : .primary.opacity(0.6))
                            .scaleEffect(pressedTab == 2 ? 0.85 : 1.0)

                        Text("Profile")
                            .font(.system(size: 10, weight: selectedTab == 2 ? .semibold : .regular))
                            .foregroundColor(selectedTab == 2 ? .amberBlue : .primary.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedTab == 2 ? Color.amberBlue.opacity(0.15) : Color.clear)
                            .scaleEffect(pressedTab == 2 ? 0.95 : 1.0)
                    )
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation(.easeOut(duration: 0.1)) {
                                pressedTab = 2
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                                pressedTab = nil
                            }
                        }
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 30)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 4)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .scaleEffect(pressedTab != nil ? 0.98 : 1.0)
        }
        .animation(.interpolatingSpring(stiffness: 300, damping: 20), value: selectedTab)
        .animation(.interpolatingSpring(stiffness: 300, damping: 20), value: pressedTab)
    }
}
