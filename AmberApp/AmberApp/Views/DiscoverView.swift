//
//  DiscoverView.swift
//  Amber
//
//  Created on 2026-01-17.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @State private var selectedCategory: HealthDimension? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Category tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryButton(
                                title: "For You",
                                isSelected: selectedCategory == nil,
                                action: { selectedCategory = nil }
                            )

                            ForEach(HealthDimension.allCases, id: \.self) { dimension in
                                CategoryButton(
                                    title: dimension.rawValue.capitalized,
                                    isSelected: selectedCategory == dimension,
                                    action: { selectedCategory = dimension }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Insight cards
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredInsights(for: selectedCategory)) { insight in
                            InsightCardView(insight: insight)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Settings action
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Filter action
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
        .task {
            await viewModel.loadInsights()
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? Color.primary : Color.secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? .thinMaterial : .ultraThinMaterial)
                .clipShape(Capsule())
        }
    }
}

struct InsightCardView: View {
    let insight: Insight

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let dimension = insight.healthDimension {
                HealthBadge(dimension: dimension)
            }

            Text(insight.title)
                .font(.headline)

            Text(insight.body)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
