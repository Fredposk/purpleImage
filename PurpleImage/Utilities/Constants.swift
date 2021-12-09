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
    static let heartedImage = "heart.fill"
    static let notHeartedImage = "heart"
    static let placeHolderUser = "person.circle.fill"
    static let viewUserChevron = UIImage(systemName: "chevron.right")
}

enum Fonts {
    static let viewsLabel = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 14, weight: .medium))
    static let userNameLabel = UIFont.preferredFont(forTextStyle: .subheadline)
}
