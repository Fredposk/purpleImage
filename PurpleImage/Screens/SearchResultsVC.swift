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

        NetworkManager.shared.getPictures(for: results, page: 1) { results in
            print(results)
        }

        
    }

    private func configureNavigationBar() {
        title = results
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemPurple

        
    }


}
