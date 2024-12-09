//
//  QuizResultViewModel.swift
//  MovieQuiz
//
//  Created by Vladimir on 06.12.2024.
//

struct QuizResultViewModel {
    let title: String
    let text: String
    let buttonText: String
}

extension QuizResultViewModel {
    init(title: String, score: Int, numQuestions: Int, statisticService: StatisticServiceProtocol, buttonText: String) {
        self.title = title
        self.buttonText = buttonText
        self.text =
            """
            Ваш результат: \(score)/\(numQuestions)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame)
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy*100))%
            """
    }
}
