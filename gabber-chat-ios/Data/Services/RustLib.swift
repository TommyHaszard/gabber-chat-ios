//
//  BackendService.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 1/7/2025.
//

import Foundation

protocol RustLib {
    func initDatabase() -> Result<(), DatabaseError>;
    func getCurrentUser() -> User?;
    func loadCurrentUser() -> Result<User, DatabaseError>;
    func loadRecentUsersAndMessages() -> Result<[User : Message], DatabaseError>;
    func loadUser(userId: UUID) -> Result<User, DatabaseError>;
    func loadMessagesForUser(userId: Data) -> Result<[Message], DatabaseError>;
    func sendMessage(userId: Data, message: Message) -> Result<(), DatabaseError>;
}
