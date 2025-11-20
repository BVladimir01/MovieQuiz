//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Vladimir on 06.12.2024.
//

import UIKit


class AlertPresenter {
    weak var delegate: UIViewController?
    
    func presentAlert(_ alert: AlertModel) {
        let ac = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        let handler = { (alertAction: UIAlertAction) in
            alert.action()
        }
        let action = UIAlertAction(title: alert.buttonText, style: .default, handler: handler)
        ac.addAction(action)
        ac.preferredAction = action
        delegate?.present(ac, animated: true, completion: nil)
    }
}
