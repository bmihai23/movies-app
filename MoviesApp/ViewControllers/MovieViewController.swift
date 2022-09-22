//
//  ViewController.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-04-21.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var moviesManager = MoviesManager()
    var movies = [MovieData]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getMoviesFromAPI(pagination: true, page: currentPage)
    }
}

// MARK: - InitDelegateAndDataSource

extension MovieViewController {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getMoviesFromAPI(pagination: Bool, page: Int) {
        moviesManager.fetchMovies(pagination: true, page: currentPage) { result in
            switch result {
            case .success(let movieResponse):
                self.movies.append(contentsOf: movieResponse.movies)
                DispatchQueue.main.async {
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
        if indexPath.row < movies.count - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? MovieCell else { fatalError("Cannot create cell!") }
            let movie = movies[indexPath.row]
            cell.setMovie(from: movie)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingCell, for: indexPath) as? MovieCell else { fatalError("Cannot create cell!") }
            cell.spinner.startAnimating()
            
            return cell
        }
    }
}

// MARK: - UIScrollViewDelegate

extension MovieViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let distanceToBottom = tableView.contentSize.height - 100 - scrollView.frame.size.height
        
        if offsetY > distanceToBottom {
            guard !moviesManager.isPaginating else {
                return
            }
            
            currentPage += 1
            getMoviesFromAPI(pagination: true, page: currentPage)
        }
    }
}

// MARK: - UITableViewDelegate

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.segueIdentifier, sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        print("You selected cell #\(indexPath.row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow { 
            let movieDetailsVC = segue.destination as? MovieDetailsViewController
            sendMovieDetails(movieDetailsVC: movieDetailsVC, indexPath: indexPath)
            sendChangedDateFormat(movieDetailsVC: movieDetailsVC, indexPath: indexPath)
            sendMoviePoster(movieDetailsVC: movieDetailsVC, indexPath: indexPath)
            sendMovieBanner(movieDetailsVC: movieDetailsVC, indexPath: indexPath)
        }
        
        func sendMovieDetails(movieDetailsVC: MovieDetailsViewController?, indexPath: IndexPath) {
            movieDetailsVC?.getMovieID = self.movies[indexPath.row].id
            movieDetailsVC?.getMovieTitle = self.movies[indexPath.row].title ?? ""
            movieDetailsVC?.getMovieRating = self.movies[indexPath.row].voteAverage ?? 0.0
            movieDetailsVC?.getMovieDescription = self.movies[indexPath.row].overview ?? ""
        }
        
        func sendChangedDateFormat(movieDetailsVC: MovieDetailsViewController?, indexPath: IndexPath) {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "YYYY-MM-dd"
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM d, yyy"
            guard let date = inputFormatter.date(from: self.movies[indexPath.row].releaseDate ?? "00/00/0000") else {
                return
            }
            let dateString = outputFormatter.string(from: date)
            movieDetailsVC?.getMovieReleaseDate = dateString
        }
        
        func sendMoviePoster(movieDetailsVC: MovieDetailsViewController?, indexPath: IndexPath) {
            guard let path = URL(string: Constants.base_url + (self.movies[indexPath.row].posterPath ?? "")) else {
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
        }
        
        func sendMovieBanner(movieDetailsVC: MovieDetailsViewController?, indexPath: IndexPath) {
            guard let path = URL(string: Constants.base_url + (self.movies[indexPath.row].backdropPath ?? "")) else {
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
