//
//  DetailsVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 07.12.21.
//

import UIKit

class DetailsVC: UIViewController {

    let totalViewsLabel = UILabel()
    let shareButton = UIImageView.init(image: UIImage(systemName: "square.and.arrow.up"))
    let safariLinkButton = UIImageView.init(image: UIImage(systemName: "safari"))
    let userNameLabel = UILabel()
    let userImage = PiResultImageView(frame: .zero)

//    var buttonsStackView: UIStackView!
//    var containerStack: UIStackView!

    let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .quaternaryLabel
        return view
    }()
    

    init(totalViews: Int, userName: String, userImageUrl: String) {
        super.init(nibName: nil, bundle: nil)
        totalViewsLabel.text = "Views: \(totalViews)"
        userNameLabel.text = userName
        userImage.image = fetchUserImage()

         func fetchUserImage() -> UIImage {

             return UIImage(systemName: "person.crop.circle")!
        }
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        configureView()


    }

    private func configureView() {

        let items: [UIImageView] = [safariLinkButton, shareButton]

        for item in items {
            item.isUserInteractionEnabled = true
            item.translatesAutoresizingMaskIntoConstraints = true
            item.tintColor = .systemPurple
            view.addSubview(item)
        }
//        buttonsStackView = UIStackView(arrangedSubviews: [safariLinkButton, shareButton])
//        containerStack = UIStackView(arrangedSubviews: [totalViewsLabel, buttonsStackView])
//        buttonsStackView.backgroundColor = .blue
//        containerStack.backgroundColor = .red
//        buttonsStackView.axis = .horizontal
//
//        containerStack.axis = .horizontal
//
//        containerStack.distribution = .fillEqually
////        buttonsStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//
//        view.addSubview(containerStack)
//
//        containerStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(totalViewsLabel)
        totalViewsLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
//
//            containerStack.topAnchor.constraint(equalTo: view.topAnchor),
//            containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            containerStack.heightAnchor.constraint(equalToConstant: 24)

            totalViewsLabel.topAnchor.constraint(equalTo: view.topAnchor),
            totalViewsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalViewsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalViewsLabel.heightAnchor.constraint(equalToConstant: 22)

        ])
    }
    



}
