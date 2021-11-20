//
//  SelectedPictureVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 20.11.21.
//

import UIKit

class SelectedPictureVC: UIViewController {

    var url: String!



    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureView()
        downloadImage()

    }
    


   private func configureView() {
        view.backgroundColor = .systemBackground
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

    func downloadImage() {
        NetworkManager.shared.downloadImage(from: url) { [weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                print(image)
            case .failure(let errorMessage):
                let alert = UIAlertController(title: "ERROR", message: errorMessage.rawValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }

}
