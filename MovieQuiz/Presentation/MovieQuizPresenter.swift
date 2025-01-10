//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Vladimir on 10.01.2025.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let numQuestions = 10
    private var questionIndex = 0
    private var userScore = 0
    private var currentQuestion: QuizQuestion? = nil
    
    private let statisticService: StatisticServiceProtocol
    private weak var viewController: MovieQuizViewController? = nil
    private var questionFactory: QuestionFactoryProtocol? = nil
    
    private var isLastQuestion: Bool {
        questionIndex == numQuestions - 1
    }
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        self.statisticService = StatisticService()
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        self.viewController?.showLoadingIndicator()
        self.viewController?.setButtons(enabled: false)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.quesion,
            questionNumber: "\(questionIndex + 1)/\(numQuestions)")
    }
    
    // MARK: - User intentions
    
    func restartGame() {
        questionIndex = 0
        userScore = 0
        questionFactory?.requestNextQuestion()
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
        viewController?.setButtons(enabled: false)
        viewController?.highlightImageBorder(answerIsCorrect: correct)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.proceedToNextQuestionOrResults()
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion {
            statisticService.store(correct: userScore, total: numQuestions)
            let resultViewModel = QuizResultViewModel(title: "Этот раунд окончен!",
                                             score: userScore,
                                             numQuestions: numQuestions,
                                             statisticService: statisticService,
                                             buttonText: "Сыграть еще раз")
            viewController?.show(quiz: resultViewModel)
        } else {
            questionIndex += 1
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
            self?.viewController?.setButtons(enabled: true)
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
