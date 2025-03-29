//
//  ChatInteractor.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 28/3/2025.
//

class ChatInteractor: ChatInteractorProtocol {
    weak var presenter: ChatPresenterProtocol?

    func fetchMessages() {
        // Call Rust backend via UniFFI
        let messages: [ChatMessage] = RustBackend.shared.getMessages()
        presenter?.view?.displayMessages(messages)
    }

    func saveMessage(_ message: ChatMessage) {
        RustBackend.shared.saveMessage(message)
    }
}
