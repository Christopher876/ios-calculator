//
//  CalculatorModel.swift
//  Calculator Model that does all the calculations under the hood, that provides APIs for views
//
//  Created by Bofei Wang on 1/5/20.
//  Copyright © 2020 bofei. All rights reserved.
//

import Foundation
import Expression

struct CalculatorModel {
    public var expression: [String] = [String]()
    private var selectedOperator: ButtonType? = nil
    private var ans: Double = 0
    private var inputs: String =  ""
    private var isError = false
    private var isNegative = false
    private var lastInput: Double = 0
    private let maxInput = 9
    private let formatterUpperBreakPoint = 999999999.9
    private let formatterLowerBreakPoint = 0.000000001
    private let decimalFormatter = NumberFormatter()
    private let scientificFormatter = NumberFormatter()
    
    init() {
        decimalFormatter.numberStyle = .decimal
        decimalFormatter.groupingSeparator = ","
        decimalFormatter.maximumIntegerDigits = maxInput
        decimalFormatter.maximumSignificantDigits = maxInput + 1
        scientificFormatter.numberStyle = .scientific
        scientificFormatter.maximumSignificantDigits = maxInput + 1
    }
    
    var displayedExpression: String {
        return self.expression.joined()
    }
    
    var displayedValue: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: ans)) ?? "0"
        }
    }
    
    var computedValue: Double {
        get {
            0
        }
    }
    
    mutating func onTypeNumber(_ number: Int) {
        print("Input number", number)
        if inputs.isEmpty {
            inputs.append(String(number))
        } else if inputs.count >= maxInput {
            // discard any additional inputs if the pool is full
            // allow one digit if the last input is a dot
            if inputs.last == "." && inputs.count <= maxInput {
                inputs.append(String(number))
            }
        } else {
            inputs.append(String(number))
        }
        if self.expression.count == 0 {
            self.expression.append(String(number))
        } else {
            self.expression[self.expression.endIndex-1] += String(number)
        }
//        self.expression += String(number)
    }
    
    mutating func onTypeDot() {
        print("dot typed")
        guard !inputs.contains(".") else {
            return
        }
        if inputs.count >= maxInput {
            // discard if pool is full
        } else if inputs.isEmpty {
            inputs.append("0.")
        } else {
            inputs.append(".")
        }
        
        let last = self.expression.endIndex - 1
        if self.expression.count == 0 || self.expression[last] == "" {
            self.expression.append("0.")
        } else {
            self.expression[last] += "."
        }
    }
    
    mutating func onAC() {
        print("AC")
        self.ans = 0
        self.expression.removeAll()
        self.inputs.removeAll()
        self.selectedOperator = nil
        self.isNegative = false
        self.isError = false
        self.lastInput = 0
    }
    
    mutating func onDeleteOperator() {
        var last = self.expression.endIndex - 1
        if self.expression[last].count == 1 {
            let _ = self.expression.popLast()
            print("Popped entire element")
        } else if self.expression[last] == "" {
            self.expression.popLast()
            self.expression.popLast()
        }
        else {
            let _ = self.expression[last].popLast()
            print("Popped string")
        }
    }
    
    mutating func onSelectOperator(_ selectedOperator: ButtonType) {
        self.selectedOperator = selectedOperator
        self.expression.append(selectedOperator.symbol)
        self.expression.append("")
        inputs.removeAll()
    }
    
    mutating func onEqual() {
        self.expression.removeAll()
        self.expression.append(NSNumber(value: ans).stringValue)
    }
    
    mutating func onCalculate() {
        var inputNumber = Double(inputs) ?? 0
        if isNegative {
            inputNumber.negate()
        }
        
        isNegative = false
//        inputs.removeAll()
        
        lastInput = inputNumber
        guard !isError else {
            return
        }
        
        print("Evaluating \(self.expression)")
        let expr = self.expression.joined()
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        let expression = Expression(expr)
        do {
            ans = try expression.evaluate()
            print("Answer: \(ans)")
        } catch {
            print("Failed to evaluate")
        }
    }
    
    mutating func onPlusMinus() {
        print("plusminus")
        if ans != 0 {
            ans = -ans
        } else {
            self.isNegative.toggle()
        }
    }
    
    mutating func onPercentage() {
        // TODO Handle this being empty
        lastInput = Double(self.expression.last!)!
        if isNegative {
            lastInput.negate()
        }
        
        isNegative = false
        inputs.removeAll()
        
        if lastInput != 0 {
            ans = lastInput / 100
            lastInput = 0
        } else {
            ans /= 100
        }
        self.expression[self.expression.endIndex-1] = String(ans)
        print("Percentage: \(self.expression)")
    }
    
    mutating func onDelete() {
        print("onDelete")
        guard !inputs.isEmpty else {
            return
        }
        _ = inputs.popLast()
        print(inputs)
    }
    
    mutating func onPaste(_ content: String) {
        var parsedContent: Double? = Double(content)
        print("Content: \(parsedContent)")
        guard parsedContent != nil else {
            return
        }
        
        //TODO Do some input validation here
        self.expression[self.expression.endIndex - 1] += content
        print("Pasted: \(self.expression)")
//        if abs(parsedContent!) > formatterUpperBreakPoint || abs(parsedContent!) < formatterLowerBreakPoint {
//
//        } else {
//            if parsedContent! < 0 {
//                isNegative = true
//                parsedContent?.negate()
//            }
//            inputs = String(parsedContent!).trimmingCharacters(in: CharacterSet.init(charactersIn: ".0"))
//        }
        isError = false
    }
    
    private mutating func recordAns() {
        ans = Double(inputs) ?? 0
        if isNegative {
            isNegative = false
            ans = -ans
        }
        markNoError()
    }
    
    private mutating func markNoError() {
        self.isError = false
    }
}
