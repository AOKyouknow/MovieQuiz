//
//  QuestionFactoryDelgate.swift
//  MovieQuiz
//
//  Created by Алик on 14.06.2026.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {    
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
