import UIKit
import SwiftUI

final class MovieQuizViewController: UIViewController, QuestionFactoryDelgate {
    
    // MARK: - UI Elements
    //постер
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill // заполнение
        image.layer.cornerRadius = 20 // сглаживание угла
        image.clipsToBounds = true // обрезаем углы
        image.backgroundColor = .gray // нужно ли?
        image.translatesAutoresizingMaskIntoConstraints = false
        //
        image.setContentCompressionResistancePriority(.init(750), for: .vertical)
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
        
        //
        text.setContentCompressionResistancePriority(.init(500), for: .vertical)
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
        //
        label.setContentCompressionResistancePriority(.init(250), for: .vertical)
        
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
        //
        label.setContentCompressionResistancePriority(.init(250), for: .vertical)
        
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
        //
        button.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        
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
        //
        button.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        return button
    }()
    
    // MARK: - Properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var currentQuestion: QuizQuestion?
    
    private var questionFactory: QuestionFactoryProtocol?
    //переменная раньше связывавшая классы, теперь cвязывает контроллер и протокол, а значит на его месте может быть любой класс
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //инъекция через свойство
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
    }
    
    
    //MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Actions
    //обрабатывает нажатие
    @objc private func buttonTapped(_ sender: UIButton) {
        let givenAnswer = sender == yesButton
        guard let currentQuestion = currentQuestion else {
            return
        }
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
        topStackViews.alignment = .fill
        topStackViews.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonStackViews = UIStackView(arrangedSubviews: [yesButton, noButton])
        buttonStackViews.axis = .horizontal
        buttonStackViews.distribution = .fillEqually
        buttonStackViews.alignment = .fill
        buttonStackViews.spacing = 20
        buttonStackViews.translatesAutoresizingMaskIntoConstraints = false
        buttonStackViews.setContentCompressionResistancePriority(.init(1000), for: .vertical)
              
        let mainStackViews = UIStackView(arrangedSubviews: [topStackViews, imageView, textLabel, buttonStackViews])
        mainStackViews.axis = .vertical
        mainStackViews.distribution = .equalSpacing
        mainStackViews.alignment = .fill
        mainStackViews.spacing = 20
        mainStackViews.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStackViews)
                
        NSLayoutConstraint.activate([
            mainStackViews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackViews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackViews.bottomAnchor.constraint(equalTo: buttonStackViews.bottomAnchor, constant: 0),
            mainStackViews.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3.0 / 2.0),
            
            buttonStackViews.heightAnchor.constraint(equalToConstant: 60),
            topStackViews.heightAnchor.constraint(equalToConstant: 20),
            buttonStackViews.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    //создаёт модель вью из вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        let image = UIImage(named: model.image) ?? UIImage()
        return QuizStepViewModel(
            image: image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    //переключает следующий вопрос или вызывает алерт
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ? "Поздравляем! Вы ответили на 10 из 10!" : "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            buttonEnabled(isEnabled: true)
        }
    }
    
    //функция показа алерта
    private func show(quiz result: QuizResultsViewModel){
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default){
            [weak self] _ in
            
            guard let self = self else { return }
            
            correctAnswers = 0
            currentQuestionIndex = 0 // ?????
            
            questionFactory?.requestNextQuestion()
            buttonEnabled(isEnabled: true)
                        
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    //блокирует кнопки
    private func buttonEnabled(isEnabled: Bool){
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
}
// MARK: - Preview
struct MovieQuizViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MovieQuizViewController {
        MovieQuizViewController()
    }
    func updateUIViewController(_ uiViewController: MovieQuizViewController, context: Context) {}
}

struct MovieQuizViewController_Previews: PreviewProvider {
    static var previews: some View {
        MovieQuizViewControllerPreview()
            .ignoresSafeArea()
    }
}
