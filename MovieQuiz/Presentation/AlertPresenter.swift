//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Алик on 14.06.2026.
//

import UIKit
final class AlertPresenter {
    
    weak var delegate: AlertDelegate?
    
    func show(quiz result: AlertModel){
        
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        let action =  UIAlertAction(title: result.buttonText, style: .default) {_ in
            result.completion()
        }
        alert.addAction(action)
        delegate?.showAlert(alertController: alert)
    }
}







