//
//  SearchResultsVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.11.21.
//

import UIKit

class SearchResultsVC: UIViewController {

    private var results: String!

    var resultsCollectionView: UICollectionView!
    enum section {
        case main
    }

    var resultsCollectionDiffableData: UICollectionViewDiffableDataSource<section, Hit>!

    private var hits: [Hit] = []
    var page = 1
    var hasMorePictures = false

    init(for result: String) {
        super.init(nibName: nil, bundle: nil)
        self.results = result
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureCollectionView()
        configureDataSource()
        networkCall()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        title = results
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemPurple

    }

    private func networkCall() {
        showLoadingView()
        NetworkManager.shared.getPictures(for: results, page) { [weak self] results in
            guard let self = self else {return}
            self.dismissLoadingView()
            switch results {
            case .success(let response):
                guard response.totalHits > 0 else {
                    self.noResultsReceived()
                    return
                }
                if self.hits.count < response.totalHits { self.hasMorePictures = true}
                if self.hits.count == response.totalHits {self.hasMorePictures = false}
                let set = Set(response.hits)
                self.hits.append(contentsOf: Array(set))
                self.updateData()

            case .failure(let errorMessage):
                DispatchQueue.main.async {
                let alert = UIAlertController(title: "ERROR", message: errorMessage.rawValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    func noResultsReceived() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "No Results", message: errorMessage.noResults.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        return
    }

    func configureCollectionView() {
        resultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.configureSearchResultsLayout())
        resultsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultsCollectionView)

        NSLayoutConstraint.activate([
            resultsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            resultsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        resultsCollectionView.register(ResultsCollectionViewCell.self, forCellWithReuseIdentifier: ResultsCollectionViewCell.ReuseID)
        resultsCollectionView.delegate = self
    }

    func configureDataSource() {
        resultsCollectionDiffableData = UICollectionViewDiffableDataSource<section, Hit>(collectionView: resultsCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = self.resultsCollectionView.dequeueReusableCell(withReuseIdentifier: ResultsCollectionViewCell.ReuseID, for: indexPath)
            as? ResultsCollectionViewCell
            cell?.setResult(for: itemIdentifier)
            return cell
        })
    }

    func updateData() {
        var snapShot = NSDiffableDataSourceSnapshot<section, Hit>()
        snapShot.appendSections([.main])
        snapShot.appendItems(hits)
        resultsCollectionDiffableData.apply(snapShot)
    }
}


extension SearchResultsVC: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offsetY > contentHeight - screenHeight  {
            if hasMorePictures {
                page += 1
                networkCall()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = SelectedPictureVC()
        let chosenItem = hits[indexPath.item]
        destinationVC.url = chosenItem.largeImageURL
        destinationVC.tags = chosenItem.tagsArray
        destinationVC.user = chosenItem.user
        destinationVC.id = chosenItem.id
        destinationVC.pageURL = chosenItem.pageURL
        destinationVC.views = chosenItem.views
        destinationVC.userImageURL = chosenItem.userImageURL
        destinationVC.userProfileUrl = URL(string: "https://pixabay.com/users/\(chosenItem.user)-\(chosenItem.userId)/")!
        destinationVC.hit = chosenItem

        navigationController?.pushViewController(destinationVC, animated: true)

    }
}
