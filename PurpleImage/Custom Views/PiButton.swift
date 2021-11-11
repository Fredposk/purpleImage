//
//  PiButton.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.11.21.
//

import UIKit

class PiButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(buttonTitle: String) {
        super.init(frame: .zero)
        self.setTitle(buttonTitle, for: .normal)

        configure()

    }

    func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 10
        layer.borderColor = UIColor.systemPurple.cgColor
        layer.borderWidth = 1
        setTitleColor(.systemBackground, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        layer.backgroundColor = UIColor.systemPurple.cgColor



    }

}
