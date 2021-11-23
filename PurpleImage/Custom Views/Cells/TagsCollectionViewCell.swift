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
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .label
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.7

        return label
    }()

     var imageTag: String!


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }


    func setData(with tag: String) {
        label.text = tag
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        addSubview(label)
        backgroundColor = .secondarySystemBackground

        layer.cornerRadius = self.frame.height/2

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }


}
