//
// Created by Niil on 2018-04-11.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

class FinishedViewController: UIViewController {
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var fastestLabel: UILabel!
    @IBOutlet weak var slowestLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    var viewModel: FinishedViewModelType

    init(viewModel: FinishedViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }

    required init(coder: NSCoder) {
        fatalError("incorrect initializer")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        percentageLabel.text = "\(viewModel.percentage)%"
        averageLabel.text = "\(viewModel.average)s"
        fastestLabel.text = "\(viewModel.fastest)s"
        slowestLabel.text = "\(viewModel.slowest)s"
        retryButton.setup()
        retryButton.addTarget(self, action: #selector(retryButtonPressed), for: .touchUpInside)
    }

    @objc func retryButtonPressed() {
        viewModel.retry()
    }
}

