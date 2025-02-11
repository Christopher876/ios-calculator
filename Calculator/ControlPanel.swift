//
//  ControlPanel.swift
//  Calculator
//  Displays all control buttons including numbers and operators
//
//  Created by Bofei Wang on 29/4/20.
//  Copyright © 2020 bofei. All rights reserved.
//

import SwiftUI

// the size and gap of buttons, to be calculated in run time based on screen size
// the strategy to calculate the size of buttons, is to find the shortest side of the screen (height or width) and divide the total screen length by 7 (5 row of buttons + 2 rows of spacing)
var buttonGapSize: CGFloat = (UIScreen.main.bounds.height > UIScreen.main.bounds.width) ?
    (UIScreen.main.bounds.width / 50) :
    (UIScreen.main.bounds.height / 50)
var buttonSize: CGFloat = (UIScreen.main.bounds.height > UIScreen.main.bounds.width) ?
((UIScreen.main.bounds.width - 4 * buttonGapSize) / 5.25):
((UIScreen.main.bounds.height - 4 * buttonGapSize) / 5.25)

var controlPanelWidth = 5 * buttonSize + 3 * buttonGapSize

// add a initialiser by hex color
// https://stackoverflow.com/a/56894458/12208834
extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

struct ControlPanel: View {
    var clickCallback: ((ButtonType) -> Void)?
    var variableCallback: ((Variable) -> Void)?
    
    // colours
    private let BGGray = Color(hex: 0xa5a5a5)
    private let BGHoverGray = Color(hex: 0xd9d9d9)
    
    private let BGDarkGray = Color(hex: 0x333333)
    private let BGHoverDarkGray = Color(hex: 0x737373)
    
    private let BGOrange = Color(hex: 0xff9f06)
    private let BGHoverOrange = Color(hex: 0xfcc88d)
    private let BGRed = Color(.red)
    
    private let FGWhite = Color(.white)
    private let FGBlack = Color(.black)
    
    // the operator that is selected. nil if not selecting
    @State private var selectedOperator: ButtonType? = nil
    @State private var showModal = false
    
    // callback function for buttons on click
    private func onButtonClick(_ buttonType: ButtonType) -> Void {
        switch buttonType {
        case .Divide, .Multiply, .Minus, .Plus:
            self.selectedOperator = buttonType
        case .Equal:
            self.selectedOperator = nil
        default:
            break
        }
        self.clickCallback?(buttonType)
    }
    
    private func onVariableClick(_ variable: Variable) -> Void {
        self.variableCallback?(variable)
    }
    
    private func onModalClick(_ buttonType: ButtonType) -> Void {
        showModal = true
    }
    
    var body: some View {
        // here are a list of 5 rows of buttons, each row of button includes the specific buttons, and defines their symbol, colors and all of its properties
        VStack(spacing: buttonGapSize) {
                HStack {
                    CalculatorButton(image: Image(systemName: "plus"), BG: Color.green, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Plus, selectedOperator: $selectedOperator, callback: onButtonClick)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<10) { index in
                                let variableName = String(Character(UnicodeScalar(UInt8(98 + index))))
                                let randomValue = Double.random(in: 0...100)
                                
                                VariableButton(variable: Variable(name: variableName, value: randomValue as NSNumber), callback: onVariableClick)
                            }
                        }
                    }
                    .mask(
                        HStack(spacing: 0) {
                            // Left gradient
                            LinearGradient(gradient:
                               Gradient(
                                   colors: [Color.black.opacity(0), Color.black]),
                                   startPoint: .leading, endPoint: .trailing
                               )
                               .frame(width: 10)
                            // Middle -- This is for the content in the hstack
                            Rectangle().fill(Color.black)
                        }
                     )
                }
            
            HStack(spacing: buttonGapSize) {
                CalculatorButton(text: "AC", BG: BGGray, FG: FGBlack, BGHover: BGHoverGray, operatorType: ButtonType.AC, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(image: Image(systemName: "plus.slash.minus"), BG: BGGray, FG: FGBlack, BGHover: BGHoverGray, operatorType: ButtonType.PlusMinus, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(text: "(", BG: BGGray, FG: FGBlack, BGHover: BGHoverGray, operatorType: ButtonType.LeftParenthesis, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(text: ")", BG: BGGray, FG: FGBlack, BGHover: BGHoverGray, operatorType: ButtonType.RightParenthesis, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(image: Image(systemName: "divide"), BG: BGOrange, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Divide, selectedOperator: $selectedOperator, callback: onButtonClick)
            }
            HStack(spacing: buttonGapSize) {
                CalculatorButton(text: "7", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number7, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(text: "8", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number8, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(text: "9", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number9, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(image: Image(systemName: "multiply"), BG: BGOrange, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Multiply, selectedOperator: $selectedOperator, callback: onButtonClick)
            }
            HStack(spacing: buttonGapSize) {
                CalculatorButton(text: "4", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number4, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(text: "5", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number5, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(text: "6", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number6, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(image: Image(systemName: "minus"), BG: BGOrange, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Minus, selectedOperator: $selectedOperator, callback: onButtonClick)
            }
            HStack(spacing: buttonGapSize) {
                CalculatorButton(text: "1", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number1, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(text: "2", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number2, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(text: "3", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number3, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(image: Image(systemName: "plus"), BG: BGOrange, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Plus, selectedOperator: $selectedOperator, callback: onButtonClick)
            }
            HStack(spacing: buttonGapSize) {
                CalculatorButton(text: "0", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Number0, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(text: ".", BG: BGDarkGray, FG: FGWhite, BGHover: BGHoverDarkGray, operatorType: ButtonType.Dot, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(text: "%", BG: BGGray, FG: FGBlack, BGHover: BGHoverGray, operatorType: ButtonType.Percentage, selectedOperator: $selectedOperator, callback: onButtonClick)
                CalculatorButton(image: Image(systemName: "equal"), BG: BGOrange, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Equal, selectedOperator: $selectedOperator, callback: onButtonClick)
            }
            HStack(spacing: buttonGapSize) {
                //TODO this needs to be the settings button
                CalculatorButton(image: Image(systemName: "gear"), BG: BGGray, FG: FGBlack, BGHover: BGHoverOrange, operatorType: ButtonType.Equal, selectedOperator: $selectedOperator, callback: onModalClick)
                //TODO This needs to be the history button
                CalculatorButton(image: Image(systemName: "clock.arrow.circlepath"), BG: BGGray, FG: FGBlack, BGHover: BGHoverOrange, operatorType: ButtonType.Equal, selectedOperator: $selectedOperator, callback: onModalClick)
                CalculatorButton(image: Image(systemName: "ellipsis"), BG: BGGray, FG: FGBlack, BGHover: BGHoverOrange, operatorType: ButtonType.Equal, selectedOperator: $selectedOperator, callback: onModalClick)
                //TODO This needs to handle deleting
                CalculatorButton(image: Image(systemName: "delete.backward"), BG: BGRed, FG: FGWhite, BGHover: BGHoverOrange, operatorType: ButtonType.Delete, selectedOperator: $selectedOperator, callback: onButtonClick)
            }
        }
        .sheet(isPresented: $showModal) {
            ModalCalcs(isPresented: $showModal)
                .presentationDetents([.medium, .large])
        }
    }
}


struct ControlPanel_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanel()
    }
}
