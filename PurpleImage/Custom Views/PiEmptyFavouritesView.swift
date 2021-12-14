//
//  PiEmptyFavouritesView.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 14.12.21.
//

import UIKit

class PiEmptyFavouritesView: UIView {

    var logoImage = UIImageView(image: Images.logoImage)
    var label = PiBodyLabel(textAlignment: .center, textColor: .secondaryLabel, font: Fonts.emptyLabel)


    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func configure() {
        addSubview(logoImage)
        addSubview(label)
        label.text = "Start liking some pictures to show them here!"
        logoImage.translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 22),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 150),

            logoImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            logoImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 290),
            logoImage.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }


}
