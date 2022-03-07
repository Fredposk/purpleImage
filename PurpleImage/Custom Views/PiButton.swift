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
        layer.borderColor = CGColor(red: 52/255, green: 27/255, blue: 85/255, alpha: 1.0)
        layer.borderWidth = 1
        setTitleColor(.systemBackground, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        layer.backgroundColor = CGColor(red: 52/255, green: 27/255, blue: 85/255, alpha: 1.0)



    }

}
