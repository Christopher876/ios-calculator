//
//  ContentView.swift
//  Calculator
//
//  Created by Bofei Wang on 25/4/20.
//  Copyright © 2020 bofei. All rights reserved.
//

import SwiftUI

// calculator view splits to two main areas, display area at the top and control pannel at the bottom
// there are 2 units of space above the calculator and 1 unit of space below
struct CalculatorView: View {
    @State var currentDisplay = "0"
    @State var currentExpression = ""
    
    @State private var calculator = CalculatorModel()
    
    @State private var isDraggingHandled = false
    
    @State private var isPresentingPopover = true
    
    // callback functoin when user interacts with display area
    private func onDisplayAreaClick(_ event: DisplayAreaEvent) -> Void {
        switch event {
        case .CopyToClipBoard:
            UIPasteboard.general.string = currentDisplay
        case .Paste:
            let content = UIPasteboard.general.string
            guard content != nil else {
                return
            }
            calculator.onPaste(content!)
            currentDisplay = calculator.displayedValue
        default:
            break
        }
    }
    
    private func onDelete() {
        calculator.onDelete()
        currentDisplay = calculator.displayedValue
    }
    
    // callback function when user clicks a button in control panel
    private func onControlPanelClick(_ keyType: ButtonType) -> Void {
        switch keyType {
        case .Plus, .Minus, .Multiply, .Divide:
            calculator.onSelectOperator(keyType)
            currentExpression += "\(keyType.symbol)"
        case .Number0:
            calculator.onTypeNumber(0)
            currentExpression += "\(keyType.symbol)"
        case .Number1:
            calculator.onTypeNumber(1)
            currentExpression += "\(keyType.symbol)"
        case .Number2:
            calculator.onTypeNumber(2)
            currentExpression += "\(keyType.symbol)"
        case .Number3:
            calculator.onTypeNumber(3)
            currentExpression += "\(keyType.symbol)"
        case .Number4:
            calculator.onTypeNumber(4)
            currentExpression += "\(keyType.symbol)"
        case .Number5:
            calculator.onTypeNumber(5)
            currentExpression += "\(keyType.symbol)"
        case .Number6:
            calculator.onTypeNumber(6)
            currentExpression += "\(keyType.symbol)"
        case .Number7:
            calculator.onTypeNumber(7)
            currentExpression += "\(keyType.symbol)"
        case .Number8:
            calculator.onTypeNumber(8)
            currentExpression += "\(keyType.symbol)"
        case .Number9:
            calculator.onTypeNumber(9)
            currentExpression += "\(keyType.symbol)"
        case .Dot:
            calculator.onTypeDot()
            currentExpression += "\(keyType.symbol)"
        case .Calculate:
            calculator.onCalculate()
        case .AC:
            calculator.onAC()
            currentExpression = ""
        case .PlusMinus:
            calculator.onPlusMinus()
        case .Percentage:
            calculator.onPercentage()
        case .Delete:
            calculator.onDeleteOperator()
            currentExpression = calculator.expression
        }
        calculator.onCalculate()
        currentDisplay = calculator.displayedValue
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .trailing){
                DisplayArea(eventCallback: onDisplayAreaClick, currentDisplay: $currentDisplay, currentExpression: $currentExpression, isPresentingPopover: $isPresentingPopover)
                    .frame(maxWidth: controlPanelWidth, alignment: .trailing)
                    .padding(.trailing)
                    .frame(maxWidth: controlPanelWidth)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: buttonSize)
                            .onChanged({ value in
                                print(1)
                                guard !self.isDraggingHandled else {
                                    return
                                }
                                guard abs(value.location.y - value.startLocation.y) < buttonSize else {
                                    return
                                }
                                self.isDraggingHandled = true
                                self.onDelete()
                            })
                            .onEnded({ _ in
                                self.isDraggingHandled = false
                            })
                )
                Spacer()
                ControlPanel(clickCallback: onControlPanelClick).padding(.bottom)
//                Spacer()
            }
        }
    }
}

// this is the root view. it includes calculator
struct ContentView: View {
    var body: some View {
        CalculatorView()
            .statusBarHidden()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
