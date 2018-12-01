//
// Created by Niil on 2018-04-12.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum CustomError: Error {
    case notAPath
    case fileLoadingError(String)
}

class ConnectionManager {
    func getQuiz(callBack: (Result<Quiz>) -> Void) {
        do {
            guard let path = Bundle.main.path(forResource: "Quizes", ofType: "json") else {
                throw CustomError.notAPath
            }
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let quiz = try decoder.decode(Quiz.self, from: data)
            callBack(.success(quiz))
        } catch {
            callBack(.failure(error))

        }
    }
}