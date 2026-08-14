//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Алик on 14.06.2026.
//

import UIKit
final class AlertPresenter {
    
    func show(in vc: UIViewController, model: AlertModel){
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "alertResult"
        let action =  UIAlertAction(
            title: model.buttonText, 
            style: .default) {_ in model.completion()
        }
        action.accessibilityIdentifier = "alertAction"
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}







