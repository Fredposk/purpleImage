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

    var savedSegmentedControlChoice = UserDefaults.standard.integer(forKey: "choice")
    let defaults = UserDefaults.standard

    var placeholderView = PiEmptyFavouritesView()

    var favouritesCollectionView: UICollectionView!

    var favouritesCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Section, PurpleImage>?

    var favouritesTableView: UITableView!

    let segmentedControlItems = [Images.rectangleGrid1, Images.rectangleGrid2, Images.list]

    var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFavourites()
        configureSegmentedControl()
        configureSegmentedControlLayout()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }


      private func getFavourites() {
        Persistence.shared.fetchFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let images):
                self.favourites = images
                DispatchQueue.main.async {
                    self.favoritesCount()
                }
            case .failure(let errorMessage):
                self.favoritesCount()
                    let alert = UIAlertController(title: "Error", message: errorMessage.rawValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.showFromMain(alert)
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

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        favouritesCollectionView.addGestureRecognizer(gesture)
    }

    @objc func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        guard let targetIndexPath = self.favouritesCollectionView.indexPathForItem(at: sender.location(in: self.favouritesCollectionView)) else {
            return
        }
        let actionSheet = UIAlertController(title: nil, message: "Delete From Favourites?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.removeItemFromFavourite(self.favourites[targetIndexPath.row]) {
                self.favourites.remove(at: targetIndexPath.row)
                self.updateData()
            }

        }))
        present(actionSheet, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    private func configureSegmentedControl() {
        segmentedControl = UISegmentedControl(items: segmentedControlItems as [Any])
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.selectedSegmentTintColor = .systemPurple
        segmentedControl.selectedSegmentIndex = savedSegmentedControlChoice
        segmentedControl.tintColor = .label
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControlItem(_:)), for: .valueChanged)
        didChangeSegmentedControlItem(segmentedControl)
    }

    @objc func didChangeSegmentedControlItem(_ segmentedControl: UISegmentedControl) {
        updateDefault(with: segmentedControl.selectedSegmentIndex)
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

//        if favouritesCollectionView.superview != nil {favouritesCollectionView.removeFromSuperview()}
//        else if favouritesTableView.superview != nil { favouritesTableView.removeFromSuperview()}
    }

    private func updateDefault(with choice: Int) {
        defaults.set(choice, forKey: "choice")
        savedSegmentedControlChoice = choice
    }


    private func favoritesCount() {
        if favourites.isEmpty {
            view.addSubview(placeholderView)
            placeholderView.frame = view.bounds
        }
    }

   private func configureDataSource() {
       favouritesCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, PurpleImage>(collectionView: favouritesCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
           let cell = self?.favouritesCollectionView.dequeueReusableCell(withReuseIdentifier: ResultsCollectionViewCell.ReuseID, for: indexPath) as? ResultsCollectionViewCell
           cell?.setResultWithCoreDataImage(for: itemIdentifier)
           return cell
       })
       updateData()
    }

    private func configureTableView() {
        favouritesTableView = UITableView(frame: view.bounds)
        view.addSubview(favouritesTableView)
        favouritesTableView.register(FavouritesCell.self, forCellReuseIdentifier: FavouritesCell.ReUseIdentifier)
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
        favouritesTableView.translatesAutoresizingMaskIntoConstraints = false
        favouritesTableView.rowHeight = 80

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
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesCell.ReUseIdentifier, for: indexPath) as! FavouritesCell
        cell.setData(with: favourites[indexPath.row])
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


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        removeItemFromFavourite(favourites[indexPath.row]) { [weak self] in
            guard let self = self else { return }
            self.favourites.remove(at: indexPath.row)
            self.favouritesTableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    func removeItemFromFavourite(_ image: PurpleImage, completion: () -> Void) {
        Persistence.shared.deleteFromPersistence(id: image.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                completion()
            case .failure(let errorMessage):
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                    let alert = UIAlertController(title: "ERROR", message: errorMessage.rawValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    func pushToSelectedImageVC(_ item: PurpleImage) {
        let hit = Hit(id: Int(item.id), pageURL: item.pageUrl ?? "", largeImageURL: item.largeImageURL ?? "", webformatURL: item.webFormatUrl ?? "", views: Int(item.views), user: item.user ?? "", userId: Int(item.userId), tags: item.tagsArray ?? "", userImageURL: item.userImageUrl ?? "")
        let destinationVC = SelectedPictureVC(with: hit, pictureIsFromMemory: true)

        navigationController?.pushViewController(destinationVC, animated: true)
    }

}


