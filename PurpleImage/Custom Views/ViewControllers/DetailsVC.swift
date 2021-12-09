//
//  DetailsVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 07.12.21.
//

import UIKit

protocol UserDetail: AnyObject {
    func didTapUserLink()
}

class DetailsVC: UIViewController {

    weak var delegate: UserDetail?

    let totalViewsLabel = PiBodyLabel(textAlignment: .center, textColor: .secondaryLabel, font: Fonts.viewsLabel)
    let userNameLabel = PiBodyLabel(textAlignment: .left, textColor: .label, font: Fonts.userNameLabel)
    let userImage = PiResultImageView(frame: .zero)
    var userImageUrl: String!

    let userContainer = UIView(frame: .zero)
    let userLinkImage = UIImageView(image: Images.viewUserChevron)

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
    }

    private func configureView() {

        view.addSubview(totalViewsLabel)
        view.addSubview(userContainer)
    }

    private func configureUserContainer() {
        userContainer.translatesAutoresizingMaskIntoConstraints = false
        userLinkImage.translatesAutoresizingMaskIntoConstraints = false
        userContainer.addSubview(userImage)
        userContainer.addSubview(userNameLabel)
        userContainer.addSubview(userLinkImage)
        userLinkImage.tintColor = .label
        userLinkImage.isUserInteractionEnabled = true
        userImage.layer.borderWidth = 2
        userImage.layer.backgroundColor = UIColor.quaternaryLabel.cgColor
        userImage.layer.cornerRadius = 10

        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: userContainer.leadingAnchor),
            userImage.topAnchor.constraint(equalTo: userContainer.topAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 45),
            userImage.bottomAnchor.constraint(equalTo: userContainer.bottomAnchor),

            userNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            userNameLabel.centerYAnchor.constraint(equalTo: userContainer.centerYAnchor),

            userLinkImage.centerYAnchor.constraint(equalTo: userContainer.centerYAnchor),
            userLinkImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),


        ])
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([

            totalViewsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 2),
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
        userLinkImage.addGestureRecognizer(tap)
    }

    @objc func didTapChevron() {
        delegate?.didTapUserLink()
    }

    private func fetchUserImage() {
        NetworkManager.shared.downloadImage(from: userImageUrl) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.userImage.image = result
                case .failure(_):
                    self.userImage.image = UIImage(systemName: Images.placeHolderUser)
                }
            }

        }
    }
    



}
