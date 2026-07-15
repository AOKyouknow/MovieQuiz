//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Алик on 15.07.2026.
//

import Foundation

class MovieQuizPresenter: QuestionFactoryDelegate {
    
    //MARK: - Properties
    private weak var viewController: MovieQuizViewControllerProtocol? // почему так, а не добавлением инициализатора () потому что слабая ссылка требует опционал же!!!!!!!! вспомнил!!!1
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    //переменная раньше связывавшая классы, теперь cвязывает контроллер и протокол, а значит на его месте может быть любой класс
    private let statisticService: StatisticServiceProtocol!
    
    init(viewController: MovieQuizViewControllerProtocol) {
            self.viewController = viewController
            
        statisticService = StatisticService()
        
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            viewController.showLoadingIndicator()
        }
    
    //MARK: - Methods
    
    private func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
    
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
    
    
    
    //красит рамку в зависимости от правильности ответа
    private func proceedWithAnswer(isCorrect: Bool){
        viewController?.buttonEnabled(isEnabled: false)
        if isCorrect {
            correctAnswers += 1
        }
        
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect) // шаг 9 - непонятно. все эти параметры были в функции showAnswerResult, переместили их обратно в контроллер.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
            //обрати внимание!!!!!self.presenter.questionFactory = self.questionFactor. всё нормально, это удалили позднее)
        }
    }
    
    
    //переключает следующий вопрос или вызывает алерт
    private func proceedToNextQuestionOrResults(){
        if self.isLastQuestion() {
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: makeResultsMessage(),
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
    
    func didAnswer(isYes: Bool) {
            guard let currentQuestion = currentQuestion else {
                return
            }

            let givenAnswer = isYes

            proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    
}
