//
//  DogView.swift
//  DogLove
//
//  Created by M. Ensar Baba on 23.11.2020.
//

import UIKit

class DogView: UIView {

    @IBOutlet private weak var imageView: UIImageView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    func update(with item: DogSearchResponseElement) {
        self.imageView.loadImageAsync(with: item.url)
    }
    
    func reuseCellCalled() {
        self.imageView.image = nil
    }
}
