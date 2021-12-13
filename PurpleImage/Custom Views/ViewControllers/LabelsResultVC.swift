//
//  LabelsResultVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.12.21.
//

import UIKit



class LabelsResultVC: UIViewController {

    var labelsCollectionView: UICollectionView!
    var labels: [String]!
    var relatedImages: [Hit] = []

    var labelCollectionViewDiffable: UICollectionViewDiffableDataSource<Section, Hit>!

    enum Section {
        case Main
    }



    init(labels: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.labels = labels
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        downloadRelatedImages()
        configureDataSource()
    }

    private func configureCollectionView() {
        labelsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.labelsResultCollectionViewFlowLayout())
        labelsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelsCollectionView)

        labelsCollectionView.register(ResultsCollectionViewCell.self, forCellWithReuseIdentifier: ResultsCollectionViewCell.ReuseID)

        NSLayoutConstraint.activate([
            labelsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            labelsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            labelsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func downloadRelatedImages() {
//        showLoadingView()
        for label in labels {
            NetworkManager.shared.getPictures(for: label, 1) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let result):
                    self.relatedImages.append(contentsOf: result.hits)
                    self.updateData()
//                    self.dismissLoadingView()
                case .failure(let error):
                    print(error)
                }
            }
        }

    }

    private func configureDataSource() {
        labelCollectionViewDiffable = UICollectionViewDiffableDataSource(collectionView: labelsCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultsCollectionViewCell.ReuseID, for: indexPath) as? ResultsCollectionViewCell
            cell?.setResult(for: itemIdentifier)
            return cell
        })
    }

    private func updateData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Hit>()
        snapShot.appendSections([.Main])
        relatedImages.shuffle()
        snapShot.appendItems(relatedImages)
        labelCollectionViewDiffable.apply(snapShot)
    }
    



}


