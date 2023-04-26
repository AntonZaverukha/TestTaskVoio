//
//  FavoritesManager.swift
//  TestTaskVoio
//
//  Created by Anton on 30.03.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {}
    
    private var favoriteMovies: [Movie] = []
    private let db = Firestore.firestore()
    
    func toggleFavorite(movie: Movie) {
        guard let user = Auth.auth().currentUser else { return }
        let movieRef = db.collection("users").document(user.uid).collection("favorites").document(movie.trackName)
        
        if let index = favoriteMovies.firstIndex(where: { $0.trackName == movie.trackName }) {
            favoriteMovies.remove(at: index)
            movieRef.delete()
        } else {
            favoriteMovies.append(movie)
            movieRef.setData([
                "trackName": movie.trackName,
                "artworkUrl100": movie.artworkUrl100,
                "releaseDate": movie.releaseDate,
                "primaryGenreName": movie.primaryGenreName,
                "longDescription": movie.longDescription,
                "trackViewUrl": movie.trackViewUrl
            ])
        }
    }
    
    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovies.contains(where: { $0.trackName == movie.trackName })
    }
    
    func getFavorites(completion: @escaping ([Movie]) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection("users").document(user.uid).collection("favorites").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting favorites: \(error)")
                completion([])
            } else {
                self.favoriteMovies = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    return Movie(trackName: data["trackName"] as? String ?? "",
                                 artworkUrl100: data["artworkUrl100"] as? String ?? "",
                                 releaseDate: data["releaseDate"] as? String ?? "",
                                 primaryGenreName: data["primaryGenreName"] as? String ?? "",
                                 longDescription: data["longDescription"] as? String ?? "", trackViewUrl: data["trackViewUrl"] as? String ?? "")
                } ?? []
                completion(self.favoriteMovies)
            }
        }
    }
}
