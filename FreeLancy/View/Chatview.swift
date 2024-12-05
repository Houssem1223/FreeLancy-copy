import SwiftUI

struct Chatview: View {
    var freelancerName: String // Passing freelancer name to the view
    
    @StateObject var messagesManager = MessagesManager()

    var body: some View {
        VStack {
            // Title Row at the top (containing profile info)
            TitleRow(name: freelancerName)
            
            // Scroll view to display the list of messages
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(messagesManager.messages, id: \.id) { message in
                        MessageBubble(message: message)
                            .id(message.id) // Make sure each message is identifiable for scrolling
                    }
                }
                .padding(.top, 10)
                .background(.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .onChange(of: messagesManager.lastMessageId) { id in
                    withAnimation {
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
            }
            
            // Message input field at the bottom
            MessageField()
                .environmentObject(messagesManager)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.blue.opacity(0.7))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct Chatview_Previews: PreviewProvider {
    static var previews: some View {
        Chatview(freelancerName: "")  // Passing a sample name for preview
    }
}
