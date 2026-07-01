//
//  StaticService.swift
//  MovieQuiz
//
//  Created by Алик on 17.06.2026.
//

import Foundation

final class StaticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private var totalCorrectAnswers: Int {
        get {
            return storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    private var totalQuestionAsked: Int {
        get {
            return storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
        
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(Date(), forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        guard totalQuestionAsked > 0 else { return 0 }
        return Double(totalCorrectAnswers) / Double(totalQuestionAsked) * 100
    }
        
    func store(correct count: Int, total amount: Int) {
        
        let newGame = GameResult(correct: count, total: amount, date: Date())
        gamesCount += 1
        totalCorrectAnswers += count
        totalQuestionAsked += amount
           
        if bestGame.total == 0 || newGame.compareRecords(bestGame) {
            bestGame = newGame
            return
        }
     }
    
    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
    }
}
