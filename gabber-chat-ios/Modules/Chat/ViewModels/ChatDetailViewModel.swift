//
//  LoadingScreenViewModel.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 1/7/2025.
//

import SwiftUI
import Combine

class ChatDetailViewModel: ObservableObject {
    @MainActor func loadUser(userId: UUID, with: AppDependencies) -> User? {
        let result = with.rustLib.loadUser(userId: userId)
        switch result {
        case .success(let user):
            return user
        case .failure(let error):
            print(error.localizedDescription)
            return nil
        }
    }
    
    @MainActor func loadMessages(userId: UUID, with: AppDependencies) -> [Message] {
        var uuidBytes = userId.uuid
        let userIdData = Data(bytes: &uuidBytes, count: MemoryLayout.size(ofValue: uuidBytes))
        let result = with.rustLib.loadMessagesForUser(userId: userIdData)
        switch result {
        case .success(let messages):
            return messages
        case .failure(let error):
            print(error.localizedDescription)
            return [Message]()
        }
    }
    
    @MainActor func sendMessage(userId: Data, message: Message, with: AppDependencies) -> Result<(), DatabaseError> {
        with.rustLib.sendMessage(userId: userId, message: message)
    }
        
}

