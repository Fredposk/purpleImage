//
//  LabelsResultVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.12.21.
//

import UIKit

class LabelsResultVC: UIViewController {

    lazy var labelsCollectionView = UIImageView(frame: .zero)
    var labels: [String]!
    var relatedImages: [Hit] = []


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

    }

    private func configureCollectionView() {
        labelsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        labelsCollectionView.backgroundColor = .systemPurple
        view.addSubview(labelsCollectionView)

        NSLayoutConstraint.activate([
            labelsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            labelsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            labelsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func downloadRelatedImages() {
        showLoadingView()
//        for label in labels {

            NetworkManager.shared.getPictures(for: labels[0], 1) { [weak self] response in
                guard let self = self else { return }
                self.dismissLoadingView()
                switch response {
                case .success(let result):
                    self.relatedImages.append(contentsOf: result.hits)
                case .failure(let error):
                    print(error)
                }
            }
//        }
//        print(relatedImages)
    }
    



}
