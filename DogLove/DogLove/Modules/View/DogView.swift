//
//  DogView.swift
//  DogLove
//
//  Created by M. Ensar Baba on 23.11.2020.
//

import UIKit

class DogView: UIView {

    @IBOutlet weak private var imageView: UIImageView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    func update(with item: DogSearchResponseElement) {
        guard let url = item.url else { return }
        ImageLoader.shared.obtainImageWithPath(imagePath: url) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
