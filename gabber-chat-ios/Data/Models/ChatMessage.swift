//
//  ChatMessage.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 28/3/2025.
//

import Foundation

struct ChatMessage: Codable, Identifiable {
    let id: UUID
    let text: String
    let isSentByCurrentUser: Bool
    let timestamp: Date
    let sender: String
}
