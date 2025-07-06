//
//  MessageRow.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 14/6/2025.
//
import SwiftUI

struct MessageRowView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isSentByCurrentUser {
                Spacer()
            }
            VStack(alignment: message.isSentByCurrentUser ? .trailing : .leading, spacing: 1) {
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .foregroundColor(message.isSentByCurrentUser ? .black : .white)
                    .background(message.isSentByCurrentUser ? Color(red: 0.8, green: 0.7, blue: 0.95) : Color(red: 47/255, green: 47/255, blue: 47/255))
                    .clipShape(MessageBubble(isFromCurrentUser: message.isSentByCurrentUser))
//                    .frame(maxWidth: UIScreen.main.bounds.width * 0.85, alignment: message.isSentByCurrentUser ? .trailing : .leading)

                Text(message.timestamp.formatted())
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
//                    .frame(maxWidth: UIScreen.main.bounds.width * 0.85, alignment: message.isSentByCurrentUser ? .trailing : .leading)

            }
            if !message.isSentByCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2) // tighter spacing between bubbles

    }
}

struct MessageBubble: Shape {
    var isFromCurrentUser: Bool

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [
                .topLeft,
                .topRight,
                isFromCurrentUser ? .bottomLeft : .bottomRight
            ],
            cornerRadii: CGSize(width: 18, height: 18)
        )

        if isFromCurrentUser {
            let tail = UIBezierPath()
            let startPoint = CGPoint(x: rect.maxX - 15, y: rect.maxY)
            tail.move(to: startPoint)
            tail.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY + 2), controlPoint: CGPoint(x: rect.maxX - 5, y: rect.maxY))
            tail.addQuadCurve(to: CGPoint(x: rect.maxX - 2, y: rect.maxY + 15), controlPoint: CGPoint(x: rect.maxX, y: rect.maxY + 5))
            path.append(tail)
        } else {
            let tail = UIBezierPath()
            let startPoint = CGPoint(x: rect.minX + 15, y: rect.maxY)
            tail.move(to: startPoint)
            tail.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - 2), controlPoint: CGPoint(x: rect.minX + 5, y: rect.maxY))
            tail.addQuadCurve(to: CGPoint(x: rect.minX + 2, y: rect.maxY - 15), controlPoint: CGPoint(x: rect.minX, y: rect.maxY - 5))
            path.append(tail)
        }
        
        return Path(path.cgPath)
    }
}

