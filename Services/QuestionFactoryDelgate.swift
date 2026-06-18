//
//  QuestionFactoryDelgate.swift
//  MovieQuiz
//
//  Created by Алик on 14.06.2026.
//

import Foundation

protocol QuestionFactoryDelgate: AnyObject {    
    func didReceiveNextQuestion(question: QuizQuestion?)
}
