import Foundation

protocol APIClientProtocol: AnyObject {
    func searchDogs(params: DogSearchRequest) async throws -> DogSearchResponse
}

enum APIMethod: String {
    case GET, POST
}

enum EndPoint: String {
    case search

    var path: String {
        switch self {
        case .search:
            return "/v1/images/search"
        }
    }
}

class APIClient: APIClientProtocol {

    init() {}

    /* Storing hardcoded api key is not a good approach, we're doing this because it's a code case only */
    private let apiKey = "9bb6d9bd-f4c1-461b-a5ca-205020430d6f"
    private let baseUrl = "api.thedogapi.com"

    /// urlComponents for composing request url
    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        return urlComponents
    }

    /// API function for searching dogs by name
    public func searchDogs(params: DogSearchRequest) async throws -> DogSearchResponse {
        var urlComponents = self.urlComponents
        urlComponents.path = EndPoint.search.path
        urlComponents.setQueryItems(with: params)

        guard let url = urlComponents.url else {
            throw APIError.urlError
        }

        return try await call(url: url, method: .GET)
    }

    /// Generic API call function
    /// - Parameter url: The request url want to call
    /// - Parameter method: The request method you call for
    /// - Returns: Generic response model T that conforms to Decodable
    private func call<T: Decodable>(url: URL, method: APIMethod) async throws -> T {
        if !Reachability.isConnectedToNetwork() {
            throw APIError.connectionError
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<299 ~= httpResponse.statusCode else {
            throw APIError.statusCodeError
        }

        do {
            let mappedObject = try JSONDecoder().decode(T.self, from: data)
            return mappedObject
        } catch {
            throw APIError.mapError
        }
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
