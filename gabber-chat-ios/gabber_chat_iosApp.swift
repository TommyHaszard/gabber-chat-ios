//
//  gabber_chat_iosApp.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 16/2/2025.
//

import SwiftUI

@main
struct gabber_chat_iosApp: App {
    @StateObject private var dependencies = AppDependencies(rustLib: RustLibImpl())

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
            }.environmentObject(dependencies)
        }
    }
}
