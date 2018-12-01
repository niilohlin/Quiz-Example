//
// Created by Niil on 2018-04-10.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var countDownView: UIProgressView!
    @IBOutlet weak var extraTimeButton: UIButton!
    @IBOutlet weak var halfAlternativesButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var allAlternativeButtons: [UIButton] {
        return [firstButton, secondButton, thirdButton, fourthButton]
    }

    var viewModel: QuizViewModelType

    init(viewModel: QuizViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }

    required init(coder: NSCoder) {
        fatalError("incorrect initializer")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.reloadData()
        setupButtons()
        setupCountDown()
        setupLifeLines()
    }

    func setupButtons() {
        for button in allAlternativeButtons {
            button.setup()
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        }
    }

    func setupLifeLines() {
        halfAlternativesButton.addTarget(self, action: #selector(halfAlternativesButtonPressed), for: .touchUpInside)
        extraTimeButton.addTarget(self, action: #selector(extraTimeButtonPressed), for: .touchUpInside)
    }

    @objc func halfAlternativesButtonPressed() {
        viewModel.halfAlternatives()
    }

    @objc func extraTimeButtonPressed() {
        viewModel.extraTime()
    }

    func setupCountDown() {
        countDownView.layer.cornerRadius = 5
        countDownView.layer.masksToBounds = true;
        viewModel.bindCountDown { progress in
            self.countDownView.setProgress(progress, animated: true)
        }
    }

    @objc func buttonPressed(_ button: UIButton) {
        guard let index = allAlternativeButtons.index(of: button) else {
            return
        }
        viewModel.submit(answer: viewModel.alternatives[index])
    }
}

extension Alternative {
    var correspondingColor: UIColor {
        switch state {
        case .correct:
            return Constants.Colors.detail
        case .incorrect:
            return Constants.Colors.accent
        case .disabled:
            return Constants.Colors.disabled
        case .enabled:
            return Constants.Colors.secondary
        }
    }
}

extension QuizViewController: QuizViewModelDelegate {
    func viewModel(_ viewModel: QuizViewModelType, didUpdateQuestion question: Question) {
        titleLabel.text = question.title
        imageView.image = viewModel.image
        imageView.isHidden = viewModel.image == nil
    }

    func viewModel(_ viewModel: QuizViewModelType, didUpdateAlternative alternative: Alternative, atIndex index: Int) {
        allAlternativeButtons[index].setTitle(alternative.title, for: .normal)
        allAlternativeButtons[index].setBackgroundImage(UIImage.from(color: alternative.correspondingColor), for: [.normal, .disabled])
        allAlternativeButtons[index].isEnabled = alternative.state == .enabled
    }

    func viewModel(_ viewModel: QuizViewModelType, didUpdateHalfAlternatives isEnabled: Bool) {
        halfAlternativesButton.isEnabled = isEnabled
    }

    func viewModel(_ viewModel: QuizViewModelType, didUpdateExtraTime isEnabled: Bool) {
        extraTimeButton.isEnabled = isEnabled
    }

    func viewModelDidTimeout(_ viewModel: QuizViewModelType) {

    }
}
