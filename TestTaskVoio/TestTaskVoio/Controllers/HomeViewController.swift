//
//  HomeViewController.swift
//  TestTaskVoio
//
//  Created by Anton on 29.03.2023.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var movies: [Movie] = []
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail",
           let movieDetailVC = segue.destination as? MovieDetailViewController,
           let movie = sender as? Movie {
            movieDetailVC.movie = movie
        }
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        APIManager.shared.searchMovies(searchText: searchText) { [weak self] movies in
            DispatchQueue.main.async {
                guard let movies = movies else { return }
                self?.movies = movies
                self?.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let movie = movies[indexPath.row]
        cell.movieCellTitle?.text = movie.trackName
        cell.movieGenre?.text = movie.primaryGenreName
        cell.movieYear?.text = movie.releaseDate.getYear()
        guard let imageUrl = URL(string: movie.artworkUrl100) else { return cell }
        cell.movieCellImage?.setImage(from: imageUrl)
        
        cell.configure(movie: movie)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "showMovieDetail", sender: selectedMovie)
    }
}

extension HomeViewController: MovieTableViewCellDelegate {
    func addToFavoritesTapped(cell: MovieTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let movie = movies[indexPath.row]
        FavoritesManager.shared.toggleFavorite(movie: movie)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func shareButtonTapped(cell: MovieTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let movie = movies[indexPath.row].trackViewUrl
        shareMovieURL(urlString: movie)
    }
    
    func shareMovieURL(urlString: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: urlString) else { return }
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            DispatchQueue.main.async {
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
