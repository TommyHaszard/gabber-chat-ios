//
//  ChatRow.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 19/7/2025.
//
import SwiftUI

struct ChatRow: View {
    let item: ChatItem
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(item.avatarColor)
                    .frame(width: 50, height: 50)
                
                if item.isSystemAvatar {
                    Text(item.avatarText)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                } else {
                    Text(item.avatarText)
                        .font(.title2)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(item.name)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if !item.time.isEmpty {
                        Text(item.time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Text(item.message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    if item.unreadCount > 0 {
                        Circle()
                            .fill(.purple)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text("\(item.unreadCount)")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .contentShape(Rectangle())
    }
}
