import UIKit

final class MovieQuizViewController: UIViewController {
    
    private var questionIndex = 0
    private var userScore = 0
    private let numQuestions = 10
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion? = nil
    
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
        
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
        }
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
            show(quiz: quizResults)
        } else {
            questionIndex += 1
            if let newQuestion = questionFactory.requestNextQuestion() {
                currentQuestion = newQuestion
                let newQuizStepView = convert(model: newQuestion)
                show(quiz: newQuizStepView)
            }
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
    
    private func show(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: result.buttonText,
                                        style: .default) { [weak self] _ in
            guard let self else { return }
            self.questionIndex = 0
            self.userScore = 0
            if let newQuestion = questionFactory.requestNextQuestion() {
                self.currentQuestion = newQuestion
                let newQuizStepView = self.convert(model: newQuestion)
                self.show(quiz: newQuizStepView)
            }
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
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
