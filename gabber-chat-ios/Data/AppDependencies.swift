//
//  AppDependencies.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 9/7/2025.
//


import SwiftUI

@MainActor
class AppDependencies: ObservableObject {
    let rustLib: any RustLib

    init(rustLib: any RustLib) {
        self.rustLib = rustLib
    }
}
