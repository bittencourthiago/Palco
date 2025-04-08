import UIKit

final class MinhClasse {
    var teste: User
    
    init(teste: User) {
        self.teste = teste
    }
    
    func ola() {
        let stringRaw = "ola"
        print(stringRaw.withDot)
    }
}


final class OutraClasse {
    func testeOla() {
        let user = User(name: "name", age: 12)
        let minhaClasse = MinhClasse(teste: user)
        minhaClasse.ola()
    }
}
extension String {
    var withDot: String {
        return self + "."
    }
}

struct User {
    let name: String
    let age: Int
}
