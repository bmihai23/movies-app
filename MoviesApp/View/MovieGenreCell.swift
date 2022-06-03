//
//  MovieGenreCell.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-05-16.
//

import UIKit

protocol MovieDetailsCellDelegate : AnyObject {
    func displayGenre()
}

class MovieGenreCell: UICollectionViewCell {
    
    @IBOutlet weak var movieGenre: UILabel!
    
    weak var delegate: MovieDetailsCellDelegate?
    
    func displayGenre(genre: String) {
        movieGenre.text = genre
        movieGenre.textAlignment = .center
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
    }
}
