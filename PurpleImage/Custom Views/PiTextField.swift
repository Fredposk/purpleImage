//
//  PiTextField.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 08.11.21.
//

import UIKit

class PiTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


   private func configure() {
       translatesAutoresizingMaskIntoConstraints = false

       layer.cornerRadius = 10
       layer.borderWidth = 2
       layer.borderColor = UIColor.systemPurple.cgColor

       leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: 0))
       leftViewMode = .always

       returnKeyType = .go
       font = UIFont.preferredFont(forTextStyle: .title3)
       adjustsFontSizeToFitWidth = true
       minimumFontSize = 12
       backgroundColor = .tertiarySystemBackground
       autocorrectionType = .no
       keyboardType = .alphabet
       clearButtonMode = .whileEditing
       placeholder = "Start image Search"


    }
}
