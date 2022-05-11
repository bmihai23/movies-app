//
//  MovieCustomCell.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-04-21.
//

import UIKit

protocol MovieCellDelegate {
    func addMovieToFavorite(state: Bool)
}

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    
    var delegate: MovieCellDelegate?
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    func setMovie(movie: MovieDataModel) {
        movieImageView.image = UIImage(named: movie.movieImage ?? "no-image.jpeg")
        movieTitle.text = movie.title
        movieRating.text = String(movie.rating ?? 0.0)
        movieReleaseDate.text = movie.releaseDate ?? "00/00/0000"
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        favoriteButton.isSelected = !sender.isSelected
        
        if favoriteButton.isSelected {
            print("select")
            favoriteButton.tintColor = .red
            let buttonState = favoriteButton.isSelected
            delegate?.addMovieToFavorite(state: buttonState)
            print(buttonState)
        } else {
            print("deselect")
            favoriteButton.tintColor = .white
            let buttonState = favoriteButton.isSelected
            delegate?.addMovieToFavorite(state: buttonState)
            print(buttonState)
        }
    }
}
