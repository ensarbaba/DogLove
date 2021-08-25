//
//  UIViewController+Extensions.swift
//  DogLove
//
//  Created by M. Ensar Baba on 23.11.2020.
//

import UIKit

extension UIViewController {
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private static var activityIndicatorKey: UInt8 = 0
    
    private var activityIndicatorView: UIActivityIndicatorView? {
        get {
            associatedObject(base: self, key: &UIViewController.activityIndicatorKey)
        }
        set (activityIndicatorView) {
            associateObject(base: self, key: &UIViewController.activityIndicatorKey, value: activityIndicatorView)
        }
    }
    
    func showActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        guard let activityIndicatorView = activityIndicatorView else { return }
        activityIndicatorView.center = view.center
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        activityIndicatorView.startAnimating()
        
        view.addSubview(activityIndicatorView)
    }
    
    func hideActivityIndicator() {
        activityIndicatorView?.removeFromSuperview()
    }
}
