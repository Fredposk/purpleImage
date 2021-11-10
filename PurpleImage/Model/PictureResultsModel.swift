//
//  PictureResultsModel.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.11.21.
//

import Foundation

struct hits: Codable {
    var hits: [Hit]
}

struct Hit: Identifiable, Codable {
    var id: Int
    var pageURL: String
    var largeImageURL: String
    var views: Int
    var user: String
    var tags: String
}
