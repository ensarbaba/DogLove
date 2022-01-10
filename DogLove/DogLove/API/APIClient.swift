//
//  APIClient.swift
//  DogLove
//
//  Created by M. Ensar Baba on 22.11.2020.
//

import Foundation

protocol APIClientProtocol: AnyObject {
    func searchDogs(params: DogSearchRequest, completion: @escaping (Result<DogSearchResponse, APIError>) -> Void)
}

enum APIMethod: String {
    case GET,POST
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
    public func searchDogs(params: DogSearchRequest, completion: @escaping (Result<DogSearchResponse, APIError>) -> Void) {

        var urlComponents = self.urlComponents
        urlComponents.path = EndPoint.search.path
        urlComponents.setQueryItems(with: params)
    
        guard let url = urlComponents.url else {
            completion(.failure(.urlError))
            return
        }
        call(url: url, method: .GET, completion: completion)
    }
    
    /// Generic API call function
    /// - Parameter url: The request url want to call
    /// - Parameter method: The request method you call for
    /// - Parameter completion: Capturing result type response
    /// - Returns: Result<T, APIError>  which either returns Generic response model T or APIError that conforms to Error
    private func call<T: Decodable>(url: URL, method: APIMethod, completion: @escaping (Result<T, APIError>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(.connectionError))
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response ,error  in
            if let _ = error {
                        completion(.failure(.apiError))
                    }
        
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode
                    else {
                        completion(.failure(.statusCodeError))
                        return
                    }
        
                    guard let data = data else {
                        completion(.failure(.nilDataError))
                        return
                    }
        
                    do {
                        let mappedObject = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(mappedObject))
                    } catch {
                        completion(.failure(.mapError))
                    }
        }.resume()
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
