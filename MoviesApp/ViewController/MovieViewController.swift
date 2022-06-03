//
//  ViewController.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-04-21.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellIdentifier = "movieCell"
    var segueIdentifier = "goToMovieDetails"
    var movieGenreIdentifier = "genreIdentifier"
    let movieCell = MovieCell()
    let movieGenreCell = MovieGenreCell()
    var items = ["1", "2", "3", "4", "5"]
    
    let movies: [MovieDataModel] = [
        MovieDataModel(movieImage: "dark_knight", title: "Fast & Furious Presents: Hobbs & Shaw", rating: 8.5, releaseDate: "25/07/2008"),
        MovieDataModel(movieImage: "spider_man", title: "Spider-Man: No Way Home", rating: 8.5, releaseDate: "25/07/2008"),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: "25/07/2008"),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: "25/07/2008"),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: "25/07/2008"),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: "25/07/2008"),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: "25/07/2008"),
        MovieDataModel(movieImage: "spider_man", title: "Spider-Man: No Way Home", rating: 8.5, releaseDate: "25/07/2008"),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: "25/07/2008"),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: "25/07/2008"),
        MovieDataModel(movieImage: "dark_knight", title: "Fast & Furious Presents: Hobbs & Shaw", rating: 8.5, releaseDate: "25/07/2008"),
        MovieDataModel(movieImage: "dark_knight", title: "The Dark Knight", rating: 8.5, releaseDate: "25/07/2008")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
    }
}

// MARK: - InitDelegateAndDataSource
extension MovieViewController {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        movieCell.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension MovieViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieCell else { fatalError("Cannot create cell!") }
        let movie = movies[indexPath.row]
        cell.setMovie(movie: movie)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MovieViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: segueIdentifier, sender: cell)
    }
}

// MARK: - MovieCellDelegate

extension MovieViewController: MovieCellDelegate {
    func didTapFavoriteButton() {
        print("show")
    }
}
