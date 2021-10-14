//
//  Model.swift
//  Cinema
//
//  Created by Глеб Шевченко on 27.09.2021.
//

import Foundation

struct MoviesResponse: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]
}

struct Movie: Codable, Hashable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let releaseDate: Date
    let voteAverage: Double
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath ?? "")")!
    }
    
    var voteAveragePercentText: String {
        return "\(Int(voteAverage * 10))%"
    }
    
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
