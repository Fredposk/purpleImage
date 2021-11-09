//
//  NetworkManager.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.11.21.
//

import Foundation

final class NetworkManager {


   static let shared = NetworkManager()
   private let baseURL = "https://pixabay.com/api/?key=\(APIKEY)&q="

}

extension NetworkManager {

    typealias getPicturesResult = (Result<[Picture]?, errorMessage>) -> Void

    func getPictures(for searchTerm: String, page: Int, completed: getPicturesResult) {

        let endPoint = baseURL + searchTerm.replacingOccurrences(of: " ", with: "+")

        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidSearchTerm))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in

            
            completed(.success([Picture]?))
            return
        }

        task.resume()


    }





}
