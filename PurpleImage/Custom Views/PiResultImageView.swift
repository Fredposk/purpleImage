//
//  PiSearchResultImageView.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 16.11.21.
//

import UIKit

class PiResultImageView: UIImageView {

//    private var placeholder = UIImage(systemName: "arrow.triangle.2.circlepath.camera")
    private var cache = NetworkManager.shared.cache

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
//        image = placeholder
//        placeholder?.withTintColor(.systemPurple)
        layer.borderWidth = 3
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
        clipsToBounds = true
        contentMode = .scaleAspectFill
        isUserInteractionEnabled = true
    }

//     func downloadImage(from urlString: String) {
//         let cacheKey = NSString(string: urlString)
//         if let image = cache.object(forKey: cacheKey) {
//             self.image = image
//             return
//         }
//
//        guard let url = URL(string: urlString) else {return}
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, urlResponse, error in
//            guard let self = self else {return}
//            if error != nil { return }
//
//            guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else { return }
//
//            guard let data = data else { return}
//            guard let image = UIImage(data: data) else { return }
//
//            DispatchQueue.main.async {
//                self.cache.setObject(image, forKey: cacheKey)
//                self.image = image
//            }
//        }
//        task.resume()
//    }


}
