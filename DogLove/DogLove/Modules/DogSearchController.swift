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

    // TableView Section Enum
    private enum Section: Int, CaseIterable {
        case dog
    }
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var searchBar: UISearchBar!
    
    private lazy var viewModel: DogSearchViewModel = {
        return DogSearchViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initViewModel()
    }
    
    private func configureUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for a breed"
        tableView.registerCellWithReuseIdentifier(DogCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        activityIndicator.hidesWhenStopped = true
    }
    
    private func initViewModel() {
        viewModel.viewHandler = { [weak self] (viewAction) in
            guard let self = self else { return }
            switch viewAction {
            case .reloadData:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .insertRows(let rows):
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: rows, with: .automatic)
                }
            case .requestInProgress(let progress):
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = !progress
                    progress ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
                }
            case .showMessage(let message):
                self.showAlert(message)
            }
        }
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

extension DogSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageRatio = viewModel.getImageRatio(at: indexPath.row)
        return tableView.frame.width / imageRatio
    }
    // MARK: Pagination Start
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.hasNeedToFetchMoreDog && viewModel.dogsRowCount == indexPath.row + 1  {
            guard let searchText = searchBar.text else { return }
                viewModel.searchDogs(for: searchText)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > tableView.contentSize.height-scrollView.frame.size.height-100 && viewModel.hasNeedToFetchMoreDog {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.frame.size.width/2, y: 25, width: 15, height: 15))
            let footerView = UIView()
            footerView.backgroundColor = .gray
            activityIndicator.startAnimating()
            footerView.addSubview(activityIndicator)
            DispatchQueue.main.async {
                self.tableView.tableFooterView = footerView
            }
        } else {
            DispatchQueue.main.async {
                self.tableView.tableFooterView = nil
            }
        }
    }
    // MARK: Pagination End
}

extension DogSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchFor), object: nil)
        self.perform(#selector(searchFor), with: nil, afterDelay: 1.5)
    }
}
