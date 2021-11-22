//
//  TagsCollectionViewCell.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 21.11.21.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    static let ReuseID = "tagCell"

    private var label: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .white

        return label
    }()

    private var imageTag: String!


    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(with tag: String) {
        super.init(frame: .zero)
        self.imageTag = tag
        label.text = tag
        configure()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        addSubview(label)

        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = self.frame.height/2
        backgroundColor = .black

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }


}
