import UIKit

final class MovieQuizViewController: UIViewController {
    
    private var questionIndex = 0
    private var userScore = 0
    private let numQuestions = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion? = nil
    private let alertPresenter = AlertPresenter()
    private let statisticService: StatisticServiceProtocol = StatisticService()
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionTitle: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesButton.titleLabel?.font = .ysDisplayMedium
        noButton.titleLabel?.font = .ysDisplayMedium
        textLabel.font = .ysDisplayBold
        counterLabel.font = .ysDisplayMedium
        questionTitle.font = .ysDisplayMedium
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        showLoadingIndicator()
        
        alertPresenter.delegate = self
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        questionFactory.loadData()
        questionFactory.requestNextQuestion()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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
            statisticService.store(correct: userScore, total: numQuestions)
            let result = QuizResultViewModel(title: "Этот раунд окончен!",
                                             score: userScore,
                                             numQuestions: numQuestions,
                                             statisticService: statisticService,
                                             buttonText: "Сыграть еще раз")
            show(quiz: result)
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
    
    private func show(quiz result: QuizResultViewModel) {
        let alert = AlertModel(quizResult: result) { [weak self] in
            guard let self else { return }
            self.questionIndex = 0
            self.userScore = 0
            questionFactory?.requestNextQuestion()
        }
        alertPresenter.presentAlert(alert)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter.presentAlert(alertModel)
    }
}


private extension MovieQuizViewController {
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
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
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
