//
//  UserContentViewModel.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 20/7/2025.
//

import SwiftUI
import Combine

class UserContentViewModel: ObservableObject {
    @MainActor func getChatItems(with dependencies: AppDependencies) -> [ChatItem] {
        switch dependencies.rustLib.loadRecentUsersAndMessages() {
        case .success(let sqlData):
            for data in sqlData {
                let uuid = data.key.userId.withUnsafeBytes{ (pointer: UnsafeRawBufferPointer) -> UUID in
                    let rawPointer = pointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    return NSUUID(uuidBytes: rawPointer) as UUID
                    
                }
            }
            let chatItems: [ChatItem] = sqlData.map { (key: User, value: Message) in
                let userId = key.userId.withUnsafeBytes{ (pointer: UnsafeRawBufferPointer) -> UUID in
                    let rawPointer = pointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    return NSUUID(uuidBytes: rawPointer) as UUID
                    
                }
                let messageId = value.messageId.withUnsafeBytes{ (pointer: UnsafeRawBufferPointer) -> UUID in
                    let rawPointer = pointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    return NSUUID(uuidBytes: rawPointer) as UUID
                    
                }
                return ChatItem(messageId: messageId, userId: userId, name: key.username, message: value.content, time: "now", avatarColor: Color.purple, avatarText: "", unreadCount: 0, isSystemAvatar: true, systemImage: nil)
            }
            return chatItems
        
        case .failure( _):
            return []
        }
    }
}
