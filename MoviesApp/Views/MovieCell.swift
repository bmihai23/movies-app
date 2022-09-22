//
//  MovieCustomCell.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-04-21.
//

import UIKit

protocol MovieCellDelegate : AnyObject {
    func didTapFavoriteButton()
}

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var favoriteButtonView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    weak var delegate: MovieCellDelegate?
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    func setMovie(from movie: MovieData) {
        getMoviePoster(from: movie)
        movieTitle.text = movie.title
        movieRating.text = String(movie.voteAverage ?? 0.0)
        changeDateFormat(from: movie)
        // Add cornerRadius to one image and a View
        movieImageView.layer.cornerRadius = 8
        favoriteButtonView.layer.cornerRadius = 6
    }
    
    func getMoviePoster(from movie: MovieData) {
        guard let path = URL(string: Constants.base_url + (movie.posterPath ?? "")) else {
            movieImageView.image = UIImage(named: "no-image")
            return
        }
        
        URLSession.shared.dataTask(with: path) { (data, response, error) in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                self.movieImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    func changeDateFormat(from movie: MovieData) {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "YYYY-MM-dd"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, yyy"
        guard let date = inputFormatter.date(from: movie.releaseDate ?? "00/00/0000") else {
            return
        }
        let dateString = outputFormatter.string(from: date)
        movieReleaseDate.text = dateString
    }
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        favoriteButton.isSelected = !sender.isSelected
        favoriteButton.tintColor = favoriteButton.isSelected ? .systemRed : .white
        delegate?.didTapFavoriteButton()
    }
}
