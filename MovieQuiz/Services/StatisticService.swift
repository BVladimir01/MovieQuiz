//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Vladimir on 08.12.2024.
//

import Foundation


final class StatisticService: StatisticServiceProtocol {
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            guard let bestGameData = storage.data(forKey: Keys.bestGame.rawValue) else {
                fatalError("could not locate \(Keys.bestGame.rawValue)")
            }
            guard let returnValue = try? JSONDecoder().decode(GameResult.self, from: bestGameData) else {
                fatalError("coul not decode \(Keys.bestGame.rawValue)")
            }
            return returnValue
        }
        set {
            guard let bestGameData = try? JSONEncoder().encode(newValue) else {
                fatalError("coul not encode \(Keys.bestGame.rawValue)")
            }
            storage.set(bestGameData, forKey: Keys.bestGame.rawValue)
        }
    }
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    private var totalQuestions: Int {
        get {
            storage.integer(forKey: Keys.totalQuestions.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestions.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if gamesCount == 0 {
            fatalError("total accuracy calculation error: division by zero")
        } else {
            Double(correctAnswers)/Double(totalQuestions)
        }
    }
    
    
    func store(correct: Int, total: Int) {
        let now = Date()
        correctAnswers += correct
        totalQuestions += total
        gamesCount += 1
        let gameResult = GameResult(correct: correct, total: total, date: now)
        if gamesCount == 1 {
            bestGame = gameResult
        }
        if gameResult.isBetter(than: bestGame) {
            bestGame = gameResult
        }
    }
    
    private enum Keys: String {
        case gamesCount
        case bestGame
        case correctAnswers
        case totalQuestions
    }
    
    private let storage = UserDefaults.standard
}
