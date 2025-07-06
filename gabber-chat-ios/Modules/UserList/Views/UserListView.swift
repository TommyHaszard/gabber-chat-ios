//
//  UserListView.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 1/7/2025.
//
import SwiftUI


struct UserListView: View {
    let users: [User]

    var body: some View {
        List(users) { user in
            Text(user.name)
        }
        .navigationTitle("Users")
    }
}
