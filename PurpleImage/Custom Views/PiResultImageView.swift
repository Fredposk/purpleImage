//
//  PiSearchResultImageView.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 16.11.21.
//

import UIKit

class PiResultImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }





    private func configure() {

        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 3
        layer.borderColor = UIColor.label.cgColor
        clipsToBounds = true
        contentMode = .scaleAspectFill
        isUserInteractionEnabled = true
    }


}
