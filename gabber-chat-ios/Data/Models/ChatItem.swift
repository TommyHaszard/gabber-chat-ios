//
//  ChatItem.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 19/7/2025.
//


import SwiftUI

struct ChatItem {
    let messageId: UUID
    let userId: UUID
    let name: String
    let message: String
    let time: String
    let avatarColor: Color
    let avatarText: String
    let unreadCount: Int
    let isSystemAvatar: Bool
    let systemImage: String?
}
