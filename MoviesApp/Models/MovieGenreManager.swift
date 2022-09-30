//
//  MovieGenreManager.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-09-22.
//

import Foundation

struct MovieGenreManager {
    func fetchMovieGenre(with getMovieID: Int, completed: @escaping (Result<Genre, GFError>) -> Void) {
        let genreURL = Constants.startingURL + String(getMovieID) + Constants.API_KEY
        
        guard let url = URL(string:  genreURL) else {
            completed(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let safeData = data else {
                completed(.failure(.invalidData))
                return
            }
            
            guard let movieGenre = try? JSONDecoder().decode(Genre.self, from: safeData) else {
                completed(.failure(.invalidResponse))
                return
            }
            
            completed(.success(movieGenre))
        }.resume()
    }
}
