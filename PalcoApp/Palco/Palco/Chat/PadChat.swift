import SwiftUI

struct PadChatView: View {
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

#Preview {
    PadChatView(contactID: "")
}
