//
//  MovieGenreCell.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-05-16.
//

import UIKit

class MovieGenreCell: UICollectionViewCell {
    
    @IBOutlet weak var movieGenre: UILabel!
    
    func displayMovieGenre(genre: MovieGenres) {
        movieGenre.text = genre.name ?? "no genre."
        movieGenre.textAlignment = .center
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
    }
}
