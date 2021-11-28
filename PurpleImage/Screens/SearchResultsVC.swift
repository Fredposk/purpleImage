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
                if self.hits.count < response.totalHits { self.hasMorePictures = true}
                self.hits.append(contentsOf: response.hits)
                self.updateData()
            case .failure(let errorMessage):
                let alert = UIAlertController(title: "ERROR", message: errorMessage.rawValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }

    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
//        items
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//        group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5)), subitem: item, count: 2)
//        section
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)

    }

    func configureCollectionView() {
        resultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
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

        DispatchQueue.main.async {
            self.resultsCollectionDiffableData.apply(snapShot)
        }
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
        destinationVC.modalPresentationStyle = .pageSheet

        let nav = UINavigationController(rootViewController: destinationVC)
        present(nav, animated: true)

    }
}
