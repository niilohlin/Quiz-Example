//
// Created by Niil on 2018-04-10.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

class Quiz: Decodable {
    let questions: [Question]
    init(questions: [Question]) {
        self.questions = questions
    }
}

class Question: Decodable {
    let title: String
    let imageUrl: String?
    let alternatives: [Alternative]
    let correctAnswer: Alternative
    var chosenAnswer: Alternative?
    var answerTime: TimeInterval?
    init(title: String, alternatives: [Alternative], correctAnswer: Alternative, imageUrl: String? = nil) {
        self.title = title
        self.alternatives = alternatives
        self.correctAnswer = correctAnswer
        chosenAnswer = nil
        answerTime = nil
        self.imageUrl = imageUrl
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        let alts = try container.decode([String].self, forKey: .alternatives)
        var allAlternatives = alts.map(Alternative.init(title:))
        let correctAnswerIndex = try container.decode(Int.self, forKey: .correctAnswer)
        correctAnswer = allAlternatives[correctAnswerIndex]
        alternatives = allAlternatives.shuffled()

    }
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case imageUrl = "imageUrl"
        case alternatives = "alternatives"
        case correctAnswer = "correctAnswer"
    }

    var isAnsweredCorrectly: Bool {
        return chosenAnswer == correctAnswer
    }

    var isAnswered: Bool {
        return chosenAnswer != nil
    }
}

class Alternative {
    let title: String
    var state: State

    init(title: String) {
        self.title = title
        self.state = .enabled
    }

    enum State {
        case correct
        case incorrect
        case disabled
        case enabled
    }
}

extension Alternative: Equatable {
    public static func == (lhs: Alternative, rhs: Alternative) -> Bool {
        return lhs.title == rhs.title && lhs.state == rhs.state
    }
}
