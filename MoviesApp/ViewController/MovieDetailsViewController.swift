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
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieBanner: UIImageView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieDescription: UILabel!
    
    var movieGenreIdentifier = "genreIdentifier"
    var similarMoviesIdentifier = "similarMoviesIdentifier"
    
    var moviesManager = MoviesManager()
    var similarMovies = [MovieData(title: "asf", release_date: "Mar 2, 1999", vote_average: 7.8, poster_path: "agag", backdrop_path: "fasf", overview: "asdfasf", id: 102312),
                         MovieData(title: "asf", release_date: "Mar 2, 1999", vote_average: 7.8, poster_path: "agag", backdrop_path: "fasf", overview: "asdfasf", id: 102312),
    ]
    //var similarMovies: [MovieData] = []
    var genre: [MovieGenres] = []
    
    var getMovieTitle: String = ""
    var getMovieReleaseDate: String = ""
    var getMovieRating: Double = 0.0
    var getMovieDescription: String = ""
    var getMovieID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        setMovieDetails()
        getMovieGenre()
        getSimilarMovies()
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
    
    func setMovieDetails() {
        movieTitle.text = getMovieTitle
        movieReleaseDate.text = getMovieReleaseDate
        movieRating.text = String(getMovieRating)
        movieDescription.text = getMovieDescription
        // Add cornerRadius to two images
        movieImage.layer.cornerRadius = 8
        movieBanner.layer.cornerRadius = 8
    }
    
    func fetchGenreAPI(completed: @escaping (Result<[MovieGenres], GFError>) -> Void) {
        let genreURL = "https://api.themoviedb.org/3/movie/" + String(getMovieID) + "?api_key=2f4e33cd29709824b1711f8d8e47d269"

        guard let url = URL(string:  genreURL) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let safeData = data else {
                completed(.failure(.invalidData))
                return
            }
            
            guard let movie = try? JSONDecoder().decode(GenreResponse.self, from: safeData) else {
                completed(.failure(.invalidResponse))
                return
            }
            
            completed(.success(movie.genres))
        }
        
        task.resume()
    }
    
    func getMovieGenre() {
        fetchGenreAPI { result in
            switch result {
            case .success(let movieGenre):
                DispatchQueue.main.async {
                    self.genre = movieGenre
                    self.genreCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func getSimilarMovies() {
        moviesManager.fetchAPI { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.similarMovies = movies
                    self.similarMoviesCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == similarMoviesCollectionView) {
            return similarMovies.count
        }
        
        return genre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == similarMoviesCollectionView) {
            guard let similarMoviesCell = similarMoviesCollectionView.dequeueReusableCell(withReuseIdentifier: similarMoviesIdentifier, for: indexPath) as? SimilarMoviesCell else { fatalError("Cannot create cell!") }
            let movie = similarMovies[indexPath.row]
            similarMoviesCell.setSimilarMovie(movie: movie)
            return similarMoviesCell
        }
        
        guard let genreCell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: movieGenreIdentifier, for: indexPath) as? MovieGenreCell else { fatalError("Cannot create cell!") }
        let movieGenre = genre[indexPath.row]
        genreCell.displayMovieGenre(genre: movieGenre)
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
