//
//  FavoritesViewController.swift
//  TestTaskVoio
//
//  Created by Anton on 29.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    var favoriteMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoritesMoviesTable()
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let movie = favoriteMovies[indexPath.row]
        cell.movie = movie
        cell.movieCellTitle?.text = movie.trackName
        cell.movieGenre?.text = movie.primaryGenreName
        cell.movieYear?.text = movie.releaseDate.getYear()
        guard let imageUrl = URL(string: movie.artworkUrl100) else { return cell }
        cell.movieCellImage?.setImage(from: imageUrl)
        
        cell.configure(movie: movie)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavoritesViewController: MovieTableViewCellDelegate {
    func updateFavoritesMoviesTable() {
        FavoritesManager.shared.getFavorites { movies in
            self.favoriteMovies = movies
            DispatchQueue.main.async {
                self.favoritesTableView.reloadData()
            }
        }
    }
    
    func addToFavoritesTapped(cell: MovieTableViewCell) {
        guard let indexPath = favoritesTableView.indexPath(for: cell) else { return }
        let movie = favoriteMovies[indexPath.row]
        FavoritesManager.shared.toggleFavorite(movie: movie)
        updateFavoritesMoviesTable()
    }
    
    func shareButtonTapped(cell: MovieTableViewCell) {
        guard let indexPath = favoritesTableView.indexPath(for: cell) else { return }
        let movie = favoriteMovies[indexPath.row].trackViewUrl
        shareMovieURL(urlString: movie)
    }
    
    func shareMovieURL(urlString: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: urlString) else { return }
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            DispatchQueue.main.async {
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
