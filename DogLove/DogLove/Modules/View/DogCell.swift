//
//  DogCell.swift
//  DogLove
//
//  Created by M. Ensar Baba on 23.11.2020.
//

import UIKit

class DogCell: UITableViewCell {
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var dogView: DogView!
    
    func update(with item: DogSearchResponseElement) {
        dogView.update(with: item)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dogView.reuseCellCalled()
    }
}
