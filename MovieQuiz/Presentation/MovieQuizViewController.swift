import UIKit

final class MovieQuizViewController: UIViewController {
    
    var questionFactory: QuestionFactoryProtocol?
    private let alertPresenter = AlertPresenter()
    let statisticService: StatisticServiceProtocol = StatisticService()
    private let presenter = MovieQuizPresenter()
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
        presenter.noButtonTapped()
    }
    
    @IBAction private func yesButtonTapped() {
        presenter.yesButtonTapped()
    }
    
    func showAnswerResult(isCorrect: Bool) {
        disableButtons()
        let color: UIColor = isCorrect ? .ypGreen : .ypRed
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = color.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.presenter.showNextQuestionOrResults()
        }
    }
    
    func enableButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func disableButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
        
    func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultViewModel) {
        let alert = AlertModel(quizResult: result) { [weak self] in
            guard let self else { return }
            self.presenter.resetQuestionIndexAndScore()
            questionFactory?.requestNextQuestion()
        }
        alertPresenter.presentAlert(alert)
    }
    
    func disableImageBorder() {
        imageView.layer.borderWidth = 0
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            self.questionFactory?.loadData()
            
        }
        alertPresenter.presentAlert(alertModel)
    }
}


extension MovieQuizViewController: QuestionFactoryDelegate {
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
