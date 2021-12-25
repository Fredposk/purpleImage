//
//  DetailsVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 07.12.21.
//

import UIKit

protocol UserDetail: AnyObject {
    func didTapUserLink()
    func didTapPixabayLink()
}

class DetailsVC: UIViewController {

    weak var delegate: UserDetail?

    let totalViewsLabel = PiBodyLabel(textAlignment: .center, textColor: .secondaryLabel, font: Fonts.viewsLabel)
    let userNameLabel = PiBodyLabel(textAlignment: .left, textColor: .label, font: Fonts.userNameLabel)
    let userImage = PiResultImageView(frame: .zero)

    var userImageUrl: String!

    let userContainer = UIView(frame: .zero)
    let userLinkImage = UIImageView(image: Images.viewUserChevron)

    let bottomSeparator = UIView(frame: .zero)
    let topSeparator = UIView(frame: .zero)

    private let viewOnSafariLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPurple.withAlphaComponent(0.7)
        label.font = Fonts.viewsLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "View on Pixabay"
        label.isUserInteractionEnabled = true
        return label
    }()

    init(totalViews: Int, userName: String, userImageUrl: String) {
        super.init(nibName: nil, bundle: nil)
        totalViewsLabel.text = "Views: \(totalViews)"
        userNameLabel.text = "By: \(userName)"
        self.userImageUrl = userImageUrl
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureUserContainer()
        configureLayout()
        fetchUserImage()
        addClickFunctionToUser()
        addClickFunctionToSafariLink()
    }

    private func configureView() {
        view.addSubview(totalViewsLabel)
        view.addSubview(userContainer)
        view.addSubview(viewOnSafariLabel)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparator.backgroundColor = .quaternaryLabel
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.backgroundColor = .quaternaryLabel
        view.addSubview(bottomSeparator)
        view.addSubview(topSeparator)
    }

    private func configureUserContainer() {
        userContainer.translatesAutoresizingMaskIntoConstraints = false
        userLinkImage.translatesAutoresizingMaskIntoConstraints = false
        userContainer.addSubview(userImage)
        userContainer.addSubview(userNameLabel)
        userContainer.addSubview(userLinkImage)
        userLinkImage.tintColor = .label
        userContainer.isUserInteractionEnabled = true
        userImage.layer.borderWidth = 2
        userImage.layer.backgroundColor = UIColor.quaternaryLabel.cgColor
        userImage.layer.cornerRadius = 10

        NSLayoutConstraint.activate([
            topSeparator.heightAnchor.constraint(equalToConstant: 1),
            topSeparator.bottomAnchor.constraint(equalTo: userImage.topAnchor),
            topSeparator.widthAnchor.constraint(equalTo: view.widthAnchor),

            userImage.leadingAnchor.constraint(equalTo: userContainer.leadingAnchor),
            userImage.topAnchor.constraint(equalTo: userContainer.topAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 45),
            userImage.bottomAnchor.constraint(equalTo: userContainer.bottomAnchor),

            userNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            userNameLabel.centerYAnchor.constraint(equalTo: userContainer.centerYAnchor),

            userLinkImage.centerYAnchor.constraint(equalTo: userContainer.centerYAnchor),
            userLinkImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            bottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            bottomSeparator.topAnchor.constraint(equalTo: userImage.bottomAnchor),
            bottomSeparator.widthAnchor.constraint(equalTo: view.widthAnchor)

        ])
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([

            viewOnSafariLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 1),
            viewOnSafariLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewOnSafariLabel.heightAnchor.constraint(equalToConstant: 16),

            totalViewsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 1),
            totalViewsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalViewsLabel.heightAnchor.constraint(equalToConstant: 16),

            userContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userContainer.heightAnchor.constraint(equalToConstant: 45),
            userContainer.topAnchor.constraint(equalTo: totalViewsLabel.bottomAnchor, constant: 2)

        ])
    }

    private func addClickFunctionToUser() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapChevron))
        userContainer.addGestureRecognizer(tap)
    }

    private func addClickFunctionToSafariLink() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSafariLink))
        viewOnSafariLabel.addGestureRecognizer(tap)
    }

    @objc func didTapChevron() {
        delegate?.didTapUserLink()
    }

    @objc func didTapSafariLink() {
        delegate?.didTapPixabayLink()
    }

    

    private func fetchUserImage() {
        NetworkManager.shared.downloadImage(from: userImageUrl) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.userImage.image = result
                case .failure(_):
                    self.userImage.image = Images.placeHolderUser
                }
            }

        }
    }

}
