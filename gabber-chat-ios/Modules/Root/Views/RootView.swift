//
//  RootView.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 1/7/2025.
//


import SwiftUI

struct RootView: View {
    @EnvironmentObject var dependencies: AppDependencies

    var body: some View {
        let result = dependencies.rustLib.initDatabase()
        LoadingView()
    }
}
