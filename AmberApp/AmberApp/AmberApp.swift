//
//  AmberApp.swift
//  AmberApp
//
//  Created on 2026-01-17.
//

import SwiftUI

@main
struct AmberApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = 1 // Start on Discover (center)
    @State private var searchText = ""

    var body: some View {
        ZStack {
            // Content views
            Group {
                if selectedTab == 0 {
                    ConnectionsView(searchText: $searchText)
                } else if selectedTab == 1 {
                    DiscoverView()
                } else {
                    AmberIDView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom tab bar at bottom
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab, searchText: $searchText)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}
