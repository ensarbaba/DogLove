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
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let searchBar = UISearchBar()

    private lazy var viewModel = DogSearchViewModel(apiService: APIClient())

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        initViewModel()
        addDoneButtonOnKeyboard()
    }
    
 
    private func configureUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for a breed"
        tableView.register(DogCell.self, forCellReuseIdentifier: DogCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(searchBar)
        view.addSubview(tableView)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func initViewModel() {
        viewModel.viewHandler = { (viewAction) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch viewAction {
                case .reloadData:
                    self.tableView.reloadData()

                case .insertRows(let rows):
                    self.tableView.insertRows(at: rows, with: .automatic)

                case .requestInProgress(let progress):
                    progress ? self.showActivityIndicator() : self.hideActivityIndicator()

                case .showMessage(let message):
                    self.showAlert(message)
                }
            }
        }
    }
    
    @objc func searchFor() {
        guard let searchText = searchBar.text else { return }
        Task {
            await viewModel.searchDogs(for: searchText)
        }
    }
    
    // MARK: UI Configuration
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        searchBar.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        searchBar.resignFirstResponder()
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
            guard let data = viewModel.getDogData(at: indexPath.row),
                  let cell = tableView.dequeueReusableCell(withIdentifier: DogCell.reuseIdentifier, for: indexPath) as? DogCell else {
                return UITableViewCell()
            }
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
            Task {
                await viewModel.searchDogs(for: searchText)
            }
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
