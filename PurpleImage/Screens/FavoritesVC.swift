//
//  FavoritesVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 08.11.21.
//

import UIKit
import CoreData


enum Section {
    case main
}

class FavoritesVC: UIViewController {

    private var favourites = [PurpleImage]()
    
    var placeholderView = PiEmptyFavouritesView()

     var favouritesCollectionView: UICollectionView!

    var favouritesCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Section, PurpleImage>?


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFavourites()
        favoritesCount()
    }


    private func getFavourites() {
        Persistence.shared.fetchFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let images):
                favourites = images
                DispatchQueue.main.async {
                    self.favoritesCount()
                    self.updateData()
                }
            case .failure(let errorMessage):
                self.favoritesCount()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: errorMessage.rawValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    private func configureCollectionView() {
        favouritesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.configureSearchResultsLayout())
        view.addSubview(favouritesCollectionView)
        favouritesCollectionView.register(ResultsCollectionViewCell.self, forCellWithReuseIdentifier: ResultsCollectionViewCell.ReuseID)
    }

    private func favoritesCount() {
        if favourites.isEmpty {
            view.addSubview(placeholderView)
            placeholderView.frame = view.bounds
        } else {
            configureCollectionView()
            configureDataSource()
        }
    }

   private func configureDataSource() {
       favouritesCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, PurpleImage>(collectionView: favouritesCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
           let cell = self.favouritesCollectionView.dequeueReusableCell(withReuseIdentifier: ResultsCollectionViewCell.ReuseID, for: indexPath) as? ResultsCollectionViewCell
           cell?.setResultWithCoreDataImage(for: itemIdentifier)
           return cell
       })
    }

    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PurpleImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(favourites)
        favouritesCollectionViewDiffableDataSource?.apply(snapshot)
        
    }
}
