import RealmSwift
import Foundation

final class UserIDStorage {
    static func getOrCreateUserID() -> String {
        if let savedUserID = loadUserID() {
            return savedUserID
        } else {
            let newUserID = UUID().uuidString
            saveUserID(newUserID)
            return newUserID
        }
    }

    private static func loadUserID() -> String? {
        return UserDefaults.standard.string(forKey: "userID")
    }

    private static func saveUserID(_ userID: String) {
        UserDefaults.standard.set(userID, forKey: "userID")
    }
}
