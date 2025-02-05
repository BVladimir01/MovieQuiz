import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    private let alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter!
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionTitle: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifycycle
    
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
        
        activityIndicator.hidesWhenStopped = true
        
        alertPresenter.delegate = self
        
        presenter = MovieQuizPresenter(viewController: self)
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
    
    func setButtons(enabled isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
        
    func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultViewModel) {
        let alert = AlertModel(quizResult: result) { [weak self] in
            guard let self else { return }
            self.presenter.restartGame()
        }
        alertPresenter.presentAlert(alert)
    }
    
    func disableImageBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func highlightImageBorder(answerIsCorrect: Bool) {
        let color: UIColor = answerIsCorrect ? .ypGreen : .ypRed
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = color.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            self.presenter.reloadGame()
        }
        alertPresenter.presentAlert(alertModel)
    }
}
