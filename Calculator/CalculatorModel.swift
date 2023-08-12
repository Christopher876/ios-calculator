//
//  CalculatorModel.swift
//  Calculator Model that does all the calculations under the hood, that provides APIs for views
//
//  Created by Bofei Wang on 1/5/20.
//  Copyright © 2020 bofei. All rights reserved.
//

import Foundation
import Expression

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

struct CalculatorModel {
    public var expression: [String] = [String]()
    public var variables: [Expression.Symbol: Expression.SymbolEvaluator] = [Expression.Symbol: Expression.SymbolEvaluator]()
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
            return decimalFormatter.string(from: NSNumber(value: ans)) ?? "0"
        }
    }
    
    var computedValue: Double {
        get {
            0
        }
    }
    
    mutating func onTypeNumber(_ number: Int) {
        print("Input number", number)
        if self.expression.count == 0 {
            self.expression.append(String(number))
        } else {
            self.expression[self.expression.endIndex-1] += String(number)
        }
    }
    
    mutating func onTypeVariable(_ variable: Variable) {
        if self.expression.count == 0 {
            self.expression.append(variable.name)
        } else {
            self.expression[self.expression.endIndex-1] += variable.name
        }
    }
    
    mutating func onSetVariable(_ variable: Variable) {
        print("Setting \(variable.name) to \(variable.value)")
    }
    
    mutating func onTypeDot() {
        let last = self.expression.endIndex - 1
        if self.expression.count == 0 || self.expression[last] == "" {
            self.expression.append("0.")
        } else {
            self.expression[last] += "."
        }
    }
    
    mutating func onAC() {
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
        } else if self.expression[last] == "" {
            let _ = self.expression.popLast()
            let _ = self.expression.popLast()
        }
        else {
            let _ = self.expression[last].popLast()
        }
    }
    
    mutating func onSelectOperator(_ selectedOperator: ButtonType) {
        self.selectedOperator = selectedOperator
        self.expression.append(selectedOperator.symbol)
        self.expression.append("")
        inputs.removeAll()
    }
    
    mutating func onEqual() {
        let num = decimalFormatter.string(for: ans)
        self.expression.removeAll()
        self.expression.append(NSNumber(value: ans.rounded(toPlaces: 5)).stringValue)
    }
    
    mutating func onCalculate() {
        var inputNumber = Double(inputs) ?? 0
        if isNegative {
            inputNumber.negate()
        }
        
        isNegative = false
        
        print("Evaluating \(self.expression)")
        let expr = self.expression.joined()
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        
//        var bar = 7.0 // variable
//        var foo = 3.0
//        self.variables[.variable("c")] = { _ in bar }
//        self.variables[.variable("d")] = { _ in foo }
        
        let expression = Expression(expr, symbols: self.variables)
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
        let parsedContent: Double? = Double(content)
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
