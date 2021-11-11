//
//  NetworkManager.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 09.11.21.
//

import Foundation

final class NetworkManager {


    static let shared = NetworkManager()
    private let baseURL = "https://pixabay.com/api/?key=24258005-77fd453beb301eb32e3abf948&q="

    private init() {}

}

extension NetworkManager {

    typealias getPicturesResult = (Result<hits?, errorMessage>) -> Void

    func getPictures(for searchTerm: String, page: Int, completed: @escaping getPicturesResult) {

        let endPoint = baseURL + searchTerm.replacingOccurrences(of: " ", with: "+")
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidSearchTerm))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            if let _ = error  {
                completed(.failure(.networkingError))
            }

            guard let urlResponse = urlResponse as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completed(.failure(.invalidHTTPResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            let decoder = JSONDecoder()
            do {
                let completedResponse = try decoder.decode(hits.self, from: data)
                completed(.success(completedResponse))
            } catch {
                completed(.failure(.errorParsingData))
            }
            return
        }
        task.resume()


    }





}
