//
//  SearchPicturesVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 08.11.21.
//

import UIKit

class SearchPicturesVC: UIViewController {

    private let logoImage: UIImageView = {
        let image = UIImageView(image: Images.logoImage)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Privacy Policy"
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        label.isUserInteractionEnabled = true
        return label
    }()

    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private let textfield = PiTextField()
    private let callToActionButton = PiButton(buttonTitle: "Search..")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureLogoImageView()
        configureTextFieldWithButtonView()
        removeKeyboard()
        callToActionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        configurePrivacyPolicyLabel()
        privacyLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPrivacyLabel)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

     func configureLogoImageView() {
        view.addSubview(logoImage)

        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 290),
            logoImage.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    func removeKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(textfield.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }

    func configureTextFieldWithButtonView() {

        view.addSubview(contentView)
        view.addSubview(callToActionButton)
        view.addSubview(textfield)
        textfield.delegate = self

        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 80),
            contentView.widthAnchor.constraint(equalToConstant: view.frame.width),
            contentView.heightAnchor.constraint(equalToConstant: view.frame.height/6),

            textfield.widthAnchor.constraint(equalToConstant: 290),
            textfield.heightAnchor.constraint(equalToConstant: 45),
            textfield.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textfield.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),

            callToActionButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            callToActionButton.heightAnchor.constraint(equalToConstant: 40),
            callToActionButton.widthAnchor.constraint(equalToConstant: 200),
            callToActionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }

    @objc func didTapActionButton() {
        guard let searchText = textfield.text, searchText.isEmpty == false else {
            let alert = UIAlertController(title: "ERROR", message: "Please enter a search term to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        let nav = SearchResultsVC(for: searchText)
        textfield.resignFirstResponder()
        textfield.text = ""
        navigationController?.pushViewController(nav, animated: true)

    }

    func configurePrivacyPolicyLabel () {
        view.addSubview(privacyLabel)

        NSLayoutConstraint.activate([
            privacyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            privacyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }

//    - TODO: go to website
    @objc func didTapPrivacyLabel() {
        print("hello")
    }

}

extension SearchPicturesVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapActionButton()
        return true
    }
}


