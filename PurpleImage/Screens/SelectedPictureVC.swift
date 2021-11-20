//
//  SelectedPictureVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 20.11.21.
//

import UIKit

class SelectedPictureVC: UIViewController {

    var url: String!

    let selectedImage = PiResultImageView(frame: .zero)


    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureView()
        downloadImage()
        configureLayouts()

    }
    


   private func configureView() {
        view.backgroundColor = .systemBackground
       view.addSubview(selectedImage)
    }

    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .systemPurple
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneButton

    }

    @objc func didTapDoneButton() {
        dismiss(animated: true)
    }

    private func downloadImage() {
        NetworkManager.shared.downloadImage(from: url) { [weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.selectedImage.image = image
            case .failure(let errorMessage):
                let alert = UIAlertController(title: "ERROR", message: errorMessage.rawValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    private func configureLayouts() {
        NSLayoutConstraint.activate([
            selectedImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            selectedImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            selectedImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5),
            selectedImage.heightAnchor.constraint(equalToConstant: view.frame.height/2)
        ])
    }


}
