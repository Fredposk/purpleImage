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
    var pageURL: String!
    var largeImageURL: String!
    var id: Int!

    var pictureSaved = false

    let selectedImage = PiResultImageView(frame: .zero)

    let container = UIView(frame: .zero)



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

        configureView()
        downloadImage()
//        configureData()
//        configureCollectionView()
        configureLayouts()
        configureDoubleTapAction()


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar()
    }
    


   private func configureView() {
       view.backgroundColor = .systemBackground
       view.addSubview(selectedImage)

       add(DetailsVC(totalViews: views, userName: user, userImageUrl: "todo"), to: container)

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

//        run database check to save picture
        let likeButton = UIBarButtonItem(image: UIImage(systemName: pictureSaved ? "heart.fill" : "heart" ), style: .done, target: self, action: #selector(changeSavedStatus))
        navigationItem.leftBarButtonItem = likeButton
    }

    @objc func changeSavedStatus() {
        pictureSaved.toggle()
        configureNavigationBar()
    }

    @objc func didTapDoneButton() {
        dismiss(animated: true)
    }

    private func configureDoubleTapAction() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(changeSavedStatus))
        doubleTap.numberOfTapsRequired = 2
        selectedImage.addGestureRecognizer(doubleTap)
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

    private func add(_ childVC: UIViewController, to container: UIView) {
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        addChild(childVC)
        container.addSubview(childVC.view)
        childVC.view.frame = container.bounds
        childVC.didMove(toParent: self)
    }


    private func configureLayouts() {

        NSLayoutConstraint.activate([
            selectedImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            selectedImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            selectedImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            selectedImage.heightAnchor.constraint(equalToConstant: view.frame.height/2),

            container.topAnchor.constraint(equalTo: selectedImage.bottomAnchor, constant: 5),
            container.leadingAnchor.constraint(equalTo: selectedImage.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: selectedImage.trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 90),

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
