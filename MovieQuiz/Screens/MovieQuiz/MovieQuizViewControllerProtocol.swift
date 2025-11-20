//
//  MovieQuizControllerProtocol.swift
//  MovieQuiz
//
//  Created by Vladimir on 10.01.2025.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func setButtons(enabled isEnabled: Bool)
    
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultViewModel)
    
    func disableImageBorder()
    func highlightImageBorder(answerIsCorrect: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
