//
//  SelectedPictureVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 20.11.21.
//

import UIKit
import SafariServices

class SelectedPictureVC: UIViewController {

    var hit: Hit!
    var pictureIsFromMemory: Bool!

    let selectedImage = PiResultImageView(frame: .zero)

    let detailsContainer = UIView(frame: .zero)
    let labelsCollectionViewContainer = UIView(frame: .zero)

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(with hit: Hit, pictureIsFromMemory: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.hit = hit
        self.pictureIsFromMemory = pictureIsFromMemory
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage()
        configureView()
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

       let detailsVC = DetailsVC(totalViews: hit.views, userName: hit.user, userImageUrl: hit.userImageURL)
       detailsVC.delegate = self
       add(detailsVC, to: detailsContainer)

       let labelsResultVC = LabelsResultVC(labels: hit.tagsArray, mainImageID: hit.id)
       labelsResultVC.delegate = self
       add(labelsResultVC, to: labelsCollectionViewContainer)
    }

    private func configureNavigationBar() {

         navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
         navigationController?.navigationBar.tintColor = .systemPurple
        let shareButton = UIBarButtonItem(image: UIImage(systemName: Images.shareButtonImage) , style: .done,target: self, action: #selector(didTapShareButton))

        let likeButton = UIBarButtonItem(image: Persistence.shared.isLiked(hit) ? Images.heartedImage : Images.notHeartedImage, style: .done, target: self, action: #selector(changeSavedStatus))
        navigationItem.rightBarButtonItems = [shareButton, likeButton]

    }

    @objc func changeSavedStatus() {
        Persistence.shared.toggleLike(hit, imageData: selectedImage.image!, userImageData: Images.heartedImage!)
        configureNavigationBar()
    }

    @objc func didTapShareButton() {
        let items: [Any] = [selectedImage.image!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)

        present(ac, animated: true)
    }

    private func configureDoubleTapAction() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(changeSavedStatus))
        doubleTap.numberOfTapsRequired = 2
        selectedImage.addGestureRecognizer(doubleTap)
    }

    private func downloadImage() {
        showLoadingView()
        if pictureIsFromMemory == false {
        NetworkManager.shared.downloadImage(from: hit.largeImageURL) { [weak self ] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dismissLoadingView()
            }
            switch result {
            case .success(let image):
                self.selectedImage.image = image
            case .failure(let errorMessage):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "ERROR", message: errorMessage.rawValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
        else {
            Persistence.shared.useCoreDataImage(hit) { [weak self] result in
                guard let self = self else { return }
                self.dismissLoadingView()
                switch result {
                case .success(let result):
                    self.selectedImage.image = result
                    print("success from coredata")
                case .failure(let error):
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "ERROR", message: error.rawValue, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
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

        ])
    }
}

extension SelectedPictureVC: UserDetail, RelatedImages {


    func didTapRelatedImage(_ image: Hit) {
        let destinationVC = SelectedPictureVC(with: image, pictureIsFromMemory: false)

        navigationController?.pushViewController(destinationVC, animated: true)
    }

    func didTapUserLink() {
        let userProfileUrl = URL(string: "https://pixabay.com/users/\(hit.user)-\(hit.userId)/")!
        presentSafariVC(with: userProfileUrl)
    }

    func didTapPixabayLink() {
        presentSafariVC(with: URL(string: hit.pageURL) ?? Links.pixabayMain)
    }

    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemPurple
        present(safariVC, animated: true)
    }


}
