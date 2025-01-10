//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Vladimir on 10.01.2025.
//

import XCTest
@testable import MovieQuiz


final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func setButtons(enabled isEnabled: Bool) {
        
    }
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func show(quiz result: MovieQuiz.QuizResultViewModel) {
        
    }
    
    func disableImageBorder() {
        
    }
    
    func highlightImageBorder(answerIsCorrect: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
}

class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterConvertModel() throws {
//        given
        let viewController = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewController)
        let question = QuizQuestion(image: Data(), questionedRating: 7, correctAnswer: true)
//        when
        let questionViewModel = presenter.convert(model: question)
        
        XCTAssertNotNil(questionViewModel.image)
        XCTAssertEqual(questionViewModel.question, "Рейтинг этого фильма больше чем 7?")
        XCTAssertEqual(questionViewModel.questionNumber, "1/10")
    }
}
