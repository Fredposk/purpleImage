//
//  SelectedPictureVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 20.11.21.
//

import UIKit
import SafariServices

class SelectedPictureVC: UIViewController {

    var url: String!
    var views: Int!
    var user: String!
    var tags: [String]!
//    var testTags = ["Cool", "NICE", "Inter", "tasty", "delic", "banana", "grape"]
    var pageURL: String!
    var largeImageURL: String!
    var id: Int!

    let selectedImage = PiResultImageView(frame: .zero)
    lazy var likeButton = PiLikeButton(with: id)

    private let userName: UILabel = {
        let label = UILabel()
        label.textColor = .systemPurple
        label.font = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: .current)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let testSafariLink: UILabel = {
        let label = UILabel()
        label.textColor = .systemPurple
        label.font = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: .current)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "click to link"
        label.isUserInteractionEnabled = true
        return label
    }()

    var labelCollectionView: UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureView()
        downloadImage()
        configureData()
        configureCollectionView()
        configureLayouts()

    }
    


   private func configureView() {
       view.backgroundColor = .systemBackground
       view.addSubview(likeButton)
       view.addSubview(selectedImage)
       view.addSubview(userName)
       view.addSubview(likeButton)


//       MARK: safari webview
       view.addSubview(testSafariLink)
       testSafariLink.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickSafariLink)))

    }

    @objc func didClickSafariLink() {
        guard let url = URL(string: pageURL) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemPurple
        present(safariVC, animated: true)
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
        showLoadingView()
        NetworkManager.shared.downloadImage(from: url) { [weak self ] result in

            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dismissLoadingView()
            }
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





    private func configureCollectionView() {


        labelCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(labelCollectionView)
        labelCollectionView.register(TagsCollectionViewCell.self, forCellWithReuseIdentifier: TagsCollectionViewCell.ReuseID)
        labelCollectionView.translatesAutoresizingMaskIntoConstraints = false
        labelCollectionView.delegate = self
        labelCollectionView.dataSource = self

    }

    private func createLayout() -> UICollectionViewCompositionalLayout {

//        Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let item2 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        item2.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)


//        Group

        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(25)), subitems: [item, item2])

//        Section
        let section = NSCollectionLayoutSection(group: group)

        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return UICollectionViewCompositionalLayout(section: section)
    }


    private func configureLayouts() {

        NSLayoutConstraint.activate([
            selectedImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            selectedImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            selectedImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            selectedImage.heightAnchor.constraint(equalToConstant: view.frame.height/2),

            labelCollectionView.topAnchor.constraint(equalTo: selectedImage.bottomAnchor, constant: 20),
            labelCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            labelCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            labelCollectionView.heightAnchor.constraint(equalToConstant: 25),

            userName.topAnchor.constraint(equalTo: labelCollectionView.bottomAnchor, constant: 15),
            userName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            userName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            userName.heightAnchor.constraint(equalToConstant: 22),

            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.trailingAnchor.constraint(equalTo: selectedImage.trailingAnchor, constant: -10),
            likeButton.bottomAnchor.constraint(equalTo: selectedImage.bottomAnchor, constant: -10),
            likeButton.widthAnchor.constraint(equalToConstant: 30),

            testSafariLink.heightAnchor.constraint(equalToConstant: 25),
            testSafariLink.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            testSafariLink.widthAnchor.constraint(equalToConstant: 100),
            testSafariLink.centerXAnchor.constraint(equalTo: view.centerXAnchor)

        ])
    }

}

extension SelectedPictureVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = labelCollectionView.dequeueReusableCell(withReuseIdentifier: TagsCollectionViewCell.ReuseID, for: indexPath) as! TagsCollectionViewCell
        cell.setData(with: tags[indexPath.row])
        return cell
    }


    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemPurple
        present(safariVC, animated: true)
    }


}
