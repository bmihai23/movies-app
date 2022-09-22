//
//  MoviesManager.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-06-17.
//

import Foundation

class MoviesManager {
    var isPaginating = false
    
    func fetchMovies(pagination: Bool = false, page: Int, completed: @escaping (Result<Movie, GFError>) -> Void) {
        if pagination {
            isPaginating = true
        }

        guard let url = URL(string:  Constants.moviesURL + "&page=\(page)") else {
            completed(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let safeData = data else {
                completed(.failure(.invalidData))
                return
            }
            
            guard let movies = try? JSONDecoder().decode(Movie.self, from: safeData) else {
                completed(.failure(.invalidResponse))
                return
            }
            
            completed(.success(movies))
            
            if pagination {
                self.isPaginating = false
            }
        }.resume()
    }
}
