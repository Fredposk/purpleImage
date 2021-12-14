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
    var mainImageID: Int!

    var labelCollectionViewDiffable: UICollectionViewDiffableDataSource<Section, Hit>!

    enum Section {
        case Main
    }



    init(labels: [String], mainImageID: Int) {
        super.init(nibName: nil, bundle: nil)
        self.labels = labels
        self.mainImageID = mainImageID
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionView()
        downloadRelatedImages()
        configureDataSource()
    }

    private func configureView() {

        if UITraitCollection.current.userInterfaceStyle == .dark {
            view.backgroundColor = .white.withAlphaComponent(0.50)
        } else {
            view.backgroundColor = .black.withAlphaComponent(0.50)
        }
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
        for label in labels {
            NetworkManager.shared.getPictures(for: label, 1) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let result):
                    self.relatedImages.append(contentsOf: result.hits.filter { $0.id != self.mainImageID})
                    let set = Set(self.relatedImages)
                    self.relatedImages = Array(set)
                    self.updateData()
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
        snapShot.appendItems(relatedImages)
        labelCollectionViewDiffable.apply(snapShot)
    }


}


