//
//  UITableView+Extensions.swift
//  DogLove
//
//  Created by M. Ensar Baba on 23.11.2020.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cell: T.Type) {
        register(cell.nib(), forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    func dequeue<T: UITableViewCell>(cell: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: cell.reuseIdentifier, for: indexPath) as! T
    }
    
    func registerCellWithReuseIdentifier(_ reuseIdentifier: String) {
        let cellNib = UINib(nibName: reuseIdentifier, bundle: nil)
        register(cellNib, forCellReuseIdentifier: reuseIdentifier)
    }
}
