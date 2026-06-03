import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - UI Elements
    //постер
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill // заполнение
        image.layer.cornerRadius = 20 // сглаживание угла
        image.clipsToBounds = true // обрезаем углы
        image.backgroundColor = .gray // нужно ли?
        image.translatesAutoresizingMaskIntoConstraints = false // отключаем автоматические констрейнты
        return image
    }()
    
    //вопрос
    private let textLabel: UILabel = {
        let text = UILabel()
        text.text = ""
        text.font = UIFont(name: "YSDisplay-Bold", size: 23)
        text.textColor = UIColor(named: "YP White")
        text.textAlignment = .center
        text.numberOfLines = 2
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    //лейбл с номером вопроса
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "YSDisplay-Medium", size: 20)
        label.textColor = UIColor(named: "YP White")
        label.textAlignment = .right
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //лейбл с текстом "вопрос"
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Вопрос:"
        label.font = UIFont(name: "YSDisplay-Medium", size: 20)
        label.textColor = UIColor(named: "YP White")
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //кнопка "да"
    private let yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Да", for: .normal)
        button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        button.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        button.backgroundColor = UIColor(named: "YP White")
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //кнопка "нет"
    private let noButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нет", for: .normal)
        button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        button.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        button.backgroundColor = UIColor(named: "YP White")
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    //MARK: - Data
    private let questions = MovieQuizViewController.questions
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let currentQuestion = questions[currentQuestionIndex]
        let resultOfConvert = convert(model: currentQuestion)
        show(quiz: resultOfConvert)
    }
    
    // MARK: - Actions
    //обрабатывает нажатие
    @objc private func buttonTapped(_ sender: UIButton) {
        let givenAnswer = sender == yesButton
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private Methods
    
    private func setupUI(){
        view.backgroundColor = UIColor(named: "YP Black")
        
        yesButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let topStackViews = UIStackView(arrangedSubviews: [questionLabel, counterLabel])
        topStackViews.axis = .horizontal
        topStackViews.distribution = .equalSpacing
        topStackViews.alignment = .center
        topStackViews.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonStackViews = UIStackView(arrangedSubviews: [yesButton, noButton])
        buttonStackViews.axis = .horizontal
        buttonStackViews.distribution = .fillEqually
        buttonStackViews.alignment = .fill
        buttonStackViews.spacing = 20
        buttonStackViews.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackViews = UIStackView(arrangedSubviews: [topStackViews, imageView, textLabel, buttonStackViews])
        mainStackViews.axis = .vertical
        mainStackViews.distribution = .fill
        mainStackViews.alignment = .fill
        mainStackViews.spacing = 20
        mainStackViews.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStackViews)
        
        NSLayoutConstraint.activate([
            mainStackViews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackViews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackViews.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            mainStackViews.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3.0 / 2.0),
            buttonStackViews.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
     
    //создаёт модель вью из вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        let image = UIImage(named: model.image) ?? UIImage()
        return QuizStepViewModel(
            image: image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    //обновляет элементы согласно структуре
    private func show(quiz step: QuizStepViewModel){
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
        imageView.layer.cornerRadius = 20 // добавлено скругление рамки
    }
    
    //красит рамку в зависимости от правильности ответа
    private func showAnswerResult(isCorrect: Bool){
        buttonEnabled(isEnabled: false)
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.showNextQuestionOrResults()
        }
    }
    
    //переключает следующий вопрос или вызывает алерт
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questions.count - 1 {
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат \(correctAnswers)/\(questions.count)!",
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
            buttonEnabled(isEnabled: true)
        }
    }
    
    //функция показа алерта
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
        
    //блокирует кнопки
    private func buttonEnabled(isEnabled: Bool){
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
        
    // MARK: - Models
    //структура с вопросами. Чтобы вынести в расширение пришлось убрать private
    struct QuizQuestion {
        //строка с названием фильма
        let image: String
        //строка с вопросом о рейтинге фильма
        let text: String
        //булево значение - результат ответа на вопрос
        let correctAnswer: Bool
    }
    
    //структура для создания вью вопроса
    private struct QuizStepViewModel{
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    //структура для создания вью результата
    private struct QuizResultsViewModel{
        let title: String
        let text: String
        let buttonText: String
    }
     
}

extension MovieQuizViewController {
    //массив с вопросами
    static let questions: [QuizQuestion] = [
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
}
