import SwiftUI

struct ChatView: View {
    @StateObject private var webSocketManager = WebSocketManager()
    @State private var inputMessage = ""
    let contactID: String

    var body: some View {
        VStack {
            Text("Seu ID: \(webSocketManager.userID)")
                .font(.caption)
                .padding()
            
            Text("Conversando com: \(contactID)")
                .font(.subheadline)
                .padding(.bottom)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(webSocketManager.messages) { message in
                        MessageView(message: message)
                    }
                }
                .padding()
            }

            HStack {
                TextField("Mensagem", text: $inputMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Enviar") {
                    webSocketManager.sendMessage(inputMessage)
                    inputMessage = ""
                }
            }
            .padding()
        }
        .onAppear {
            webSocketManager.connect(contactID: contactID)
        }
        .onDisappear {
            webSocketManager.disconnect()
        }
    }
}

struct MessageView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isSentByUser { Spacer() }
            
            Text(message.text)
                .padding()
                .background(message.isSentByUser ? Color.black : Color.green.opacity(0.5))
                .foregroundColor(message.isSentByUser ? Color.white : Color.black)
                .cornerRadius(10)
                .frame(maxWidth: 250, alignment: message.isSentByUser ? .trailing : .leading)

            if !message.isSentByUser { Spacer() }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ChatView(contactID: "")
}
