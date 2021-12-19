//
//  ResultsCollectionViewCell.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 11.11.21.
//

import UIKit

class ResultsCollectionViewCell: UICollectionViewCell {

    static let ReuseID = "ResultsCell"
    private var searchResultImage = PiResultImageView(frame: .zero)
    let contentContainer = UIView()
    
    let padding: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



     func setResultWithWebImage(for hit: Hit) {
         searchResultImage.image = nil
        NetworkManager.shared.downloadImage(from: hit.webformatURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.searchResultImage.image = result
            case .failure(_):
//                failure will keep placeholderImage
                break
            }
        }
    }

    func setResultWithCoreDataImage(for image: PurpleImage) {
        searchResultImage.image = nil
        searchResultImage.image = UIImage(data: image.pictureData!)
        searchResultImage.layer.cornerRadius = self.frame.height/6
    }

    private func configure() {

        self.addSubview(contentContainer)

        contentContainer.addSubview(searchResultImage)
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            contentContainer.topAnchor.constraint(equalTo: self.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            searchResultImage.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: padding),
            searchResultImage.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: padding),
            searchResultImage.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -padding),
            searchResultImage.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -padding),

        ])

    }

}
