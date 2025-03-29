//
//  ChatView.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 28/3/2025.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var presenter = ChatPresenter()

    @State private var messages: [ChatMessage] = []

    var body: some View {
        VStack {
            List(messages, id: \.id) { message in
                Text("\(message.sender): \(message.text)")
            }
            Button("Send Message") {
                self.presenter?.sendMessage("Hello!")
            }
        }
        .onAppear {
            self.presenter?.viewDidLoad()
        }
    }

    func displayMessages(_ messages: [ChatMessage]) {
        self.messages = messages
    }
}
