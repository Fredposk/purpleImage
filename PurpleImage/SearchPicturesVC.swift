//
//  SearchPicturesVC.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 08.11.21.
//

import UIKit

class SearchPicturesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = .systemPink
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    


}
