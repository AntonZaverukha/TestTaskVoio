//
//  NetworkManager.swift
//  TestTaskVoio
//
//  Created by Anton on 29.03.2023.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private init() {}

    func searchMovies(searchText: String, completion: @escaping ([Movie]?) -> Void) {
        let url = URL(string: "https://itunes.apple.com/search?media=movie&term=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let result = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(result.results)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}

struct SearchResult: Codable {
    let results: [Movie]
}
