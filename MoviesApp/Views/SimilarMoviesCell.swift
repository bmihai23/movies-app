//
//  SimilarMoviesCell.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-05-25.
//

import UIKit

class SimilarMoviesCell: UICollectionViewCell {
    
    @IBOutlet weak var similarMovieImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteButtonView: UIView!
    
    var base_url = "https://image.tmdb.org/t/p/original"
    
    func setSimilarMovie(from movie: MovieData) {
        getMoviePoster(from: movie)
        movieTitleLabel.text = movie.title
        ratingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0.0)
        // Add cornerRadius to image and View
        similarMovieImage.layer.cornerRadius = 8
        favoriteButtonView.layer.cornerRadius = 6
    }
    
    func getMoviePoster(from movie: MovieData) {
        guard let path = URL(string: base_url + (movie.posterPath ?? "")) else {
            similarMovieImage.image = UIImage(named: "no-image")
            return
        }
        URLSession.shared.dataTask(with: path) { (data, response, error) in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                self.similarMovieImage.image = UIImage(data: data)
            }
        }.resume()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        favoriteButton.isSelected = !sender.isSelected
        favoriteButton.tintColor = favoriteButton.isSelected ? .systemRed : .white
    }
}
