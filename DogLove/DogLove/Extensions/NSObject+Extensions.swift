//
//  NSObject+Extensions.swift
//  DogLove
//
//  Created by M. Ensar Baba on 23.11.2020.
//

import UIKit

extension NSObject {
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    class func nib() -> UINib? {
        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }
}
