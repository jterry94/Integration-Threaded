//
//  operators.swift
//  Neutron Shielding
//
//  Created by Jeff Terry on 2/3/17.
//  Copyright © 2020 Jeff Terry. All rights reserved.
//

import Cocoa

infix operator ↑: BitwiseShiftPrecedence
extension Double {
    static func ↑ (left: Double, right: Double) -> Double {
        return pow(left, right)
    }
}


postfix operator ❗️
extension Double {
    static postfix func ❗️(left: Double) -> Double {
        return left*tgamma(left)
    }
}
extension Int {
    static postfix func ❗️(left: Int) -> Int {
        return left*Int(tgamma(Double(left)))
    }
}


class operators: NSObject {

}
