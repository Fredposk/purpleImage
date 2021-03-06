//
//  FavouritesCell.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 20.12.21.
//

import UIKit

class FavouritesCell: UITableViewCell {

    static let ReUseIdentifier = "FavoriteCell"
    let avatarImageView = PiResultImageView(frame: .zero)
    var usernameLabel = PiBodyLabel(textAlignment: .left, textColor: .label, font: Fonts.userNameLabel)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with favourite: PurpleImage) {
        usernameLabel.text = favourite.user
        guard let imageData = favourite.pictureData else {
            avatarImageView.image = UIImage(systemName: "camera")
            return
        }
        avatarImageView.image = UIImage(data: imageData)
    }

    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)

        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12

        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),

            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

}
