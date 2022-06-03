//
//  SimilarMoviesCell.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-05-25.
//

import UIKit

class SimilarMoviesCell: UICollectionViewCell {
    
    @IBOutlet weak var similarMoviesImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    func setSimilarMovie(movie: MovieDataModel) {
        similarMoviesImage.image = UIImage(named: movie.movieImage ?? "no-image.jpeg")
        movieTitleLabel.text = movie.title
        ratingLabel.text = String(movie.rating ?? 0.0)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        favoriteButton.isSelected = !sender.isSelected
        favoriteButton.tintColor = favoriteButton.isSelected ? .systemRed : .white
    }
}
