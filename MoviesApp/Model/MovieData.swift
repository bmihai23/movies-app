//
//  MovieData.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-06-17.
//

import Foundation
import UIKit

struct MovieResponse: Codable {
    let results: [MovieData]
}

struct GenreResponse: Codable {
    let genres: [MovieGenres]
}

struct SimilarMoviesResponse: Codable {
    let results: [SimilarMoviesData]
}

struct MovieData: Codable {
    let title: String?
    let release_date: String?
    let vote_average: Double?
    let poster_path: String
    let backdrop_path: String
    let overview: String?
    let id: Int
}

struct MovieGenres: Codable {
    let id: Int
    let name: String?
}

struct SimilarMoviesData: Codable {
    let title: String?
    let vote_average: Double?
    let poster_path: String
}
