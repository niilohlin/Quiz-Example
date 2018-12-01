//
// Created by Niil on 2018-04-11.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import XCTest
@testable import veritas

extension Question: Equatable {
    public static func ==(lhs: Question, rhs: Question) -> Bool {
        return lhs.title == rhs.title
    }
}

class QuizViewModelDelegateStub: QuizViewModelDelegate {
    func viewModel(_ viewModel: QuizViewModelType, didUpdateHalfAlternatives isEnabled: Bool) {

    }

    func viewModel(_ viewModel: QuizViewModelType, didUpdateExtraTime isEnabled: Bool) {

    }

    var didUpdateQuestion: Question?
    var didUpdateAlternatives = [Int: Alternative]()

    func viewModel(_ viewModel: QuizViewModelType, didUpdateQuestion question: Question) {
        didUpdateQuestion = question
    }

    func viewModel(_ viewModel: QuizViewModelType, didUpdateAlternative alternative: Alternative, atIndex index: Int) {
        didUpdateAlternatives[index] = alternative
    }
    func viewModelDidTimeout(_ viewModel: QuizViewModelType) {

    }
}

class AppCoordinatorStub: AppCoordinator {

    func finish(quiz: Quiz) {

    }
    func start() {

    }
    func retry() {

    }
}

class QuizViewModelTests: XCTestCase {
    var quiz: Quiz!

    override func setUp() {
        super.setUp()
        let alternatives = [
            Alternative(title: "1 m"),
            Alternative(title: "Very long"),
            Alternative(title: "Not so long"),
            Alternative(title: "Looooooooooooooong johnson")
        ]
        let question = Question(
                title: "How long is a rope?",
                alternatives: alternatives,
                correctAnswer: alternatives[0]
        )
        quiz = Quiz(questions: [question])
    }

    func testInitWithQuiz_presentsFirstQuestion() {
        let viewModel = QuizViewModel(quiz: quiz, coordinator: AppCoordinatorStub())
        let delegate = QuizViewModelDelegateStub()
        viewModel.delegate = delegate
        viewModel.reloadData()

        XCTAssertEqual(delegate.didUpdateQuestion, quiz.questions[0])
    }

    func testAnswer_changesAlternativeState() {
        let viewModel = QuizViewModel(quiz: quiz, coordinator: AppCoordinatorStub())
        let delegate = QuizViewModelDelegateStub()
        viewModel.delegate = delegate
        viewModel.reloadData()

        viewModel.submit(answer: viewModel.alternatives[0])

        XCTAssertNotEqual(delegate.didUpdateAlternatives[0]?.state ?? .enabled, .enabled)
    }
}
