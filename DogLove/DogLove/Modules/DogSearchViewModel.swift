//
//  DogSearchViewModel.swift
//  DogLove
//
//  Created by M. Ensar Baba on 22.11.2020.
//

import UIKit

typealias DogSearchRequest = [String: String]

class DogSearchViewModel {
    
    enum ViewAction {
        case requestInProgress(_ progress: Bool)
        case reloadData
        case insertRows(_ addedRows: [IndexPath])
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
    
    private var dogSearchResponse: DogSearchResponse?
    
    func searchDogs(for name: String) {
        let parameters: DogSearchRequest = ["q": name, "limit": "5", "page": "\(page)", "order": "DESC"]
        guard let apiService = apiService else {self.alertMessage = "API is nil"; return}
        
        if self.isLoading { return }
        self.isLoading = true
        apiService.searchDogs(params: parameters, method: .GET, endPoint: .search, completed: { (result) in
            defer { self.isLoading = false }
            switch result {
            case .success(let response):
                if self.dogSearchResponse == nil {
                    self.dogSearchResponse = response
                    self.viewHandler?(.reloadData)

                } else {
                    let lastIndex = (self.dogSearchResponse?.count)!-1
                    self.dogSearchResponse?.append(contentsOf: response)
                    var newIndices: [IndexPath] = [IndexPath]()
                    for index in 0..<response.count {
                        newIndices.append(IndexPath(row: index + lastIndex, section: 0))
                    }
                    self.viewHandler?(.insertRows(newIndices))
                }
                self.hasNeedToFetchMoreDog = response.count > 0
                self.page += 1

            case .failure(let error):
                self.alertMessage = error.rawValue
            }
        })
    }
    
    private var page = 0
    
    var hasNeedToFetchMoreDog = false

    var dogsRowCount: Int {
        return dogSearchResponse?.count ?? 0
    }
    
    func getDogData(at indexPath: Int) -> DogSearchResponseElement? {
        return dogSearchResponse?[safe: indexPath]
    }
    
    func getImageRatio(at indexPath: Int) -> CGFloat {
        guard let item = dogSearchResponse?[safe: indexPath], let width = item.width, let height = item.height else { return 0 }
        return width/height
    }
}
