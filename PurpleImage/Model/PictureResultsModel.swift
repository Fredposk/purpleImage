//
//  PictureResultsModel.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.11.21.
//

import Foundation

struct hits: Codable, Hashable {
    var hits: [Hit]
    let totalHits: Int
}

struct Hit: Identifiable, Codable, Hashable {
    let id: Int
    let pageURL: String
    let largeImageURL: String
    let webformatURL: String
    let views: Int
    let user: String
    let tags: String
}
