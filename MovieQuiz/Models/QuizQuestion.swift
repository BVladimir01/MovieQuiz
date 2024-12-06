//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Vladimir on 06.12.2024.
//

 struct QuizQuestion {
    let imageName: String
    let questionedRating: Int
    let correctAnswer: Bool
    var quesion: String {
        "Рейтинг этого фильма больше чем \(questionedRating)?"
    }
}
