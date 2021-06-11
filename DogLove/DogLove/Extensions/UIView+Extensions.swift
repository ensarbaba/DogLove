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
    
    func startSpinner() {
        _spinner?.startAnimating()
    }
    
    func stopSpinner() {
        _spinner?.stopAnimating()
    }
}
// MARK: - Spinner related extensions

private var spinnerKey: UInt8 = 0

private extension UIView {
    
    var _spinner: UIActivityIndicatorView? {
        get {
            if let indicator: UIActivityIndicatorView = associatedObject(base: self, key: &spinnerKey) { return indicator }
            
            let indicator = UIActivityIndicatorView(style: .gray)
            indicator.hidesWhenStopped = true
            indicator.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(indicator)
            
            centerXAnchor.constraint(equalTo: indicator.centerXAnchor).isActive = true
            centerYAnchor.constraint(equalTo: indicator.centerYAnchor).isActive = true
            
            associateObject(base: self, key: &spinnerKey, value: indicator)
            return indicator
        }
        set {
            associateObject(base: self, key:  &spinnerKey, value: newValue)
        }
    }
}
