//
// Created by Niil on 2018-04-12.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setup() {
        setTitleColor(.white, for: .normal)
        setBackgroundImage(UIImage.from(color: Constants.Colors.secondary), for: .normal)
        layer.cornerRadius = 8.0;
        layer.masksToBounds = true;
        layer.borderColor = UIColor.clear.cgColor;
        layer.borderWidth = 1;
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 0
    }
}
