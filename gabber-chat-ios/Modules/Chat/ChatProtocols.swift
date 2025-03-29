//
//  ChatProtocols.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 28/3/2025.
//

protocol ChatViewProtocol: AnyObject {
    var presenter: ChatPresenterProtocol? { get set }
    func displayMessages(_ messages: [ChatMessage])
}

protocol ChatPresenterProtocol: AnyObject {
    var view: ChatViewProtocol? { get set }
    var interactor: ChatInteractorProtocol? { get set }
    var router: ChatRouterProtocol? { get set }
    
    func viewDidLoad()
    func sendMessage(_ message: String)
}

protocol ChatInteractorProtocol: AnyObject {
    var presenter: ChatPresenterProtocol? { get set }
    func fetchMessages()
    func saveMessage(_ message: ChatMessage)
}

protocol ChatRouterProtocol: AnyObject {
    static func createChatModule() -> ChatView
    func navigateToSettings()
}
