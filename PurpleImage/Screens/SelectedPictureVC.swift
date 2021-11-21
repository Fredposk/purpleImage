//
//  SelectedPictureVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 20.11.21.
//

import UIKit

class SelectedPictureVC: UIViewController {

    var url: String!
    var views: Int!
    var user: String!
    var tags: [String]!
    var pageURL: String!
    var largeImageURL: String!

    let selectedImage = PiResultImageView(frame: .zero)

    private let userName: UILabel = {
        let label = UILabel()
        label.textColor = .systemPurple
        label.font = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: .current)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var labelCollectionView: UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureView()
        downloadImage()
        configureData()
        configureLayouts()

    }
    


   private func configureView() {
       view.backgroundColor = .systemBackground
       view.addSubview(selectedImage)
       view.addSubview(userName)
       
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

    private func configureData() {
        userName.text = user
    }
    private func configureLayouts() {
        NSLayoutConstraint.activate([
            selectedImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            selectedImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            selectedImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            selectedImage.heightAnchor.constraint(equalToConstant: view.frame.height/2),

            userName.topAnchor.constraint(equalTo: selectedImage.bottomAnchor, constant: 40),
            userName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            userName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            userName.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

}
