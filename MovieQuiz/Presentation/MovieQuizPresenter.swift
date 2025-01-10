//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Vladimir on 10.01.2025.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    let numQuestions = 10
    private(set) var questionIndex = 0
    private var userScore = 0
    var currentQuestion: QuizQuestion? = nil
    
    private weak var viewController: MovieQuizViewController? = nil
    private var questionFactory: QuestionFactoryProtocol?
    
    var isLastQuestion: Bool {
        questionIndex == numQuestions - 1
    }
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func restartGame() {
        questionIndex = 0
        userScore = 0
        questionFactory?.requestNextQuestion()
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
        didAnswer(yes: true)
    }
    
    func noButtonTapped() {
        didAnswer(yes: false)
    }
    
    private func didAnswer(yes answer: Bool) {
        guard let currentQuestion else { return }
        let correct = currentQuestion.correctAnswer ? answer : !answer
        if correct { userScore += 1}
        viewController?.showAnswerResult(isCorrect: correct)
    }
    
    func showNextQuestionOrResults() {
        if isLastQuestion {
            viewController?.statisticService.store(correct: userScore, total: numQuestions)
            let result = QuizResultViewModel(title: "Этот раунд окончен!",
                                             score: userScore,
                                             numQuestions: numQuestions,
                                             statisticService: viewController!.statisticService,
                                             buttonText: "Сыграть еще раз")
            viewController?.show(quiz: result)
        } else {
            incrementQuestionIndex()
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
            self?.viewController?.disableImageBorder()
            self?.viewController?.enableButtons()
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}
