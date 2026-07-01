//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Алик on 17.06.2026.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get } // количество завершённых игр
    var bestGame: GameResult { get } // информация о лучшей попытке
    var totalAccuracy: Double { get } // средняя точность правильных ответов за все игры в процентах.
    
    func store(correct count: Int, total amount: Int)
}
