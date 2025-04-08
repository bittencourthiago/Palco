import Foundation

struct HomeResponse: Decodable {
    let title: String
    let items: [String]
}
