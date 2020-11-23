//
//  DogSearchViewModel.swift
//  DogLove
//
//  Created by M. Ensar Baba on 22.11.2020.
//

import Foundation

typealias DogSearchRequest = [String: String]

class DogSearchViewModel {
    
    enum ViewAction {
        case requestInProgress(_ progress: Bool)
        case reloadData
        case showMessage(_ message: String)
    }
    
    var apiService: APIClientProtocol?
    
    init(apiService: APIClientProtocol = APIClient()) {
        self.apiService = apiService
    }
    
    var viewHandler: ((ViewAction) -> Void)?
    
    private var isLoading: Bool = false {
        didSet {
            viewHandler?(.requestInProgress(isLoading))
        }
    }
    
    private var alertMessage: String? {
        didSet {
            viewHandler?(.showMessage(alertMessage ?? "Some error occured"))
        }
    }
    
    func searchDogs(for name: String, limit: String, page: String, order: String) {
        let parameters: DogSearchRequest = ["q": name, "limit": limit, "page": page, "order": order]
        guard let apiService = apiService else {self.alertMessage = "API is nil"; return}
        
        if self.isLoading { return }
        self.isLoading = true
        apiService.searchDogs(params: parameters, method: .GET, endPoint: .search, completed: { (result) in
            defer { self.isLoading = false }
            switch result {
            case .success(let response):
                print(response.first?.url)
                
            case .failure(let error):
                self.alertMessage = error.rawValue
            }
        })
    }
}
