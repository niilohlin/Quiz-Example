//
// Created by Niil on 2018-04-10.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

protocol QuizViewModelDelegate: class {
    func viewModel(_ viewModel: QuizViewModelType, didUpdateQuestion question: Question)
    func viewModel(_ viewModel: QuizViewModelType, didUpdateAlternative alternative: Alternative, atIndex index: Int)
    func viewModelDidTimeout(_ viewModel: QuizViewModelType)
    func viewModel(_ viewModel: QuizViewModelType, didUpdateHalfAlternatives isEnabled: Bool)
    func viewModel(_ viewModel: QuizViewModelType, didUpdateExtraTime isEnabled: Bool)
}

protocol QuizViewModelType {
    var delegate: QuizViewModelDelegate? { get set }
    var question: String { get }
    var image: UIImage? { get }
    var alternatives: [Alternative] { get }
    func submit(answer: Alternative)
    func reloadData()
    func bindCountDown(callback: @escaping (Float) -> Void)
    func extraTime()
    func halfAlternatives()
}

class QuizViewModel: QuizViewModelType {
    var question: String = ""
    var image: UIImage? {
        return currentQuestion.imageUrl.flatMap(UIImage.init(named:))
    }
    var extraTimeEnabled = true {
        didSet {
            delegate?.viewModel(self, didUpdateExtraTime: extraTimeEnabled)
        }
    }
    var halfAlternativesEnabled = true {
        didSet {
            delegate?.viewModel(self, didUpdateHalfAlternatives: halfAlternativesEnabled)
        }
    }

    weak var delegate: QuizViewModelDelegate?

    private var quiz: Quiz
    private weak var coordinator: AppCoordinator?

    init(quiz: Quiz, coordinator: AppCoordinator) {
        self.quiz = quiz
        self.coordinator = coordinator
    }

    var alternatives: [Alternative] {
        return currentQuestion.alternatives
    }

    var currentQuestionIndex = 0 {
        didSet {
            guard currentQuestionIndex < quiz.questions.count else {
                coordinator?.finish(quiz: quiz)
                return
            }
            startCountdown()
            reloadData()
        }
    }

    var currentQuestion: Question {
        return quiz.questions[currentQuestionIndex]
    }

    func reloadData() {
        delegate?.viewModel(self, didUpdateQuestion: currentQuestion)
        for (i, alternative) in alternatives.enumerated() {
            delegate?.viewModel(self, didUpdateAlternative: alternative, atIndex: i)
        }
    }

    func submit(answer: Alternative) {
        precondition(currentQuestion.alternatives.contains(answer))
        precondition(
                currentQuestion.alternatives.contains(currentQuestion.correctAnswer),
                "CurrentQuestion is not setup properly"
        )
        timer?.invalidate()

        quiz.questions[currentQuestionIndex].chosenAnswer = answer
        quiz.questions[currentQuestionIndex].answerTime = ticks / FPS

        for alternative in currentQuestion.alternatives {
            alternative.state = .disabled
        }
        answer.state = .incorrect
        currentQuestion.correctAnswer.state = .correct
        reloadData()
        nextQuestion()
    }

    func nextQuestion() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.currentQuestionIndex += 1
        }
    }

    var timer: Timer?
    var countdownDidUpdate: ((Float) -> Void)?
    func bindCountDown(callback: @escaping (Float) -> Void) {
        countdownDidUpdate = callback
        startCountdown()
    }

    let FPS = 60.0
    var totalTicks: Double {
        return Constants.defaultNumberOfSeconds * FPS
    }
    var ticks = 0.0
    private func startCountdown() {
        ticks = 0.0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0/FPS, target: self, selector: #selector(countDownCallback), userInfo: nil, repeats: true)
        timer?.fire()
    }

    @objc private func countDownCallback() {
        let countDownAmount = (totalTicks - ticks) / totalTicks
        countdownDidUpdate?(Float(countDownAmount))
        ticks += 1
        if ticks == totalTicks {
            timeout()
        }
    }

    private func timeout() {
        delegate?.viewModelDidTimeout(self)
        timer?.invalidate()
        for alternative in currentQuestion.alternatives {
            alternative.state = .disabled
        }
        reloadData()
        nextQuestion()
    }

    func halfAlternatives() {
        let allWrongAlternatives = currentQuestion.alternatives.filter { alternative in
            alternative != self.currentQuestion.correctAnswer
        }
        for wrongAlternative in allWrongAlternatives {
            wrongAlternative.state = .disabled
        }

        let wrongAnswerToKeep = arc4random_uniform(UInt32(allWrongAlternatives.count))
        allWrongAlternatives[Int(wrongAnswerToKeep)].state = .enabled
        halfAlternativesEnabled = false
        reloadData()
    }

    func extraTime() {
        ticks -= FPS * 10
        ticks = max(ticks, 0)
        extraTimeEnabled = false
    }
}