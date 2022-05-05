//
//  MovieCustomCell.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-04-21.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    
    func setMovie(movie: MovieDataModel) {
        movieImageView.image = UIImage(named: movie.movieImage ?? "no-image.jpeg")
        movieTitle.text = movie.title
        movieRating.text = String(movie.rating ?? 0.0)
        movieReleaseDate.text = movie.releaseDate ?? "00/00/0000"
    }
}
