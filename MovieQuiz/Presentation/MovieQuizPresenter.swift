//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Vladimir on 10.01.2025.
//

import UIKit

final class MovieQuizPresenter {
    
    private(set) var questionIndex = 0
    let numQuestions = 10
    
    var isLastQuestion: Bool {
        questionIndex == numQuestions - 1
    }
    
    func resetQuestionIndex() {
        questionIndex = 0
    }
    
    func incrementQuestionIndex() {
        questionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.quesion,
            questionNumber: "\(questionIndex + 1)/\(numQuestions)")
    }
    
    
}
