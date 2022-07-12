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
    var base_url = "https://image.tmdb.org/t/p/original"
    var moviesManager = MoviesManager()
    var movies = [MovieData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getMovieDetails()
    }
}

// MARK: - InitDelegateAndDataSource

extension MovieViewController {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getMovieDetails() {
        moviesManager.fetchAPI { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.movies = movies
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
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
        cell.setMovie(from: movie)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: segueIdentifier, sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        print("You selected cell #\(indexPath.row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let movieDetailsVC = segue.destination as? MovieDetailsViewController
            movieDetailsVC?.getMovieID = self.movies[indexPath.row].id
            movieDetailsVC?.getMovieTitle = self.movies[indexPath.row].title ?? ""
            movieDetailsVC?.getMovieRating = self.movies[indexPath.row].vote_average ?? 0.0
            movieDetailsVC?.getMovieDescription = self.movies[indexPath.row].overview ?? ""
            // Change Date Format
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "YYYY-MM-dd"
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM d, yyy"
            guard let date = inputFormatter.date(from: self.movies[indexPath.row].release_date ?? "00/00/0000") else {
                return
            }
            let dateString = outputFormatter.string(from: date)
            movieDetailsVC?.getMovieReleaseDate = dateString
            
            guard let path = URL(string: base_url + self.movies[indexPath.row].poster_path) else {
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
            
            guard let path = URL(string: base_url + self.movies[indexPath.row].backdrop_path) else {
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
