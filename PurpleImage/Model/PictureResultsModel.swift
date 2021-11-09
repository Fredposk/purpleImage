//
//  PictureResultsModel.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.11.21.
//

import Foundation

struct Picture: Identifiable {
    var id: Int
    var pageURL: String
    var largeImageURL: String
    var view: Int
    var user: String
    var tags: String
}
