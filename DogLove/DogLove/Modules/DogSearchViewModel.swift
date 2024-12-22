//
//  DogSearchViewModel.swift
//  DogLove
//
//  Created by M. Ensar Baba on 22.11.2020.
//

import UIKit

typealias DogSearchRequest = [String: String]

@MainActor
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
            viewHandler?(.showMessage(alertMessage ?? "Some error occurred"))
        }
    }

    private var dogSearchResponse: DogSearchResponse?

    /// Search dogs by name
    /// - Parameter name: The dog name for search
    func searchDogs(for name: String) async {
        let parameters: DogSearchRequest = ["q": name, "limit": "\(limit)", "page": "\(page)", "order": "DESC"]

        if self.isLoading { return }
        self.isLoading = true

        do {
            guard let apiService = apiService else { return }
            let response = try await apiService.searchDogs(params: parameters)

            // Initial Data Fetch
            if dogSearchResponse == nil {
                dogSearchResponse = response
                viewHandler?(.reloadData)
            // Subsequent data as user scrolls tableview
            } else {
                guard let totalCount = dogSearchResponse?.count else { return }
                let lastIndex = totalCount - 1
                dogSearchResponse?.append(contentsOf: response)

                var newIndices: [IndexPath] = []
                for index in 0..<response.count {
                    newIndices.append(IndexPath(row: index + lastIndex, section: 0))
                }
                viewHandler?(.insertRows(newIndices))
            }

            hasNeedToFetchMoreDog = response.count > 0
            page += 1

        } catch let error as APIError {
            alertMessage = error.rawValue
        } catch {
            alertMessage = "Unexpected error occurred"
        }

        isLoading = false
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
        guard let item = dogSearchResponse?[safe: indexPath],
              let width = item.width,
              let height = item.height else { return 0 }
        return width/height
    }
}
