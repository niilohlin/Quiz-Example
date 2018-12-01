//
// Created by Niil on 2018-04-12.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

protocol FinishedViewModelType {
    var percentage: Int { get }
    var average: Int { get }
    var fastest: Int { get }
    var slowest: Int { get }
    func retry()
}

class FinishedViewModel: FinishedViewModelType {
    private var quiz: Quiz
    private weak var coordinator: AppCoordinator?

    var percentage: Int {
        let correctAnswers = quiz.questions.filter { question in question.isAnsweredCorrectly }
        return Int(100 * Double(correctAnswers.count) / Double(quiz.questions.count))
    }

    var answerTimes: [TimeInterval] {
        return quiz.questions.filter { question in
            question.isAnswered
        }.map { question in
            question.answerTime ?? Constants.defaultNumberOfSeconds
        }
    }

    var fastest: Int {
        return Int(answerTimes.min() ?? Constants.defaultNumberOfSeconds)
    }

    var slowest: Int {
        return Int(answerTimes.max() ?? Constants.defaultNumberOfSeconds)
    }

    var average: Int {
        return Int(answerTimes.reduce(0, (+)) / Double(answerTimes.count))
    }

    init(quiz: Quiz, coordinator: AppCoordinator) {
        self.quiz = quiz
        self.coordinator = coordinator
    }

    func retry() {
        coordinator?.retry()
    }
}
