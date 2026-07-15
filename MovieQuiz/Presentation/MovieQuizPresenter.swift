//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Алик on 15.07.2026.
//

import Foundation
import UIKit

class MovieQuizPresenter {
    
    //MARK: - Properties
    weak var viewController: MovieQuizViewController? // почему так, а не добавлением инициализатора () потому что слабая ссылка требует опционал же!!!!!!!! вспомнил!!!1
    var currentQuestion: QuizQuestion?
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    
    
    //MARK: - Methods
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    //создаёт модель вью из вопроса
    func convert(model: QuizQuestion) -> QuizStepViewModel{
        //let image = UIImage(named: model.image) ?? UIImage()
        return QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let givenAnswer = sender == viewController.yesButton
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
}
