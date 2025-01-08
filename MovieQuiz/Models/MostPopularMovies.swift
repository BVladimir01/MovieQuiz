//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Vladimir on 29.12.2024.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case title = "fullTitle", rating = "imDbRating", imageURL = "image"
    }
}
