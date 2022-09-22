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
    
    var movieGenreManager = MovieGenreManager()
    var similarMoviesManager = SimilarMoviesManager()
    
    var similarMovies = [MovieData]()
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
    
    func getMovieGenre() {
        movieGenreManager.fetchMovieGenre(with: getMovieID) { result in
            switch result {
            case .success(let movieGenre):
                self.genre = movieGenre
                DispatchQueue.main.async {
                    self.genreCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func getSimilarMovies() {
        similarMoviesManager.fetchSimilarMovies(with: getMovieID) { result in
            switch result {
            case .success(let similarMovie):
                self.similarMovies = similarMovie
                DispatchQueue.main.async {
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
            guard let similarMoviesCell = similarMoviesCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.similarMoviesIdentifier, for: indexPath) as? SimilarMoviesCell else { fatalError("Cannot create cell!") }
            let movie = similarMovies[indexPath.row]
            similarMoviesCell.setSimilarMovie(from: movie)
            return similarMoviesCell
        }
        
        guard let genreCell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.movieGenreIdentifier, for: indexPath) as? MovieGenreCell else { fatalError("Cannot create cell!") }
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


extension MovieDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "testSegue", sender: indexPath)
        print("You selected cell #\(indexPath.row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.similarMoviesSegueIdentifier {
             let indexPath = sender as! IndexPath
                let movieDetailsVC = segue.destination as? MovieDetailsViewController
                            movieDetailsVC?.getMovieID = self.similarMovies[indexPath.row].id
                            movieDetailsVC?.getMovieTitle = self.similarMovies[indexPath.row].title ?? ""
                            movieDetailsVC?.getMovieRating = self.similarMovies[indexPath.row].voteAverage ?? 0.0
                            movieDetailsVC?.getMovieDescription = self.similarMovies[indexPath.row].overview ?? ""
                            // Change Date Format
                            let inputFormatter = DateFormatter()
                            inputFormatter.dateFormat = "YYYY-MM-dd"
                            let outputFormatter = DateFormatter()
                            outputFormatter.dateFormat = "MMM d, yyy"
                            guard let date = inputFormatter.date(from: self.similarMovies[indexPath.row].releaseDate ?? "00/00/0000") else {
                                return
                            }
                            let dateString = outputFormatter.string(from: date)
                            movieDetailsVC?.getMovieReleaseDate = dateString
                
                guard let path = URL(string: Constants.base_url + (self.similarMovies[indexPath.row].posterPath ?? "")) else {
                                movieDetailsVC?.movieImage.image = UIImage(named: "no-image")
                                return
                            }
                            URLSession.shared.dataTask(with: path) { (data, response, error) in
                                guard let data = data else {
                                    return
                                }
                                DispatchQueue.main.async {
                                    movieDetailsVC?.movieImage.image = UIImage(data: data)
                                }
                            }.resume()
                
                guard let path = URL(string: Constants.base_url + (self.similarMovies[indexPath.row].backdropPath ?? "")) else {
                                movieDetailsVC?.movieBanner.image = UIImage(named: "no-image")
                                return
                            }
                            URLSession.shared.dataTask(with: path) { (data, response, error) in
                                guard let data = data else {
                                    return
                                }
                                DispatchQueue.main.async {
                                    movieDetailsVC?.movieBanner.image = UIImage(data: data)
                                }
                            }.resume()
            }
        }
}
