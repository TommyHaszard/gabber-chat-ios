//
//  MessageRow.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 19/7/2025.
//

import SwiftUI

struct MessageRow: View {
    let message: Message
    
    var body: some View {
        HStack {
            if !message.isFromUser {
                Spacer(minLength: 60)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(18)
                
                    
                    HStack(spacing: 4) {
                        let date = Date(timeIntervalSince1970: TimeInterval(message.createdAt ?? 0) / 1000)
                        Text(date.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                        Text(message.content)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(18)
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(message.createdAt ?? 0) / 1000)
                    Text(date.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: 60)
            }
        }
        .padding(.vertical, 2)
    }
}
