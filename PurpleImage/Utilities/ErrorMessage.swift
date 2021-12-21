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
    case noResults = "No results, try another search!"
    case coreDataError = "Error getting your liked images, try again later"
    case coreDataImageError = "Your fetched image might be corrupted"
    case errorRemovingFavouritedItem = "There was a problem editing your list, try again later"
}
