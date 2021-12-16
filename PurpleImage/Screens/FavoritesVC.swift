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

class FavoritesVC: UIViewController, UICollectionViewDelegate {


    private var favourites = [PurpleImage]()
    
    var placeholderView = PiEmptyFavouritesView()

    var favouritesCollectionView: UICollectionView!

    var favouritesCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Section, PurpleImage>?

    let segmentedControlItems = [Images.rectangleGrid1, Images.rectangleGrid2, Images.list]

    var segmentedControl: UISegmentedControl!


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
        getFavourites()
        configureSegmentedControl()
        configureSegmentedControlLayout()
        didChangeSegmentedControlItem(segmentedControl)
    }


     @objc func getFavourites() {
        Persistence.shared.fetchFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let images):
                favourites = images
                DispatchQueue.main.async {
                    self.favoritesCount()

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

    private func configureSegmentedControlLayout() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }

    private func configureCollectionView(with compositionalLayout: UICollectionViewCompositionalLayout) {
        favouritesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        favouritesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favouritesCollectionView)
        favouritesCollectionView.register(ResultsCollectionViewCell.self, forCellWithReuseIdentifier: ResultsCollectionViewCell.ReuseID)
        favouritesCollectionView.delegate = self

        NSLayoutConstraint.activate([
            favouritesCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            favouritesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favouritesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favouritesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        configureDataSource()

    }

    private func configureSegmentedControl() {
        segmentedControl = UISegmentedControl(items: segmentedControlItems as [Any])
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.selectedSegmentTintColor = .systemPurple
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .label

        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControlItem(_:)), for: .valueChanged)

    }

    @objc func didChangeSegmentedControlItem(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            configureCollectionView(with: UIHelper.likedImagesRectangleCompositionalLayout())
        case 1:
            configureCollectionView(with: UIHelper.likedImagesGridCompositionalLayout())
        case 2:
            print("2")
        default:
            configureCollectionView(with: UIHelper.likedImagesRectangleCompositionalLayout())
        }
    }

    private func favoritesCount() {
        if favourites.isEmpty {
            view.addSubview(placeholderView)
            placeholderView.frame = view.bounds
        }
    }

   private func configureDataSource() {
       favouritesCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, PurpleImage>(collectionView: favouritesCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
           let cell = self.favouritesCollectionView.dequeueReusableCell(withReuseIdentifier: ResultsCollectionViewCell.ReuseID, for: indexPath) as? ResultsCollectionViewCell
           cell?.setResultWithCoreDataImage(for: itemIdentifier)
           return cell
       })
       updateData()
    }

    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PurpleImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(favourites)
        favouritesCollectionViewDiffableDataSource?.apply(snapshot)
        
    }
}
