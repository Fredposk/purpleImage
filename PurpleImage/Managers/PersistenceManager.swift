//
//  PersistenceManager.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 14.12.21.
//

import UIKit
import CoreData

class Persistence {

     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchFavourites() -> [PurpleImage]? {
        if let images = try? context.fetch(PurpleImage.fetchRequest()) {
            return images
        } else {
            return []
        }
    }

}
