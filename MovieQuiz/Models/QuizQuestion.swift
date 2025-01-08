//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Vladimir on 06.12.2024.
//

import Foundation

 struct QuizQuestion {
    let image: Data
    let questionedRating: Int
    let correctAnswer: Bool
    var quesion: String {
        "Рейтинг этого фильма больше чем \(questionedRating)?"
    }
}
