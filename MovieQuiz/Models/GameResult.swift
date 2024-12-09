//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Vladimir on 08.12.2024.
//

import Foundation

struct GameResult: Codable {
    
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetter(than other: GameResult) -> Bool {
        return (Double(correct)/Double(total)) > (Double(other.correct)/Double(other.total))
    }
}

extension GameResult: CustomStringConvertible {
    var  description: String {
        "\(correct)/\(total) (\(date.formatted(date: .numeric, time: .shortened)))"
    }
}
