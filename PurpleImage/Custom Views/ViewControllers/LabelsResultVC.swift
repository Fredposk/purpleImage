//
//  LabelsResultVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.12.21.
//

import UIKit

protocol RelatedImages: AnyObject {
    func didTapRelatedImage(_ image: Hit)
}

class LabelsResultVC: UIViewController, UICollectionViewDelegate {

    var labelsCollectionView: UICollectionView!
    var labels: [String]!
    var relatedImages: [Hit] = []
    var mainImageID: Int!

    var labelCollectionViewDiffable: UICollectionViewDiffableDataSource<Section, Hit>!

    weak var delegate: RelatedImages?

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
        downloadRelatedImages()
    }
    
    private func configureCollectionView() {
        labelsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.labelsResultCollectionViewFlowLayout())
        labelsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelsCollectionView)
        labelsCollectionView.delegate = self
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
            NetworkManager.shared.getPictures(for: label, Int.random(in: 1..<4)) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.configureCollectionView()
                        self.configureDataSource()
                        self.updateData()
                    }
                    self.relatedImages.append(contentsOf: result.hits.filter { $0.id != self.mainImageID})
                    let set = Set(self.relatedImages)
                    self.relatedImages = Array(set)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapRelatedImage(relatedImages[indexPath.item])
    }

    private func configureDataSource() {
        labelCollectionViewDiffable = UICollectionViewDiffableDataSource(collectionView: labelsCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultsCollectionViewCell.ReuseID, for: indexPath) as? ResultsCollectionViewCell
            cell?.setResultWithWebImage(for: itemIdentifier)
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




