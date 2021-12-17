//
//  PersistenceManager.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 14.12.21.
//

import UIKit
import CoreData

class Persistence {

    static let shared = Persistence()

    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchFavorites(completion: (Result<[PurpleImage], errorMessage>) -> Void) {
        if let images = try? context.fetch(PurpleImage.fetchRequest()) {
            completion(.success(images))
                  return
              } else {
                  completion(.failure(errorMessage.coreDataError))
                  return
              }
    }

    // MARK: - Core Data Saving support

    private func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private func fetchRequest (for image: Hit) -> NSFetchRequest<PurpleImage> {
        let fetchRequest: NSFetchRequest<PurpleImage> = PurpleImage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", image.id)
        return fetchRequest
    }

    func isLiked(_ image: Hit) -> Bool {
        let fetchRequest = fetchRequest(for: image)
        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count > 0
    }


    func toggleLike(_ image: Hit, imageData: UIImage, userImageData: UIImage) {
        let fetchRequest = fetchRequest(for: image)
        fetchRequest.fetchLimit = 1

        let matchingItems = try? context.fetch(fetchRequest)
        if let firstItem = matchingItems?.first {
            context.delete(firstItem)
        } else {
            let newImage = PurpleImage(context: self.context)
            newImage.id = Int32(image.id)
            newImage.user = image.user
            newImage.userId = Int32(image.userId)
            newImage.userImageUrl = image.userImageURL
            newImage.views = Int32(image.views)
            newImage.largeImageURL = image.largeImageURL
            newImage.webFormatUrl = image.webformatURL
            newImage.tagsArray = image.tagsArray
            newImage.pictureData = imageData.jpegData(compressionQuality: 1.0)
            newImage.userImage = userImageData.jpegData(compressionQuality: 1.0)
            newImage.pageUrl = image.pageURL
        }
        saveContext()
    }

}
