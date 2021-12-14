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
    var persistence = Persistence()

    var placeholderView = PiEmptyFavouritesView()

    

    lazy var otherview = UIView(frame: view.bounds)
   

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

    }

    override func viewDidAppear(_ animated: Bool) {
        getFavourites()
    }


//    pull items from persistance and decide what view to show
    private func getFavourites() {
        guard let images = persistence.fetchFavourites() else {
            // TODO: return error message pop up
            return
        }
        favourites = images
        if favourites.isEmpty == true {
            view.addSubview(placeholderView)
            placeholderView.frame = view.bounds
        }
        else {
            otherview.backgroundColor = .green
            view.addSubview(otherview)
        }
    }

}
