//
//  ResultsCollectionViewCell.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 11.11.21.
//

import UIKit

class ResultsCollectionViewCell: UICollectionViewCell {

    static let ReuseID = "ResultsCell"
    private var image = SearchResultImageView(frame: .zero)


    private var views: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let padding: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setResult(for hit: Hit) {
        views.text = "\(hit.views)"

    }


    private func configure() {
        
        addSubview(image)
        addSubview(views)

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),

            views.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 2),
            views.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            views.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            views.heightAnchor.constraint(equalToConstant: 20)

        ])

    }

}
