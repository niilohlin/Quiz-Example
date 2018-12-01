//
// Created by Niil on 2018-04-12.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

extension MutableCollection {
    mutating func shuffle() {
        let c = count
        guard c > 1 else {
            return
        }

        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {

            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
