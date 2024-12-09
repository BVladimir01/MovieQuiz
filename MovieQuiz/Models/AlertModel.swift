//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Vladimir on 06.12.2024.
//

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let action: () -> ()
}

extension AlertModel {
    init(quizResult: QuizResultViewModel, action: @escaping () -> ()) {
        self.title = quizResult.title
        self.message = quizResult.text
        self.buttonText = quizResult.buttonText
        self.action = action
    }
}
