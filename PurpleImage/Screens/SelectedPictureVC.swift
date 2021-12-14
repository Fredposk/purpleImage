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
    var userImageURL: String!
    var userProfileUrl: URL!

    var pictureSaved = false

    let selectedImage = PiResultImageView(frame: .zero)

    let detailsContainer = UIView(frame: .zero)
    let labelsCollectionViewContainer = UIView(frame: .zero)

//    private let viewOnSafariLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .systemPurple
//        label.font = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: .current)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "View on Pixabay"
//        label.isUserInteractionEnabled = true
//        return label
//    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        downloadImage()
        configureNavigationBar()
        configureLayouts()
        configureDoubleTapAction()
    }



   private func configureView() {
       view.backgroundColor = .systemBackground
       view.addSubview(selectedImage)

       let detailsVC = DetailsVC(totalViews: views, userName: user, userImageUrl: userImageURL)
       detailsVC.delegate = self
       add(detailsVC, to: detailsContainer)

       let labelsResultVC = LabelsResultVC(labels: tags, mainImageID: id)
       add(labelsResultVC, to: labelsCollectionViewContainer)


////       MARK: safari webview
//       view.addSubview(viewOnSafariLabel)
//       viewOnSafariLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickSafariLink)))

    }



////    -TODO: This function is being extended
//    @objc func didClickSafariLink() {
//        guard let url = URL(string: pageURL) else {
//            return
//        }
//        let safariVC = SFSafariViewController(url: url)
//        safariVC.preferredControlTintColor = .systemPurple
//        present(safariVC, animated: true)
//    }

    private func configureNavigationBar() {

         navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
         navigationController?.navigationBar.tintColor = .systemPurple
        let shareButton = UIBarButtonItem(image: UIImage(systemName: Images.shareButtonImage) , style: .done,target: self, action: #selector(didTapShareButton))


//        run database check to save picture
        let likeButton = UIBarButtonItem(image: pictureSaved ? Images.heartedImage : Images.notHeartedImage, style: .done, target: self, action: #selector(changeSavedStatus))
        navigationItem.rightBarButtonItems = [shareButton, likeButton]

    }

    @objc func changeSavedStatus() {
        pictureSaved.toggle()
        configureNavigationBar()
    }

    @objc func didTapShareButton() {
//        Change this to share image
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
        let padding: CGFloat = 5

        NSLayoutConstraint.activate([
            selectedImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            selectedImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            selectedImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            selectedImage.heightAnchor.constraint(equalToConstant: view.frame.height/2),

            detailsContainer.topAnchor.constraint(equalTo: selectedImage.bottomAnchor, constant: padding),
            detailsContainer.leadingAnchor.constraint(equalTo: selectedImage.leadingAnchor, constant: padding),
            detailsContainer.trailingAnchor.constraint(equalTo: selectedImage.trailingAnchor, constant: -padding),
            detailsContainer.heightAnchor.constraint(equalToConstant: 60),

            labelsCollectionViewContainer.topAnchor.constraint(equalTo: detailsContainer.bottomAnchor, constant: padding+5),
            labelsCollectionViewContainer.leadingAnchor.constraint(equalTo: selectedImage.leadingAnchor, constant: padding),
            labelsCollectionViewContainer.trailingAnchor.constraint(equalTo: selectedImage.trailingAnchor, constant: -padding),
            labelsCollectionViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),

//            viewOnSafariLabel.heightAnchor.constraint(equalToConstant: 25),
//            viewOnSafariLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
//            viewOnSafariLabel.widthAnchor.constraint(equalToConstant: 120),
//            viewOnSafariLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)

        ])
    }
}

extension SelectedPictureVC: UserDetail {
    
    func didTapUserLink() {
        presentSafariVC(with: userProfileUrl)
    }

    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemPurple
        present(safariVC, animated: true)
    }




}
