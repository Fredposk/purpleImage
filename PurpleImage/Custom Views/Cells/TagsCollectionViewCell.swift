//
//  TagsCollectionViewCell.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 21.11.21.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    static let ReuseID = "tagCell"

    private var label: String!


    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(label: String) {
        super.init(frame: .zero)
        self.label = label
        configure()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }


}
