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

    


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setResult(for hit: Hit) {

    }


    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        

    }

}
