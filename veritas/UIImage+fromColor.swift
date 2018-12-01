//
// Created by Niil on 2018-04-11.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = img else {
            fatalError("Could not create image from color")
        }
        return image
    }
}

