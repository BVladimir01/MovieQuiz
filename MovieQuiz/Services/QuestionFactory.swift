//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Vladimir on 06.12.2024.
//

import Foundation

//class MockQuestionFactory: QuestionFactoryProtocol {
//    
//    weak var delegate: QuestionFactoryDelegate?
//    
//    private let questions: [QuizQuestion] = [
//        .init(imageName: "The Godfather", questionedRating: 6, correctAnswer: true),
//        .init(imageName: "The Dark Knight", questionedRating: 6, correctAnswer: true),
//        .init(imageName: "Kill Bill", questionedRating: 6, correctAnswer: true),
//        .init(imageName: "The Avengers", questionedRating: 6, correctAnswer: true),
//        .init(imageName: "Deadpool", questionedRating: 6, correctAnswer: true),
//        .init(imageName: "The Green Knight", questionedRating: 6, correctAnswer: true),
//        .init(imageName: "Old", questionedRating: 6, correctAnswer: false),
//        .init(imageName: "The Ice Age Adventures of Buck Wild", questionedRating: 6, correctAnswer: false),
//        .init(imageName: "Tesla", questionedRating: 6, correctAnswer: false),
//        .init(imageName: "Vivarium", questionedRating: 6, correctAnswer: false)
//    ]
//    
//    func requestNextQuestion() {
//        guard let index = (0..<questions.count).randomElement() else {
//            delegate?.didReceiveNextQuestion(question: nil)
//            return
//        }
//        delegate?.didReceiveNextQuestion(question: questions[safe: index])
//    }
//    
//    init(delegate: QuestionFactoryDelegate? = nil) {
//        self.delegate = delegate
//    }
//}

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    private var movies = [MostPopularMovie]()
    
    init(moviesLoader: MoviesLoader, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let movies):
                    self.movies = movies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let questionedRating = (6...9).randomElement()!
            let correctAnswer = rating > Float(questionedRating)
            
            let question = QuizQuestion(image: imageData, questionedRating: questionedRating, correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
}
