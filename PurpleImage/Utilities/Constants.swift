//
//  Constants.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 08.12.21.
//

import UIKit


enum Images {
    static let shareButtonImage = "square.and.arrow.up"
    static let safariButtonImage = "safari"
    static let heartedImage = UIImage(systemName: "heart.fill")
    static let notHeartedImage = UIImage(systemName: "heart")
    static let placeHolderUser = "person.circle.fill"
    static let viewUserChevron = UIImage(systemName: "chevron.right")
    static let search = UIImage(systemName: "magnifyingglass")
    static let logoImage = UIImage(named: "purple")
}

enum Fonts {
    static let viewsLabel = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .medium))
    static let userNameLabel = UIFont.preferredFont(forTextStyle: .subheadline)
    static let emptyLabel = UIFont.preferredFont(forTextStyle: .body)
}
