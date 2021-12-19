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

    var favouritesTableView: UITableView!

    let segmentedControlItems = [Images.rectangleGrid1, Images.rectangleGrid2, Images.list]

    var segmentedControl: UISegmentedControl!


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSegmentedControl()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFavourites()
        configureSegmentedControlLayout()
        didChangeSegmentedControlItem(segmentedControl)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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
            configureTableView()
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

    private func configureTableView() {
        favouritesTableView = UITableView(frame: view.bounds)
        view.addSubview(favouritesTableView)
        favouritesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
        favouritesTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            favouritesTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            favouritesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favouritesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favouritesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PurpleImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(favourites)
        favouritesCollectionViewDiffableDataSource?.apply(snapshot)
        
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return favourites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        var content = cell.defaultContentConfiguration()
        content.text = favourites[indexPath.row].user
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item: PurpleImage = favourites[indexPath.item]
        pushToSelectedImageVC(item)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: PurpleImage = favourites[indexPath.row]
        pushToSelectedImageVC(item)

    }

    func pushToSelectedImageVC(_ item: PurpleImage) {
        #warning("tags array needs to be passed so that if device is online, it shows related images, otherwise it wont show anything at all")
        let hit = Hit(id: Int(item.id), pageURL: item.pageUrl ?? "", largeImageURL: item.largeImageURL ?? "", webformatURL: item.webFormatUrl ?? "", views: Int(item.views), user: item.user ?? "", userId: Int(item.userId), tags: "", userImageURL: item.userImageUrl ?? "")
        let destinationVC = SelectedPictureVC(with: hit, pictureIsFromMemory: true)

        navigationController?.pushViewController(destinationVC, animated: true)
    }


}
