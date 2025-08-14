//
//  BackendService.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 1/7/2025.
//
import Foundation
import SwiftUICore


class RustLibMocked: ObservableObject, RustLib {
    func initDatabase() -> Result<(), DatabaseError> {
        .success(())
    }
    
    func loadUser(userId: UUID) -> Result<User, DatabaseError> {
        return .success(User(userId: Data(), username: "MockedUser", userType: UserType.friend))
    }
    
    func loadMessagesForUser(userId: Data) -> Result<[Message], DatabaseError> {
        var messages = [Message]()
        messages.append(Message(messageId: UUID().uuidString.data(using: .utf8)!, userId: userId, content: "How about the cafe near your place tomorrow at 11:30am?", createdAt: 32423423, isFromUser: true))
        messages.append(Message(messageId: UUID().uuidString.data(using: .utf8)!, userId: userId, content: "Yep that works for me.", createdAt: 32423423, isFromUser: false))
        messages.append(Message(messageId: UUID().uuidString.data(using: .utf8)!, userId: userId, content: "See you then!", createdAt: 32423425, isFromUser: true))
        return .success(messages)
    }
    
    func sendMessage(userId: Data, message: Message) -> Result<(), DatabaseError> {
        return .success(())
    }
    
    func getCurrentUser() -> User? {
        return User(userId: Data(), username: "bob", userType: UserType.friend)
    }
    
    func loadCurrentUser() -> Result<User, DatabaseError> {
        let user = User(userId: Data(), username: "bob", userType: UserType.friend)
        return .success(user)
    }
    
    var currentUser: User?


    func loadCurrentUser() -> User? {
        return User(userId: Data(), username: "bob", userType: UserType.friend)
    }
    
    func getCurrentUser() -> User {
        if let value = currentUser {
            return value
        } else {
            return User(userId: Data(), username: "bob", userType: UserType.friend)
        }
            
    }
    
    func loadRecentUsersAndMessages() -> Result<[User : Message], DatabaseError> {
        let userId = UUID().uuidString.data(using: .utf8)!
        let user = User(userId: userId, username: "Mocked", userType: UserType.friend)
        let message = Message(messageId: UUID().uuidString.data(using: .utf8)!, userId: userId, content: "How about the cafe near your place tomorrow at 11:30am?", createdAt: 32423423, isFromUser: true)
        var map = [User : Message]()
        map.updateValue(message, forKey: user)
        return .success(map)
    }
    
}
