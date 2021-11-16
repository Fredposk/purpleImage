//
//  PiSearchResultImageView.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 16.11.21.
//

import UIKit

class PiSearchResultImageView: UIImageView {

    private var placeholder = UIImage(systemName: "arrow.triangle.2.circlepath.camera")

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
        image = placeholder
        layer.borderWidth = 3
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }

     func downloadImage(from urlString: String) {

        guard let url = URL(string: urlString) else {return}

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, urlResponse, error in
            guard let self = self else {return}
            if error != nil { return }

            guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else { return }

            guard let data = data else { return}
            guard let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.image = image
            }


        }
        task.resume()
    }

}
