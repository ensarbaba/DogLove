//
//  UIView+Extensions.swift
//  DogLove
//
//  Created by M. Ensar Baba on 23.11.2020.
//

import UIKit

extension UIView {
    func setupFromNib() {
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
