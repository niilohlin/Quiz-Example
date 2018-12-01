//
//  ViewController.swift
//  veritas
//
//  Created by Niil on 2018-04-10.
//  Copyright © 2018 Niil. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!

    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }

    required init(coder: NSCoder) {
        fatalError("incorrect initializer")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.setup()
        startButton.addTarget(self, action: #selector(StartViewController.startButtonPressed), for: .touchUpInside)
    }

    @objc func startButtonPressed() {
        (UIApplication.shared.delegate as? AppDelegate)?.start()
    }
}
