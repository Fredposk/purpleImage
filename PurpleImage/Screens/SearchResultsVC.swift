//
//  SearchResultsVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.11.21.
//

import UIKit

class SearchResultsVC: UIViewController {

   private var results: String!

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
        configureNavigationBar()

        NetworkManager.shared.getPictures(for: results, page: 1) { [weak self] results in

            guard let self = self else {return}
            switch results {
            case .success(let response):
                print(response!)
            case .failure(let errorMessage):
                let alert = UIAlertController(title: "ERROR", message: errorMessage.rawValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }

    }

    private func configureNavigationBar() {
        title = results
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemPurple

    }


}
