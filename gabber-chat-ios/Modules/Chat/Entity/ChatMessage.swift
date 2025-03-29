//
//  ChatMessage.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 28/3/2025.
//

import Foundation

struct ChatMessage {
    let id: UUID
    let text: String
    let timestamp: Date
    let sender: String
}
