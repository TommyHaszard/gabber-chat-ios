//
//  Message.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 19/7/2025.
//

import SwiftUI


struct ChatDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""
    @State private var messages: [Message] = []
    @State private var user: User?
    @State private var scrollProxy: ScrollViewReader<ChatDetailView>?
    @State private var viewModel: ChatDetailViewModel?
    @EnvironmentObject var dependencies: AppDependencies
    
    private let userId: UUID
    
    
    init(userId: UUID) {
        self.userId = userId
    }
    
    var body: some View {
           GeometryReader { geometry in
               VStack(spacing: 0) {
                   // Header
                   HStack(spacing: 12) {
                       Button(action: { dismiss() }) {
                           Image(systemName: "chevron.left")
                               .font(.title2)
                               .fontWeight(.medium)
                               .foregroundColor(.primary)
                       }
                       
                       // Contact Avatar (small)
                       Circle()
                           .fill(Color(red: 0.9, green: 0.85, blue: 0.7))
                           .frame(width: 40, height: 40)
                           .overlay(
                               Text("🌟")
                                   .font(.title3)
                           )
                       
                       VStack(alignment: .leading, spacing: 2) {
                           HStack(spacing: 4) {
                               Text(user?.username ?? "")
                                   .font(.headline)
                                   .fontWeight(.semibold)
                                   .foregroundColor(.primary)
                               
                               Image(systemName: "checkmark.seal.fill")
                                   .font(.caption)
                                   .foregroundColor(.blue)
                           }
                       }
                       
                       Spacer()
                       
                       HStack(spacing: 20) {
                           Button(action: {}) {
                               Image(systemName: "video")
                                   .font(.title2)
                                   .foregroundColor(.primary)
                           }
                           
                           Button(action: {}) {
                               Image(systemName: "phone")
                                   .font(.title2)
                                   .foregroundColor(.primary)
                           }
                       }
                   }
                   .padding(.horizontal, 16)
                   .padding(.vertical, 12)
                   .background(Color(.systemBackground))
                   
                   Divider()
                   
                   // Scrollable Content
                   ScrollView {
                       VStack(spacing: 0) {
                           // Profile Section
                           VStack(spacing: 16) {
                               // Large Avatar
                               Circle()
                                   .fill()
                                   .frame(width: 120, height: 120)
                                   .overlay(
                                    Text(user?.username ?? "")
                                           .font(.system(size: 48, weight: .medium))
                                           .foregroundColor(.blue)
                                   )
                               
                               Text(user?.username ?? "")
                                   .font(.title2)
                                   .fontWeight(.medium)
                                   .foregroundColor(.primary)
                               
                               // Action Button
                               Button(action: {}) {
                                   Text("View Profile")
                                       .font(.subheadline)
                                       .foregroundColor(.blue)
                                       .padding(.horizontal, 20)
                                       .padding(.vertical, 8)
                                       .background(Color(.systemGray6))
                                       .cornerRadius(20)
                               }
                           }
                           .padding(.vertical, 32)
                           
                           ScrollViewReader { proxy in
                               LazyVStack(spacing: 8) {
                                   ForEach(messages, id: \.messageId) { message in
                                       MessageRow(message: message).id(message.messageId)
                                   }
                               }
                               .padding(.horizontal, 16)
                               .padding(.bottom, 20)
                               .onAppear {
                                   scrollToBottom(proxy: proxy)
                               }
                               .onChange(of: messages.count) { _ in
                                   scrollToBottom(proxy: proxy)
                               }
                           }
                       }
                   }
                   
                   // Message Input
                   VStack(spacing: 0) {
                       Divider()
                       
                       HStack(spacing: 12) {
                           Button(action: {}) {
                               Image(systemName: "plus")
                                   .font(.title2)
                                   .foregroundColor(.primary)
                           }
                           
                           HStack {
                               TextField("Message", text: $messageText)
                                   .textFieldStyle(PlainTextFieldStyle())
                                   .onSubmit {
                                       sendMessage()
                                   }
                               
                               HStack(spacing: 12) {
                                   Button(action: {}) {
                                       Image(systemName: "face.smiling")
                                           .font(.title2)
                                           .foregroundColor(.secondary)
                                   }
                                   
                                   Button(action: {}) {
                                       Image(systemName: "camera")
                                           .font(.title2)
                                           .foregroundColor(.secondary)
                                   }
                                   
                                   if messageText.trimmedText.isEmpty {
                                       Button(action: {}) {
                                           Image(systemName: "mic")
                                               .font(.title2)
                                               .foregroundColor(.secondary)
                                       }
                                   } else {
                                       Button(action: sendMessage) {
                                           Image(systemName: "arrow.up.circle.fill")
                                               .font(.title2)
                                               .foregroundColor(.blue)
                                       }
                                       .buttonStyle(.plain)
                                   }
                               }
                           }
                           .padding(.horizontal, 12)
                           .padding(.vertical, 8)
                           .background(Color(.systemGray6))
                           .cornerRadius(20)
                       }
                       .padding(.horizontal, 16)
                       .padding(.vertical, 12)
                       .background(Color(.systemBackground))
                   }
               }
           }
           .navigationBarHidden(true)
           .background(Color(.systemBackground))
           .onAppear {
               loadDataIfNeeded()
          }
       }
       
       // MARK: - Helper Functions
        private func loadDataIfNeeded() {
            guard viewModel == nil else { return }
            
            let newViewModel = ChatDetailViewModel()
            self.viewModel = newViewModel
        

            if let loadedUser = newViewModel.loadUser(userId: userId, with: dependencies) {
                self.user = loadedUser
                self.messages = newViewModel.loadMessages(userId: userId, with: dependencies)
            }
        }
    
    
       private func sendMessage() {
           let trimmedMessage = messageText.trimmedText
           guard !trimmedMessage.isEmpty else { return }
           
           let messageUUID = UUID()
           var uuidBytes = userId.uuid
           let messageIdData = Data(bytes: &uuidBytes, count: MemoryLayout.size(ofValue: uuidBytes))
           
           let newMessage = Message(messageId: messageIdData, userId: user!.userId, content: trimmedMessage, createdAt: Date().timeIntervalSinceNow.bitPattern, isFromUser: false)
           
           withAnimation(.easeInOut(duration: 0.3)) {
               messages.append(newMessage)
           }
           
           messageText = ""
           
           print(user!.userId)
           print(newMessage)
           let message_result = viewModel!.sendMessage(userId: user!.userId, message: newMessage, with: dependencies);
       }
       
    private func scrollToBottom(proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.5)) {
                if let lastMessage = self.messages.last {
                    proxy.scrollTo(lastMessage.messageId, anchor: .bottom)
                }
            }
        }
    }
}

   // MARK: - String Extension
   extension String {
       var trimmedText: String {
           return self.trimmingCharacters(in: .whitespacesAndNewlines)
       }
   }
