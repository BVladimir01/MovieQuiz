//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Vladimir on 06.12.2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private let questions: [QuizQuestion] = [
        .init(imageName: "The Godfather", questionedRating: 6, correctAnswer: true),
        .init(imageName: "The Dark Knight", questionedRating: 6, correctAnswer: true),
        .init(imageName: "Kill Bill", questionedRating: 6, correctAnswer: true),
        .init(imageName: "The Avengers", questionedRating: 6, correctAnswer: true),
        .init(imageName: "Deadpool", questionedRating: 6, correctAnswer: true),
        .init(imageName: "The Green Knight", questionedRating: 6, correctAnswer: true),
        .init(imageName: "Old", questionedRating: 6, correctAnswer: false),
        .init(imageName: "The Ice Age Adventures of Buck Wild", questionedRating: 6, correctAnswer: false),
        .init(imageName: "Tesla", questionedRating: 6, correctAnswer: false),
        .init(imageName: "Vivarium", questionedRating: 6, correctAnswer: false)
    ]
    
    func requestNextQuestion() -> QuizQuestion? {
        guard let index = (0..<questions.count).randomElement() else {
            return nil
        }
        return questions[safe: index]
    }
}
