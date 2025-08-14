//
//  ContentView.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 19/7/2025.
//

import SwiftUI

struct UserContentView: View {
    @State private var searchText = ""
    @EnvironmentObject var dependencies: AppDependencies
    @StateObject var viewModel = UserContentViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    HStack {
                        Text("Chats")
                            .font(.title)
                            .bold()
                        
                        Image(systemName: "chevron.down")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "ellipsis.bubble")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Search Bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.up.right.and.arrow.down.left")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Chat List
               ScrollView {
                   LazyVStack(spacing: 0) {
                       ForEach(viewModel.getChatItems(with: dependencies), id: \.userId) { item in
                           NavigationLink(destination: ChatDetailView(userId: item.userId)) {
                               ChatRow(item: item)
                           }
                           .buttonStyle(PlainButtonStyle())
                       }
                   }
                   .padding(.top, 16)
               }
               
               Spacer()
            }
            .background(Color(.systemBackground))
        }
        .overlay(
            // Bottom Tab Bar
            VStack {
                Spacer()
                
                HStack {
                    // Home Tab
                    VStack(spacing: 4) {
                        Image(systemName: "house")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Home")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Chats Tab (Active)
                    VStack(spacing: 4) {
                        ZStack {
                            Image(systemName: "message.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                            
                                Circle()
                                    .fill(.red)
                                    .frame(width: 18, height: 18)
                                    .overlay(
                                        Text("8")
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                    )
                                    .offset(x: 12, y: -12)
                        }
                        Text("Chats")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Calls Tab
                    VStack(spacing: 4) {
                        Image(systemName: "phone")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Calls")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(Color(.systemBackground))
                .overlay(
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 0.5),
                    alignment: .top
                )
            }
        )
    }
}
