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

    let textfield = PiTextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureLogoImageView()
        configureTextField()

        removeKeyboard()



    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)



    }

    func configureLogoImageView () {
        view.addSubview(logoImage)

        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 290),
            logoImage.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    func configureTextField() {
        view.addSubview(textfield)

        NSLayoutConstraint.activate([
            textfield.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textfield.widthAnchor.constraint(equalToConstant: 290),
            textfield.heightAnchor.constraint(equalToConstant: 45),
            textfield.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 50)
        ])

        textfield.delegate = self
    }

    func removeKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(textfield.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }

}


extension SearchPicturesVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true
    }
}
