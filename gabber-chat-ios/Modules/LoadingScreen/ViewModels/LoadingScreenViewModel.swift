//
//  LoadingScreenViewModel.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 1/7/2025.
//

import SwiftUI
import Combine

class LoadingScreenViewModel: ObservableObject {
    @Published var state: LoadingState = .loading

    func loadData(with: AppDependencies) {
        let user1 = UUID().uuidString.data(using: String.Encoding.utf8)!;
        let user2 = UUID().uuidString.data(using: String.Encoding.utf8)!;
        let chat1 = Message(messageId: UUID().uuidString.data(using: String.Encoding.utf8)!, userId: user1 ,content: "Hello", createdAt: nil, isFromUser: true);
        
        let chat2 = Message(messageId: UUID().uuidString.data(using: String.Encoding.utf8)!, userId: user2 ,content: "Hey, who this?", createdAt: nil, isFromUser: false);
        
        let chat3 = Message(messageId: UUID().uuidString.data(using: String.Encoding.utf8)!, userId: user1 ,content:
            "Hey its Tommy", createdAt: nil, isFromUser: true);
        
        //let user = dependencies.rustLib.loadCurrentUser()
        
        // Simulate API/BLE delay
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            let loadedUsers = [
                User(userId: user1, username: "Alice", userType: UserType.friend),
                User(userId: user2, username: "Tommy", userType: UserType.current),
            ]
            self.state = .success(loadedUsers)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: workItem)
    }
}

enum LoadingState {
    case loading
    case success([User])
    case failure(Error)
}

