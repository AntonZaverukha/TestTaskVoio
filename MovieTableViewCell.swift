//
//  MovieTableViewCell.swift
//  TestTaskVoio
//
//  Created by Anton on 29.03.2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieCellTitle: UILabel!
    @IBOutlet weak var movieCellImage: UIImageView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var addToFavorites: UIButton!
    var movie: Movie?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
