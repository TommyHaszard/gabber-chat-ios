//
//  BackendService.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 1/7/2025.
//

import Foundation
import UIKit

class RustLibImpl: ObservableObject, RustLib {
    func initDatabase() -> Result<(), DatabaseError> {
        do {
            let result: () = try gabber_chat_ios.initDatabase(path: "/Users/tommy/Documents/gabber-chat/gabber-chat-rust-lib/tests/test_db_dir/latest_message_for_user_test_1754666288672006000.db")
            return .success(())
        } catch {
            print(error)
            print(error.localizedDescription)
            return .failure(DatabaseError.InitializationError(error.localizedDescription))
        }
    }
    
    
    func loadUser(userId: UUID) -> Result<User, DatabaseError> {
        do {
            print(userId)
            var uuidBytes = userId.uuid
            let userIdData = Data(bytes: &uuidBytes, count: MemoryLayout.size(ofValue: uuidBytes))
            let user: User = try gabber_chat_ios.loadUser(userId: userIdData)
            print(userId)
            return .success(user)
        } catch {
            print(error)
            print(error.localizedDescription)
            return .failure(DatabaseError.InitializationError(error.localizedDescription))
        }
    }
    
    func loadMessagesForUser(userId: Data) -> Result<[Message], DatabaseError> {
        do {
            let messages: [Message] = try gabber_chat_ios.loadMessagesByUserId(userId: userId)
            return .success(messages)
        } catch {
            print(error)
            print(error.localizedDescription)
            return .failure(DatabaseError.InitializationError(error.localizedDescription))
        }
    }
    
    func sendMessage(userId: Data, message: Message) -> Result<(), DatabaseError> {
        do {
            let result: () = try gabber_chat_ios.sendMessage(userId: userId, message: message)
            return .success(())
        } catch {
            print(error)
            print(error.localizedDescription)
            return .failure(DatabaseError.InitializationError(error.localizedDescription))
        }
    }
    
    var currentUser: User?
    
    var deviceId: Data {
        guard let uuid = UIDevice.current.identifierForVendor?.uuid else {
            return Data()
        }
        return withUnsafeBytes(of: uuid) { Data($0) }
    }

    func getCurrentUser() -> User? {
        if let value = currentUser {
            return value
        } else {
            switch loadCurrentUser() {
            case .success(let user):
                return user

            case .failure(let _):
                return nil
            }
        }
    }
    
    func loadCurrentUser() -> Result<User, DatabaseError> {
        do {
            let user = try gabber_chat_ios.loadCurrentUser(deviceId: deviceId)
            return .success(user)
        } catch {
            print(error)
            print(error.localizedDescription)
            return .failure(DatabaseError.InitializationError(error.localizedDescription))
        }
    }
    
    func createDeviceUser() -> Result<(), DatabaseError> {
        do {
            let result: () = try gabber_chat_ios.createUser(name: "test", publicKey: Data())
            return .success(result)
        } catch {
            print(error)
            print(error.localizedDescription)
            return .failure(DatabaseError.InitializationError(error.localizedDescription))
        }
    }
    
    func loadRecentUsersAndMessages() -> Result<[User : Message], DatabaseError> {
        do {
            let result = try gabber_chat_ios.loadCurrentUsersAndMessages()
            return .success(result)
        } catch {
            print(error)
            print(error.localizedDescription)
            return .failure(DatabaseError.InitializationError(error.localizedDescription))
        }
    }
    
}
