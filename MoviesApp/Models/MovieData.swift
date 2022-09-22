//
//  MovieData.swift
//  MoviesApp
//
//  Created by Mihai Bolojan on 2022-06-17.
//

struct Movie: Codable {
    let movies: [MovieData]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct MovieData: Codable {
    let title: String?
    let releaseDate: String?
    let voteAverage: Double?
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case id
    }
}

struct Genre: Codable {
    let genres: [MovieGenres]
}

struct MovieGenres: Codable {
    let movieID: Int
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case movieID = "id"
        case name
    }
}
