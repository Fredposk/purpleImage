//
//  PiBodyLabel.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 08.12.21.
//

import UIKit

class PiBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(textAlignment: NSTextAlignment, textColor: UIColor, font: UIFont) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.font = font
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        maximumContentSizeCategory = .accessibilityLarge
    }
}
