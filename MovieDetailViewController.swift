//
//  MovieDetailViewController.swift
//  TestTaskVoio
//
//  Created by Anton on 29.03.2023.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieDetailName: UILabel!
    @IBOutlet weak var movieDetailImage: UIImageView!
    @IBOutlet weak var movieDetailTextView: UITextView!
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        guard let movie = movie else { return }
        DispatchQueue.main.async {
            self.movieDetailName.text = movie.trackName
            self.movieDetailTextView.text = movie.longDescription
            guard let imageUrl = URL(string: movie.artworkUrl100) else { return }
            self.movieDetailImage.setImage(from: imageUrl)
        }
    }
}
