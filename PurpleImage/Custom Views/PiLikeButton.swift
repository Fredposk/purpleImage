//
//  PiLikeButton.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 22.11.21.
//

import UIKit

class PiLikeButton: UIImageView {

    var picID: Int!
    var isImageLiked = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(with id: Int) {
        self.picID = id
        super.init(frame: .zero)
        configure()
    }


    private func configure () {
        image = UIImage(systemName: isImageLiked ? "heart.fill" : "heart")
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = .systemPurple
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
        backgroundColor = .black.withAlphaComponent(0.05)
        

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkIfLiked)))

    }


//    TODO: save image to coredata
    @objc func checkIfLiked () {
        print("\(picID!)")
        self.isImageLiked.toggle()
        DispatchQueue.main.async {
            self.image = nil
            self.configure()
        }


    }
}
