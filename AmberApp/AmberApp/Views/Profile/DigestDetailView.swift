//
//  DigestDetailView.swift
//  AmberApp
//

import SwiftUI

struct DigestDetailView: View {
    let digest: DailyDigest
    @StateObject private var viewModel = DigestChatViewModel()
    @State private var messageText = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: digest.icon)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(digest.color.gradient)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 4) {
                            Text(digest.title)
                                .font(.title3)
                                .fontWeight(.bold)

                            Text(digest.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(digest.score)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(digest.color)
                            Text("/100")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Text(digest.detailedInsight)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
                .padding(20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                .padding(.top, 16)

                // Chat interface
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.messages) { message in
                                DigestChatBubble(message: message, themeColor: digest.color)
                                    .id(message.id)
                            }

                            if viewModel.isTyping {
                                DigestTypingIndicator(themeColor: digest.color)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                    .onChange(of: viewModel.messages.count) { oldValue, newValue in
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // Input bar
                DigestChatInputBar(
                    text: $messageText,
                    isFocused: $isInputFocused,
                    themeColor: digest.color,
                    onSend: {
                        sendMessage()
                    }
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .navigationTitle(digest.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadInitialMessage(for: digest)
        }
    }

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let message = messageText
        messageText = ""
        isInputFocused = false

        Task {
            await viewModel.sendMessage(message, digest: digest)
        }
    }
}
