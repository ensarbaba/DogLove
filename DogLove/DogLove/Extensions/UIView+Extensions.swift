//
//  UIView+Extensions.swift
//  DogLove
//
//  Created by M. Ensar Baba on 23.11.2020.
//

import UIKit

extension UIView {
    func startSpinner() {
        _spinner?.startAnimating()
    }
    
    func stopSpinner() {
        _spinner?.stopAnimating()
    }
}
// MARK: - Spinner related extensions
/// We've now indicated to the compiler we're taking responsibility ourselves
/// regarding thread-safety access of this global variable.
nonisolated(unsafe) fileprivate var spinnerKey: UInt8 = 0

private extension UIView {
    
    var _spinner: UIActivityIndicatorView? {
        get {
            if let indicator: UIActivityIndicatorView = associatedObject(base: self, key: &spinnerKey) { return indicator }
            
            let indicator = UIActivityIndicatorView(style: .medium)
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
