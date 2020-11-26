//
//  APIError.swift
//  DogLove
//
//  Created by M. Ensar Baba on 22.11.2020.
//

import Foundation

public enum APIError: String, Error {
    case apiError = "Some error occured on backend side"
    case urlError = "Url is not valid"
    case connectionError = "Connection lost"
    case statusCodeError = "Unexpected status code returned from server"
    case nilDataError = "Data may be corrupted or nil"
    case mapError = "Json response and the model are not same"
}
