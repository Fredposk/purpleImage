//
//  SearchPicturesVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 08.11.21.
//

import UIKit

class SearchPicturesVC: UIViewController {


    private let logoImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "purple"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoImage)

        view.backgroundColor = .systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoImage.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    


}
