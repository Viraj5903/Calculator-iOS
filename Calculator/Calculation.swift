//
//  Calculation.swift
//  Calculator
//
//  Created by english on 2024-02-09.
//

import Foundation

class Calculatoion{
    static func calculation(_ num1: Double) -> (() -> Double, (Double) -> Void, (Double) -> Void, (Double) -> Void, (Double) -> Void) {
        var result = num1

        let add: (Double) -> Void = { num2 in
            result += num2
        }

        let multiplication: (Double) -> Void = { num2 in
            result *= num2
        }

        let subtraction: (Double) -> Void = { num2 in
            result -= num2
        }

        let division: (Double) -> Void = { num2 in
            result /= num2
        }

        let getResult: () -> Double = {
            return result
        }

        return (getResult, add, subtraction, multiplication, division)
    }
}
