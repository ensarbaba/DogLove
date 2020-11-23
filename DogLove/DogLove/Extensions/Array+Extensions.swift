//
//  Array+Extensions.swift
//  DogLove
//
//  Created by M. Ensar Baba on 23.11.2020.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
