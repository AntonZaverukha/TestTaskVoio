//
//  FavoritesViewController.swift
//  TestTaskVoio
//
//  Created by Anton on 29.03.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    var favoriteMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        
        return cell
    }
}
