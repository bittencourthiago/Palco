import SwiftUI

/// 🔥 Modelo de mensagem
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isSentByUser: Bool
}

class WebSocketManager: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private var webSocketTask: URLSessionWebSocketTask?
    let userID: String

    init() {
        self.userID = UserIDStorage.getOrCreateUserID()
    }
    
    func connect(contactID: String) {
        let chatRoomID = generateChatRoomID(userID: userID, contactID: contactID)
        let url = URL(string: "ws://localhost:8080/?room=\(chatRoomID)")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        
        receiveMessages()
    }
    
    func sendMessage(_ message: String) {
        let formattedMessage = "\(userID):\(message)"
        DispatchQueue.main.async {
            self.messages.append(ChatMessage(text: message, isSentByUser: true))
        }
        
        let messageToSend = URLSessionWebSocketTask.Message.string(formattedMessage)
        webSocketTask?.send(messageToSend) { error in
            if let error = error {
                print("Erro ao enviar mensagem: \(error)")
            }
        }
    }
    
    func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleIncomingMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self?.handleIncomingMessage(text)
                    } else {
                        print("⚠️ Mensagem recebida não pode ser convertida para string")
                    }
                @unknown default:
                    print("⚠️ Tipo de mensagem desconhecido recebido")
                }
            case .failure(let error):
                print("Erro ao receber mensagem: \(error)")
                self?.reconnect()
            }

            self?.receiveMessages()
        }
    }

    private func handleIncomingMessage(_ message: String) {
        let components = message.split(separator: ":", maxSplits: 1).map(String.init)
        guard components.count == 2 else { return }

        let senderID = components[0]
        let text = components[1]

        DispatchQueue.main.async {
            self.messages.append(ChatMessage(text: text, isSentByUser: senderID == self.userID))
        }
    }

    private func reconnect() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            print("🔄 Tentando reconectar ao WebSocket...")
            self?.connect(contactID: "ÚltimoContato") // Ajuste conforme necessário
        }
    }


    func disconnect() {
        webSocketTask?.cancel()
    }
    
    private func generateChatRoomID(userID: String, contactID: String) -> String {
        return [userID, contactID].sorted().joined(separator: "_")
    }
}
