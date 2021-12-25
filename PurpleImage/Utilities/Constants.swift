//
//  Constants.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 08.12.21.
//

import UIKit


enum Images {
    static let shareButtonImage = UIImage(systemName:"square.and.arrow.up")
    static let heartedImage = UIImage(systemName: "heart.fill")
    static let notHeartedImage = UIImage(systemName: "heart")
    static let placeHolderUser = UIImage(systemName: "person.circle.fill")
    static let viewUserChevron = UIImage(systemName: "chevron.right")
    static let search = UIImage(systemName: "magnifyingglass")
    static let logoImage = UIImage(named: "neonPurple")
    static let rectangleGrid1 = UIImage(systemName: "rectangle.grid.1x2.fill")
    static let rectangleGrid2 = UIImage(systemName: "square.grid.2x2.fill")
    static let list = UIImage(systemName: "list.dash")


}

enum Fonts {
    static let viewsLabel = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .medium))
    static let userNameLabel = UIFont.preferredFont(forTextStyle: .subheadline)
    static let emptyLabel = UIFont.preferredFont(forTextStyle: .body)
}

enum Links {
    static let pixabayMain = URL(string: "https://pixabay.com")!
}
