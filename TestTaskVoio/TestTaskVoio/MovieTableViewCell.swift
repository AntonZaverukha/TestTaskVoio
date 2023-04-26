//
//  MovieTableViewCell.swift
//  TestTaskVoio
//
//  Created by Anton on 29.03.2023.
//

import UIKit

protocol MovieTableViewCellDelegate: AnyObject {
    func addToFavoritesTapped(cell: MovieTableViewCell)
    func shareButtonTapped(cell: MovieTableViewCell)
}

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieCellTitle: UILabel!
    @IBOutlet weak var movieCellImage: UIImageView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var addToFavorites: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    weak var delegate: MovieTableViewCellDelegate?
    
    @IBAction func addToFavoritesTapped(_ sender: UIButton) {
        delegate?.addToFavoritesTapped(cell: self)
    }
    
    var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        delegate?.shareButtonTapped(cell: self)
    }
    
    func configure(movie: Movie) {
        let isFavorite = FavoritesManager.shared.isFavorite(movie: movie)
        let heartImage = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        addToFavorites?.setImage(heartImage, for: .normal)
    }
    
}
