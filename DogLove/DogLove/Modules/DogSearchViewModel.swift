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
    
    private var apiService: APIClientProtocol?
    
    init(apiService: APIClientProtocol) {
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
    
    
    /// Search dogs by name
    /// - Parameter name: The dog name for search
    func searchDogs(for name: String) {
        let parameters: DogSearchRequest = ["q": name, "limit": "\(limit)", "page": "\(page)", "order": "DESC"]
        
        if self.isLoading { return }
        self.isLoading = true
        apiService?.searchDogs(params: parameters, method: .GET, endPoint: .search, completed: { [weak self] (result) in
            guard let self = self else { return }
            defer { self.isLoading = false }
            switch result {
            case .success(let response):
                // Initial Data Fetch
                if self.dogSearchResponse == nil {
                    self.dogSearchResponse = response
                    self.viewHandler?(.reloadData)
                // Subsequent data as user scrolls tableview
                } else {
                    guard let totalCount = self.dogSearchResponse?.count else {return}
                    let lastIndex = totalCount - 1
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
    
    // MARK: Pagination Data
    private var page = 0
    private var limit = 10
    var hasNeedToFetchMoreDog = false

    // MARK: TableView Data Source
    /// Number of rows
    var dogsRowCount: Int {
        return dogSearchResponse?.count ?? 0
    }
    /// Cell for row data
    func getDogData(at indexPath: Int) -> DogSearchResponseElement? {
        return dogSearchResponse?[safe: indexPath]
    }
    /// Image ratio for resizing cell
    func getImageRatio(at indexPath: Int) -> CGFloat {
        guard let item = dogSearchResponse?[safe: indexPath], let width = item.width, let height = item.height else { return 0 }
        return width/height
    }
}
