//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Алик on 11.06.2026.
//

import Foundation
//структура с вопросами.
 struct QuizQuestion {
    //строка с названием фильма
    let image: Data
    //строка с вопросом о рейтинге фильма
    let text: String
    //булево значение - результат ответа на вопрос
    let correctAnswer: Bool
}
