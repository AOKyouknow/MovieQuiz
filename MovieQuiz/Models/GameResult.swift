//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Алик on 17.06.2026.
//

import Foundation

struct GameResult {
    let correct: Int // количество правильных ответов
    let total: Int // количество вопросов квиза
    let date: Date // дата
    
    func compareRecords(_ newResult: GameResult) -> Bool {
        correct > newResult.correct
    }
}
