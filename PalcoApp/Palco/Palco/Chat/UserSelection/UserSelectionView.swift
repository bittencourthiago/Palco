import SwiftUI

struct UserSelectionView: View {
    @State private var contactID = ""
    @State private var navigateToChat = false
    private var userID = UserIDStorage.getOrCreateUserID()
    var body: some View {
        NavigationView {
            VStack {
                UserSelectionCardWithID(
                    userID: userID
                )
                
                TextField("Digite o ID do contato", text: $contactID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                NavigationLink(
                    destination: ChatView(contactID: contactID),
                    isActive: $navigateToChat
                ) {
                    Button("Iniciar Chat") {
                        if !contactID.isEmpty {
                            navigateToChat = true
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

struct UserSelectionCardWithID: View {
    let userID: String
    var body: some View {
        HStack {
            Button {
                UIPasteboard.general.string = userID
            } label: {
                Text("Copie seu Id")
                Image(
                    systemName: "document.on.document.fill"
                )
            }
        }
    }
}

#Preview {
    UserSelectionView()
}
