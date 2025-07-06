//
//  LoadingEntity.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 1/7/2025.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let name: String
    let lastMessage: ChatMessage?
}
