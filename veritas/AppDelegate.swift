//
//  AppDelegate.swift
//  veritas
//
//  Created by Niil on 2018-04-10.
//  Copyright © 2018 Niil. All rights reserved.
//

import UIKit

protocol AppCoordinator: class {
    func finish(quiz: Quiz)
    func start()
    func retry()
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let startViewController = StartViewController()
        let navigationController = UINavigationController(rootViewController: startViewController)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate: AppCoordinator {
    func start() {
        let connectionManager = ConnectionManager()
        connectionManager.getQuiz { result in
            guard case .success(let quiz) = result else {
                return
            }
            let viewModel = QuizViewModel(quiz: quiz, coordinator: self)
            let quizViewController = QuizViewController(viewModel: viewModel)
            (window?.rootViewController as? UINavigationController)?.pushViewController(quizViewController, animated: true)
        }

    }

    func finish(quiz: Quiz) {
        let finishedViewModel = FinishedViewModel(quiz: quiz, coordinator: self)
        let finishedViewController = FinishedViewController(viewModel: finishedViewModel)
        (window?.rootViewController as? UINavigationController)?.pushViewController(finishedViewController, animated: true)
    }

    func retry() {
        (window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
    }
}
