//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Vladimir on 06.12.2024.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
