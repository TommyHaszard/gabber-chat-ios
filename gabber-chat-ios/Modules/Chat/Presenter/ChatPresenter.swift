//
//  ChatPresenter.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 28/3/2025.
//

import Foundation

class ChatPresenter: ObservableObject {
    @Published var messages: [ChatMessage] = []
    
    var interactor: ChatInteractorProtocol?

    func viewDidLoad() {
        interactor?.fetchMessages()
    }

    func sendMessage(_ message: String) {
        let chatMessage = ChatMessage(id: UUID(), text: message, isSentByCurrentUser: true, timestamp: Date(), sender: "Me")
        interactor?.saveMessage(chatMessage)
    }
}
