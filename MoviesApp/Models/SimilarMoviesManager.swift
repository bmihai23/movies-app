//
//  SimilarMoviesManager.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-09-22.
//

import Foundation

struct SimilarMoviesManager {
    func fetchSimilarMovies(with getMovieID: Int, completed: @escaping (Result<Movie, GFError>) -> Void) {
        let similarMoviesURL = Constants.startingURL + String(getMovieID) + "/similar" + Constants.API_KEY + "&language=en-US&page=1"
        
        guard let url = URL(string:  similarMoviesURL) else {
            completed(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let safeData = data else {
                completed(.failure(.invalidData))
                return
            }
            
            guard let similarMovie = try? JSONDecoder().decode(Movie.self, from: safeData) else {
                completed(.failure(.invalidResponse))
                return
            }
            
            completed(.success(similarMovie))
        }.resume()
    }
}
