//
//  SearchResultImageView.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 12.11.21.
//

import UIKit

class SearchResultImageView: UIImageView {

    private var placeholder = UIImage(systemName: "arrow.triangle.2.circlepath.camera")

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
        image = placeholder
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }

}
