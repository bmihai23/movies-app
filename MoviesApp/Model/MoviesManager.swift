//
//  MoviesManager.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-06-17.
//

import Foundation

struct MoviesManager {
    let moviesURL = "https://api.themoviedb.org/3/discover/movie?api_key=2f4e33cd29709824b1711f8d8e47d269"
    
    func fetchAPI(completed: @escaping (Result<[MovieData], GFError>) -> Void) {
        guard let url = URL(string:  moviesURL) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let safeData = data else {
                completed(.failure(.invalidData))
                return
            }
            
            guard let movies = try? JSONDecoder().decode(MovieResponse.self, from: safeData) else {
                completed(.failure(.invalidResponse))
                return
            }
            
            completed(.success(movies.results))
        }
        
        task.resume()
    }
}
