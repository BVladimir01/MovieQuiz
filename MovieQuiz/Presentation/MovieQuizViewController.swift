import UIKit

final class MovieQuizViewController: UIViewController {
    private let questions: [QuizQuestion] = [
        .init(imageName: "The Godfather", questionedRating: 6, correctAnswer: true),
        .init(imageName: "The Dark Knight", questionedRating: 6, correctAnswer: true),
        .init(imageName: "Kill Bill", questionedRating: 6, correctAnswer: true),
        .init(imageName: "The Avengers", questionedRating: 6, correctAnswer: true),
        .init(imageName: "Deadpool", questionedRating: 6, correctAnswer: true),
        .init(imageName: "The Green Knight", questionedRating: 6, correctAnswer: true),
        .init(imageName: "Old", questionedRating: 6, correctAnswer: false),
        .init(imageName: "The Ice Age Adventures of Buck Wild", questionedRating: 6, correctAnswer: false),
        .init(imageName: "Tesla", questionedRating: 6, correctAnswer: false),
        .init(imageName: "Vivarium", questionedRating: 6, correctAnswer: false)
    ]
    
    private var questionIndex = 0
    private var userScore = 0
    private var numQuestions: Int { questions.count }
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstQuizView = convert(model: questions[questionIndex])
        show(quiz: firstQuizView)
    }
    
    @IBAction private func noButtonTapped() {
        let question = questions[questionIndex]
        showAnswerResult(isCorrect: !question.correctAnswer)
    }
    
    @IBAction private func yesButtonTapped() {
        let question = questions[questionIndex]
        showAnswerResult(isCorrect: question.correctAnswer)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        toggleButtons()
        let color: UIColor = isCorrect ? .ypGreen : .ypRed
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = color.cgColor
        if isCorrect {
            userScore += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1,
                                      execute: showNextQuestionOrResults)
    }
    
    private func showNextQuestionOrResults() {
        if questionIndex == questions.count - 1 {
            let quizResults = QuizResultViewModel(text: "Ваш результат: \(userScore)/\(numQuestions)",
                                                  buttonText: "Сыграть еще раз")
            show(quiz: quizResults)
        } else {
            questionIndex += 1
            let newQuestion = questions[questionIndex]
            let newQuizStepView = convert(model: newQuestion)
            show(quiz: newQuizStepView)
        }
        imageView.layer.borderWidth = 0
        toggleButtons()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: result.buttonText,
                                        style: .default) { _ in
            self.questionIndex = 0
            self.userScore = 0
            let newQuestion = self.questions[self.questionIndex]
            let newQuizStepView = self.convert(model: newQuestion)
            self.show(quiz: newQuizStepView)
        }
        
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func toggleButtons() {
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
}


private extension MovieQuizViewController {
    
     struct QuizQuestion {
        let imageName: String
        let questionedRating: Int
        let correctAnswer: Bool
        var quesion: String {
            "Рейтинг этого фильма больше чем \(questionedRating)?"
        }
    }
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.imageName) ?? UIImage(),
            question: model.quesion,
            questionNumber: "\(questionIndex + 1)/\(numQuestions)")
    }
    
    struct QuizResultViewModel {
        let title: String = "Раунд окончен!"
        let text: String
        let buttonText: String
    }
    
    
}
