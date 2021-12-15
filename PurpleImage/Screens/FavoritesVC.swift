//
//  FavoritesVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 08.11.21.
//

import UIKit
import CoreData

class FavoritesVC: UIViewController {

    private var favourites = [PurpleImage]()
    
    var placeholderView = PiEmptyFavouritesView()
    
    lazy var otherview = UIView(frame: view.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFavourites()
    }



    private func getFavourites() {
        Persistence.shared.fetchFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let images):
                favourites = images
                DispatchQueue.main.async {
                    self.favoritesCount()
                }
            case .failure(let errorMessage):
                DispatchQueue.main.async {
                    self.favoritesCount()
                    let alert = UIAlertController(title: "Error", message: errorMessage.rawValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    private func favoritesCount() {
        if favourites.isEmpty {
            view.addSubview(placeholderView)
            placeholderView.frame = view.bounds
        } else {
            view.backgroundColor = .systemBlue
        }
    }

}
