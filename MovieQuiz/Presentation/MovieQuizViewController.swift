import UIKit

final class MovieQuizViewController: UIViewController {
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
            let givenAnswer = true
            let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
            let givenAnswer = false
            let currentQuestions = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: givenAnswer == currentQuestions.correctAnswer)
        
       }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        let resultOfConvert = convert(model: currentQuestion)
        show(quiz: resultOfConvert)
    }
    
    
    
    private struct QuizQuestion {
        //строка с названием фильма
        //совпадает с названием постера в assets
        let image: String
        //строка с вопросом о рейтинге фильма
        let text: String
        //булево значение - результат ответа на вопрос
        let correctAnswer: Bool
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true)
    ]
    
    private struct QuizStepViewModel{
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private struct QuizResultsViewModel{
        let title: String
        let text: String
        let buttonText: String
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        let image = UIImage(named: model.image) ?? UIImage()
        return QuizStepViewModel(
            image: image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    private func show(quiz step: QuizStepViewModel){
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }
        
    
    
    private func showAnswerResult(isCorrect: Bool){
        if isCorrect{
                    correctAnswers += 1
                }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.showNextQuestionOrResults()
        }
    }
        
    
    private func show(quiz result: QuizResultsViewModel){
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default){
            _ in
                self.correctAnswers = 0
                self.currentQuestionIndex = 0
                
                let firstQuestion = self.questions[self.currentQuestionIndex]
                let viewModel = self.convert(model: firstQuestion)
                self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questions.count - 1{
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат \(correctAnswers)/\(questions.count)!",
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
                
        }else{
            currentQuestionIndex += 1
            //показываем следующий вопрос
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    
    
    
}//end of class
