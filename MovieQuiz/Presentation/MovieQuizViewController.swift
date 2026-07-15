import UIKit
import SwiftUI

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - UI Elements
    
    //индикатор загрузки
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
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
        image.accessibilityIdentifier = "imageView"
                
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
        label.accessibilityIdentifier = "counterLabel"
        
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
    let yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Да", for: .normal)
        button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        button.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        button.backgroundColor = UIColor(named: "YP White")
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        //
        button.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        button.accessibilityIdentifier = "yesButton"
        
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
        button.accessibilityIdentifier = "noButton"
        
        return button
    }()
    
    // MARK: - Properties
    
    
    private var alertPresenter = AlertPresenter()
    
    private var statisticService: StatisticServiceProtocol?
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
        
        showLoadingIndicator()
        
        statisticService = StatisticService()
        
        presenter = MovieQuizPresenter(viewController: self)
        
    }
    
    
    
    // MARK: - Actions
    //обрабатывает нажатие
//    @objc private func buttonTapped(_ sender: UIButton) {
//        let givenAnswer = sender == yesButton
//        guard let currentQuestion = currentQuestion else {
//            return
//        }
//        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
//    }
    @objc func buttonTapped(_ sender: UIButton) {
        let isYesAnswer = sender == yesButton
        
        presenter.didAnswer(isYes: isYesAnswer)
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
        imageView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            mainStackViews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackViews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackViews.bottomAnchor.constraint(equalTo: buttonStackViews.bottomAnchor, constant: 0),
            mainStackViews.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3.0 / 2.0),
            
            buttonStackViews.heightAnchor.constraint(equalToConstant: 60),
            topStackViews.heightAnchor.constraint(equalToConstant: 20),
            buttonStackViews.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    //блокирует кнопки
    func buttonEnabled(isEnabled: Bool){
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    
    
    
    //обновляет элементы согласно структуре
    func show(quiz step: QuizStepViewModel) {
        imageView.image = UIImage(data: step.image) ?? UIImage()
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.cornerRadius = 20 // добавлено скругление рамки
        
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    func show(quiz result: QuizResultsViewModel) {
                
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
            
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                guard let self = self else { return }
                presenter.restarGame()
            }
            
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
   
    
    
    
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        /* У этого алерта должна быть кнопка «Попробовать ещё раз», по нажатию на которую мы будем пытаться снова загрузить данные.
         Заголовком алерта пусть будет просто «Ошибка».*/
        let alertNetworkErrorModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: {[weak self] in
                guard let self = self else { return }
                
                presenter.restarGame()
                
                self.buttonEnabled(isEnabled: true)
            }
        )
        alertPresenter.show(in: self, model: alertNetworkErrorModel)
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    
    //MARK: - ПЕРЕНЕСЕНО!!!!
    
    //создаёт модель вью из вопроса
//    private func convert(model: QuizQuestion) -> QuizStepViewModel{
//        //let image = UIImage(named: model.image) ?? UIImage()
//        return QuizStepViewModel(
//            image: model.image,
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
//        )
//    }
    
//    private let questionsAmount = 10
//    var currentQuestionIndex = 0
//    private var currentQuestion: QuizQuestion?
    
//    //MARK: - QuestionFactoryDelegate
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        
//        guard let question = question else { return }
//        presenter.currentQuestion = question
//        let viewModel = presenter.convert(model: question)
//        
//        DispatchQueue.main.async { [weak self] in
//            self?.show(quiz: viewModel)
//        }
//    }
    
//    //переключает следующий вопрос или вызывает алерт
//    private func showNextQuestionOrResults(){
//        if presenter.isLastQuestion() {
//            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
//                        
//            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
//            
//            let viewModel = QuizResultsViewModel(
//                title: "Этот раунд окончен!",
//                text: text,
//                buttonText: "Сыграть ещё раз!")
//            
//            show(quiz: viewModel)
//        } else {
//            presenter.switchToNextQuestion()
//            questionFactory?.requestNextQuestion()
//            buttonEnabled(isEnabled: true)
//        }
//    }
    
//    var correctAnswers = 0
//    
//    
//    private var questionFactory: QuestionFactoryProtocol?
//    //переменная раньше связывавшая классы, теперь cвязывает контроллер и протокол, а значит на его месте может быть любой класс
    
//    questionFactory.loadData()
//    //инъекция через свойство
//    //let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
//    //questionFactory.delegate = self //
//    presenter.questionFactory = questionFactory
//    //questionFactory.requestNextQuestion()
    
    
//    func didLoadDataFromServer() {
//        activityIndicator.isHidden = true
//        presenter.questionFactory?.requestNextQuestion()
//    }
//    
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
    
//    //красит рамку в зависимости от правильности ответа
//    func showAnswerResult(isCorrect: Bool){
//        buttonEnabled(isEnabled: false)
//        if isCorrect {
//            presenter.switchToNextQuestion()
//        }
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderWidth = 8
//        imageView.layer.cornerRadius = 20
//        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ [weak self] in
//            guard let self = self else { return }
//            presenter.showNextQuestionOrResults()
//            //обрати внимание!!!!!self.presenter.questionFactory = self.questionFactor. всё нормально, это удалили позднее)
//        }
//    }
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
