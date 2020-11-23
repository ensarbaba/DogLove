//
//  DogSearchResponse.swift
//  DogLove
//
//  Created by M. Ensar Baba on 22.11.2020.
//

import Foundation


// MARK: - DogSearchResponseElement
struct DogSearchResponseElement: Codable {
    let breeds: [Breed]?
    let id: String?
    let url: String?
    let width, height: Int?
}

// MARK: - Breed
struct Breed: Codable {
    let id: Int?
    let name: String?
}

typealias DogSearchResponse = [DogSearchResponseElement]
