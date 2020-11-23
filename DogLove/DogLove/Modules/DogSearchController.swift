//
//  DogSearchController.swift
//  DogLove
//
//  Created by M. Ensar Baba on 22.11.2020.
//

import UIKit

enum AppStoryboard: String {
   case main = "Main"
}

class DogSearchController: UIViewController {

    private enum Section: Int, CaseIterable {
        case dog
    }
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var noDataLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var searchBar: UISearchBar!
    
    private lazy var viewModel: DogSearchViewModel = {
        return DogSearchViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for a breed"
        tableView.dataSource = self
    }
    
    private func initViewModel() {
        
    }
    
    @objc func searchFor() {
        guard let searchText = searchBar.text else { return }
        viewModel.searchDogs(for: searchText)
    }
}

extension DogSearchController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .dog:
            return viewModel.dogsRowCount
        case .none:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .dog:
            guard let data = viewModel.getDogData(at: indexPath.row) else { return UITableViewCell() }
            let cell = tableView.dequeue(cell: DogCell.self, indexPath: indexPath)
            cell.update(with: data)
            return cell
        case .none:
            return UITableViewCell()
        }
    }
}

extension DogSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchFor), object: nil)
        self.perform(#selector(searchFor), with: nil, afterDelay: 1.5)
    }
}
