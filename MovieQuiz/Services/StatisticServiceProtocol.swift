//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Vladimir on 08.12.2024.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct: Int, total: Int)
}
