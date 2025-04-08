import Foundation

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T:Decodable>(_ endpoint: EndpointType) async throws -> T
}

final class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    func request<T:Decodable>(_ endpoint: EndpointType) async throws -> T {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        let (data, response) = try await URLSession.shared.data(for: request)
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
