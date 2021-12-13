//
//  RelatedImagesCell.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 13.12.21.
//

import UIKit

class RelatedImagesCell: UICollectionViewCell {
    static let ReuseID = "RelatedCell"

    private var searchResultImage = PiResultImageView(frame: .zero)

    let contentContainer = UIView()



    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




}
