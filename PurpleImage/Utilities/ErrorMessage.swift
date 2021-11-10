//
//  ErrorMessage.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.11.21.
//

import Foundation

enum errorMessage: String, Error {
    case invalidSearchTerm = "invalid search term"
    case networkingError = "Check your internet connection"
    case invalidHTTPResponse = "invalid response from server"
    case invalidData = "invalid data from server"
    case errorParsingData = "error decoding data"

    
}
