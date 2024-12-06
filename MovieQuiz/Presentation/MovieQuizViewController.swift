import UIKit

final class MovieQuizViewController: UIViewController {
    
    private var questionIndex = 0
    private var userScore = 0
    private let numQuestions = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion? = nil
    private let alertPresenter = AlertPresenter()
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesButton.titleLabel?.font = .ysDisplayMedium
        noButton.titleLabel?.font = .ysDisplayMedium
        textLabel.font = .ysDisplayBold
        counterLabel.font = .ysDisplayMedium
        questionTitle.font = .ysDisplayMedium
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        let questionFactory = QuestionFactory(delegate: self)
        self.questionFactory = questionFactory
        
        alertPresenter.delegate = self
        
        questionFactory.requestNextQuestion()
    }
    
    @IBAction private func noButtonTapped() {
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonTapped() {
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        toggleButtons()
        let color: UIColor = isCorrect ? .ypGreen : .ypRed
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = color.cgColor
        if isCorrect {
            userScore += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if questionIndex == numQuestions - 1 {
            let quizResults = QuizResultViewModel(text: "Ваш результат: \(userScore)/\(numQuestions)",
                                                  buttonText: "Сыграть еще раз")
            gameEnded()
        } else {
            questionIndex += 1
            questionFactory?.requestNextQuestion()
        }
        imageView.layer.borderWidth = 0
        toggleButtons()
    }
    
    private func toggleButtons() {
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    private func gameEnded() {
        let alert = AlertModel(title: "Игра окончена", message: "Ваш результат: \(userScore)/\(numQuestions)", buttonText: "Сыграть еще раз") { [weak self] in
                guard let self else { return }
                self.questionIndex = 0
                self.userScore = 0
                questionFactory?.requestNextQuestion()
        }
        alertPresenter.presentAlert(alert: alert)
    }
}


private extension MovieQuizViewController {
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.imageName) ?? UIImage(),
            question: model.quesion,
            questionNumber: "\(questionIndex + 1)/\(numQuestions)")
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}
