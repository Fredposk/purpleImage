//
//  ResultsCollectionViewCell.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 11.11.21.
//

import UIKit

class ResultsCollectionViewCell: UICollectionViewCell {

    static let ReuseID = "ResultsCell"
    private var searchResultImage = PiSearchResultImageView(frame: .zero)


    private var views: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let padding: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setResult(for hit: Hit) {
        views.text = "Views: \(hit.views)"
        searchResultImage.downloadImage(from: hit.largeImageURL)
    }


    private func configure() {

        addSubview(searchResultImage)
        addSubview(views)

        NSLayoutConstraint.activate([
            searchResultImage.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            searchResultImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            searchResultImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            searchResultImage.heightAnchor.constraint(equalTo: searchResultImage.widthAnchor),

            views.topAnchor.constraint(equalTo: searchResultImage.bottomAnchor, constant: 2),
            views.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            views.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            views.heightAnchor.constraint(equalToConstant: 20)

        ])

    }

}
