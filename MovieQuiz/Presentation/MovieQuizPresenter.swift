//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Алик on 15.07.2026.
//

import Foundation
import UIKit

class MovieQuizPresenter: QuestionFactoryDelegate {
    
    //MARK: - Properties
    weak var viewController: MovieQuizViewController? // почему так, а не добавлением инициализатора () потому что слабая ссылка требует опционал же!!!!!!!! вспомнил!!!1
    var currentQuestion: QuizQuestion?
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers = 0
    var questionFactory: QuestionFactoryProtocol?
    //переменная раньше связывавшая классы, теперь cвязывает контроллер и протокол, а значит на его месте может быть любой класс
    
    init(viewController: MovieQuizViewController) {
            self.viewController = viewController
            
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            viewController.showLoadingIndicator()
        }
    
    //MARK: - Methods
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
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
    
    @objc func buttonTapped(_ sender: UIButton) {
        let givenAnswer = sender == viewController?.yesButton
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //переключает следующий вопрос или вызывает алерт
    func showNextQuestionOrResults(){
        if self.isLastQuestion() {
                        
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз!")
            
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            viewController?.buttonEnabled(isEnabled: true)
        }
    }
    
    
    //MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
            viewController?.hideLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
        
        func didFailToLoadData(with error: Error) {
            let message = error.localizedDescription
            viewController?.showNetworkError(message: message)
        }
    
    func restarGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
}
