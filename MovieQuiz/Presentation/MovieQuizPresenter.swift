//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Vladimir on 10.01.2025.
//

import UIKit

final class MovieQuizPresenter {
    
    let numQuestions = 10
    private(set) var questionIndex = 0
    var currentQuestion: QuizQuestion? = nil
    weak var viewController: MovieQuizViewController? = nil
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
    
    func yesButtonTapped() {
        guard let currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    func noButtonTapped() {
        guard let currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
}
