import UIKit

final class MovieQuizViewController: UIViewController {
    
    private var userScore = 0
    private var questionFactory: QuestionFactoryProtocol?
    private let alertPresenter = AlertPresenter()
    private let statisticService: StatisticServiceProtocol = StatisticService()
    private let presenter = MovieQuizPresenter()
    private var currentQuestion: QuizQuestion? = nil
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
        yesButton.accessibilityIdentifier = "Yes"
        
        noButton.titleLabel?.font = .ysDisplayMedium
        noButton.accessibilityIdentifier = "No"
        
        textLabel.font = .ysDisplayBold
        
        counterLabel.font = .ysDisplayMedium
        counterLabel.accessibilityIdentifier = "Index"
        
        questionTitle.font = .ysDisplayMedium
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.accessibilityIdentifier = "Poster"
        
        showLoadingIndicator()
        
        alertPresenter.delegate = self
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        questionFactory.loadData()
        questionFactory.requestNextQuestion()
        
        presenter.viewController = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction private func noButtonTapped() {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonTapped()
    }
    
    @IBAction private func yesButtonTapped() {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonTapped()
    }
    
    func showAnswerResult(isCorrect: Bool) {
        disableButtons()
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
        if presenter.isLastQuestion {
            statisticService.store(correct: userScore, total: presenter.numQuestions)
            let result = QuizResultViewModel(title: "Этот раунд окончен!",
                                             score: userScore,
                                             numQuestions: presenter.numQuestions,
                                             statisticService: statisticService,
                                             buttonText: "Сыграть еще раз")
            show(quiz: result)
        } else {
            presenter.incrementQuestionIndex()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func enableButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func disableButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
        
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultViewModel) {
        let alert = AlertModel(quizResult: result) { [weak self] in
            guard let self else { return }
            self.presenter.resetQuestionIndex()
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
            self.questionFactory?.loadData()
//            self.questionFactory?.requestNextQuestion()
            
        }
        alertPresenter.presentAlert(alertModel)
    }
}


extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        show(quiz: viewModel)
        imageView.layer.borderWidth = 0
        enableButtons()
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
