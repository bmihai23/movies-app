//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-05-21.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    
    var movieGenreIdentifier = "genreIdentifier"
    var similarMoviesIdentifier = "similarMoviesIdentifier"
    var genres = ["Crime", "Adventure", "Science Fiction", "Thriller", "Thriller", "Thriller", "Thriller"]
    
    let similarMovies: [MovieDataModel] = [
        MovieDataModel(movieImage: "LOTR", title: "Fast & Furious Presents: Hobbs & Shaw", rating: 8.5, releaseDate: ""),
        MovieDataModel(movieImage: "spider_man", title: "Spider-Man: No Way Home", rating: 8.5, releaseDate: ""),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: ""),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: ""),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: ""),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: ""),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
    }
}

// MARK: - InitDelegateAndDataSource

extension MovieDetailsViewController {
    func setupCollectionViews() {
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        similarMoviesCollectionView.delegate = self
        similarMoviesCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate

extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == similarMoviesCollectionView) {
            return similarMovies.count
        }
        
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == similarMoviesCollectionView) {
            guard let similarMoviesCell = similarMoviesCollectionView.dequeueReusableCell(withReuseIdentifier: similarMoviesIdentifier, for: indexPath) as? SimilarMoviesCell else { fatalError("Cannot create cell!") }
                let movie = similarMovies[indexPath.row]
                similarMoviesCell.setSimilarMovie(movie: movie)
                return similarMoviesCell
        }
        
        guard let genreCell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: movieGenreIdentifier, for: indexPath) as? MovieGenreCell else { fatalError("Cannot create cell!") }
        let movieGenre = genres[indexPath.row]
        genreCell.displayGenre(genre: movieGenre)
        return genreCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == similarMoviesCollectionView) {
            return CGSize(width: 100.0, height: 190.0)
        }

        return CGSize(width: 90.0, height: 40.0)
    }
}
