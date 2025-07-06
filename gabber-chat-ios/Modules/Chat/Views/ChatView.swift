import SwiftUI

struct ChatView: View {
    
    @State private var messages: [ChatMessage] = [
        ChatMessage(id: UUID(), text: "Hello", isSentByCurrentUser: true, timestamp: Date(), sender: "Tommy"),
        ChatMessage(id: UUID(), text: "Hey, who this?", isSentByCurrentUser: false, timestamp: Date(), sender: "Alex"),
        ChatMessage(id: UUID(), text: "Its Tommy", isSentByCurrentUser: true, timestamp: Date(), sender: "Tommy"),
        ChatMessage(id: UUID(), text: "Sorry wrong number.", isSentByCurrentUser: false, timestamp: Date(), sender: "Alex"),
        ChatMessage(id: UUID(), text: "oh okay :(", isSentByCurrentUser: true, timestamp: Date(), sender: "Alex"),
    ]
    
    
    @State private var chatMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(messages) { message in
                        MessageRowView(message: message)
                    }
                }.padding(.horizontal)
            }
            ChatInputView(chatMessage: $chatMessage)
        }
        .background(Color(red: 29/255, green: 29/255, blue: 29/255))
    }
    
    private var header: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "chevron.left")
                    .padding(.leading)
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                VStack(alignment: .leading) {
                    Text("Alex Smith")
                        .font(.headline)
                }
                Spacer().padding(.trailing)
            }
            .padding(.vertical, 10)
            .background(Color(red: 33/255, green: 33/255, blue: 33/255))
            .foregroundColor(.white)
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
        }
    }
    
    struct ChatInputView: View {
        @Binding var chatMessage: String
        @State private var textHeight: CGFloat = 40
        
        private let minHeight: CGFloat = 40
        private let maxHeight: CGFloat = 320
        
        var body: some View {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
                
                HStack(alignment: .bottom, spacing: 12) {
                    ZStack(alignment: .bottomLeading) {
                        // Background for text view
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 29/255, green: 29/255, blue: 29/255))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .frame(height: max(minHeight, min(maxHeight, textHeight)))
                            //.foregroundColor(.white)

                        // Custom text view that expands
                        AutoResizingTextView(text: $chatMessage, height: $textHeight)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(height: max(minHeight, min(maxHeight, textHeight))) // This might be too large
                    }
                    .frame(height: max(minHeight, min(maxHeight, textHeight))) // This might be too large
                    .layoutPriority(-1) // Give text input lower priority so it compresses first

                    
                    Button(action: {
                        // Handle send message
                        if !chatMessage.isEmpty {
                            chatMessage = ""
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                            .clipShape(Circle())
                    }
                    .layoutPriority(1) // Give text input lower priority so it compresses first

                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 29/255, green: 29/255, blue: 29/255))
                
            }
        }
    }
    
//    struct AutoResizingTextView: UIViewRepresentable {
//        @Binding var text: String
//        @Binding var height: CGFloat
//        
//        func makeUIView(context: Context) -> UITextView {
//            let textView = UITextView()
//            textView.font = UIFont.systemFont(ofSize: 16)
//            textView.backgroundColor = UIColor.clear
//            textView.delegate = context.coordinator
//            textView.isScrollEnabled = false
//            textView.textContainerInset = UIEdgeInsets.zero
//            textView.textContainer.lineFragmentPadding = 0
//            textView.returnKeyType = .default
//            return textView
//        }
//        
//        func updateUIView(_ uiView: UITextView, context: Context) {
//            if uiView.text != text {
//                uiView.text = text
//                DispatchQueue.main.async {
//                    self.updateHeight(uiView)
//                }
//            }
//        }
//        
//        func makeCoordinator() -> Coordinator {
//            Coordinator(self)
//        }
//        
//        private func updateHeight(_ textView: UITextView) {
//            let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
//            let newHeight = max(40, size.height + 20) // 20 for padding
//            if newHeight != height {
//                height = newHeight
//            }
//        }
//        
//        class Coordinator: NSObject, UITextViewDelegate {
//            let parent: AutoResizingTextView
//            
//            init(_ parent: AutoResizingTextView) {
//                self.parent = parent
//            }
//            
//            func textViewDidChange(_ textView: UITextView) {
//                parent.text = textView.text
//                parent.updateHeight(textView)
//            }
//        }
//    }
    
    struct AutoResizingTextView: UIViewRepresentable {
        @Binding var text: String
        @Binding var height: CGFloat
        private let maxHeight: CGFloat = 120
        
        func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.backgroundColor = UIColor.clear
            textView.delegate = context.coordinator
            textView.textContainerInset = UIEdgeInsets.zero
            textView.textContainer.lineFragmentPadding = 0
            textView.returnKeyType = .default
            textView.textContainer.widthTracksTextView = true
            textView.textContainer.size = CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
            textView.showsVerticalScrollIndicator = false
            textView.showsHorizontalScrollIndicator = false
            textView.textColor = UIColor.white
            return textView
        }
        
        func updateUIView(_ uiView: UITextView, context: Context) {
            if uiView.text != text {
                uiView.text = text
            }
            
            let availableWidth = uiView.frame.width - uiView.textContainerInset.left - uiView.textContainerInset.right
            
            if availableWidth > 0 {
                // Set container width for wrapping
                uiView.textContainer.size = CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude)
                
                // Ensure proper text wrapping behavior
                uiView.textContainer.lineFragmentPadding = 0
                uiView.textContainer.widthTracksTextView = true
                uiView.textContainer.lineBreakMode = .byWordWrapping
            }
            
            // Enable/disable scrolling based on content height
            let contentHeight = uiView.sizeThatFits(CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude)).height
            uiView.isScrollEnabled = contentHeight > maxHeight - 20 // 20 for padding
            
            DispatchQueue.main.async {
                self.updateHeight(uiView)
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        private func updateHeight(_ textView: UITextView) {
            let fixedWidth = textView.frame.width
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let contentHeight = newSize.height + 20 // 20 for padding
            let newHeight = max(40, min(maxHeight, contentHeight))
            
            if abs(newHeight - height) > 1 { // Avoid unnecessary updates
                height = newHeight
            }
        }
        
        class Coordinator: NSObject, UITextViewDelegate {
            let parent: AutoResizingTextView
            
            init(_ parent: AutoResizingTextView) {
                self.parent = parent
            }
            
            func textViewDidChange(_ textView: UITextView) {
                parent.text = textView.text
                parent.updateHeight(textView)
            }
            
            func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                // Force layout update on text change
                DispatchQueue.main.async {
                    self.parent.updateHeight(textView)
                }
                return true
            }
        }
    }
}
