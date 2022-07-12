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
    
    weak var delegate: MovieCellDelegate?
    
    var base_url = "https://image.tmdb.org/t/p/original"
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    func setMovie(from movie: MovieData) {
        guard let path = URL(string: base_url + (movie.poster_path)) else {
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
        movieTitle.text = movie.title
        movieRating.text = String(movie.vote_average ?? 0.0)
        // Change Date Format
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "YYYY-MM-dd"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, yyy"
        guard let date = inputFormatter.date(from: movie.release_date ?? "00/00/0000") else {
            return
        }
        let dateString = outputFormatter.string(from: date)
        movieReleaseDate.text = dateString
        // Add cornerRadius to one image and a View
        movieImageView.layer.cornerRadius = 8
        favoriteButtonView.layer.cornerRadius = 6
    }
    
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        favoriteButton.isSelected = !sender.isSelected
        favoriteButton.tintColor = favoriteButton.isSelected ? .systemRed : .white
        delegate?.didTapFavoriteButton()
    }
}
