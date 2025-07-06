//
//  LoadingScreenViewModel.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 1/7/2025.
//

import SwiftUI
import Combine

final class LoadingScreenViewModel: ObservableObject {
    @Published var state: LoadingState = .loading

    func loadData() {
        let chat1 = ChatMessage(id: UUID(), text: "Hello", isSentByCurrentUser: true, timestamp: Date(), sender: "Tommy");
        let chat2 = ChatMessage(id: UUID(), text: "Hey, who this?", isSentByCurrentUser: false, timestamp: Date(), sender: "Alex");
        let chat3 = ChatMessage(id: UUID(), text: "Hey its Tommy", isSentByCurrentUser: true, timestamp: Date(), sender: "Tommy");
        
        
        // Simulate API/BLE delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let loadedUsers = [
                User(id: UUID(), name: "Alice", lastMessage: chat1),
                User(id: UUID(), name: "Bob", lastMessage:chat2),
                User(id: UUID(), name: "Charlie", lastMessage: chat3)
            ]
            self.state = .success(loadedUsers)
        }
    }
}

enum LoadingState {
    case loading
    case success([User])
    case failure(Error)
}

