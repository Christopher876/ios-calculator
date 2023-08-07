//
//  Button.swift
//  Calculator button, implements a specific single button based on the custom properties
//
//  Created by Bofei Wang on 29/4/20.
//  Copyright © 2020 bofei. All rights reserved.
//

import SwiftUI

// All possible button types 
enum ButtonType {
    case Plus
    case Minus
    case Multiply
    case Divide
    case Number0
    case Number1
    case Number2
    case Number3
    case Number4
    case Number5
    case Number6
    case Number7
    case Number8
    case Number9
    case Dot
    case Equal
    case AC
    case PlusMinus
    case Percentage
    case Delete
    case LeftParenthesis
    case RightParenthesis
    
    var symbol: String {
        switch self {
        case .Plus: return "+"
        case .Minus: return "-"
        case .Multiply: return "×"
        case .Divide: return "÷"
        case .Number0: return "0"
        case .Number1: return "1"
        case .Number2: return "2"
        case .Number3: return "3"
        case .Number4: return "4"
        case .Number5: return "5"
        case .Number6: return "6"
        case .Number7: return "7"
        case .Number8: return "8"
        case .Number9: return "9"
        case .Dot: return "."
        case .Equal: return "="
        case .AC: return "AC"
        case .PlusMinus: return "+/-"
        case .Percentage: return "%"
        case .Delete: return ""
        case .LeftParenthesis: return "("
        case .RightParenthesis: return ")"
        }
    }
}

struct CalculatorButton: View {
    
    // optionally to have an symbol image. if the image is given, use the image. otherwise a symbol text must be given
    var image: Image?
    var text: String = ""
    
    // background and foreground colors, can be customised
    var BG: Color = .gray
    var FG: Color = .white
    
    // animated on click colors, optional
    // if not provided, the foregroundColor/backgroundColor will be used instead so no color animations will be observed
    var BGHover: Color?
    var FGHover: Color?
    
    // the number of columns it spans. by default the width is 1 unit of button. Must be an integer. customisation is optional, only customise it when you know what you are doing
    // e.g. if the span is 2, it spans to 2 units of button widths. an example is the "0" button of the calculator that spans 2 units.
    var horizontalSpan: CGFloat = 1.0
    
    // the operator type of the button instance
    let operatorType: ButtonType
    
    // the selected operator type is controled in ControlPanel
    @Binding var selectedOperator: ButtonType?
    
    // button on click callback
    var callback: ((ButtonType) -> Void)?
    
    // tracing if the button is currently on hovering
    @State private var isTouching = false
    
    // computed spanned width for internal use
    private var spannedWidth: CGFloat {
        get {
            buttonSize * horizontalSpan + (horizontalSpan - 1) * buttonGapSize
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            // by default the background is a circle when the span is 1
            // if the span is more than 1, it becomes a rectangle with half circles on the left and right
            Text("")
                .cornerRadius(buttonSize / 2)
                .frame(width: spannedWidth, height: buttonSize)
                .background(self.isTouching ? (BGHover ?? BG) : BG)
                .animation(self.isTouching ? nil : .spring())
                .cornerRadius(buttonSize / 2)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ (touch) in
                            let isOutsideView = (touch.location.y < 0 || touch.location.x < 0 || touch.location.y > buttonSize || touch.location.x > self.spannedWidth)
                            let isIntsideView = (touch.location.y >= 0 && touch.location.x >= 0 && touch.location.y <= buttonSize && touch.location.x <= self.spannedWidth)
                            if self.isTouching && isOutsideView {
                                self.onMoveOutView()
                            } else if !self.isTouching && isIntsideView {
                                self.onMoveIntoView()
                            }
                        })
                        .onEnded({ (touch) in
                            self.onMoveEnd()
                            }
                    )
            )
            Group {
                // use image if given, otherwise use text
                // dont think too much about these magic numbers, they are adjusted to fit the sizes of images and texts so that they look like to have a same size
                if image != nil {
                    image?
                        .resizable()
                        .scaledToFit()
                        .frame(width: buttonSize / 3, height: buttonSize / 3)
                        .padding(buttonSize / 3)
                        .foregroundColor(FG)
                        .animation(.spring())
                    
                } else {
                    Text(text)
                        .frame(width: buttonSize / 2, height: buttonSize / 2)
                        .font(.system(size: 500))
                        .minimumScaleFactor(0.01)
                        .padding(buttonSize / 4)
                        .foregroundColor(FG)
                        .animation(.spring())
                }
            }
        }
    }
    
    // figure moves out of button display area
    private func onMoveIntoView() {
        self.isTouching = true
    }
    
    // figure moves into button display area
    private func onMoveOutView() {
        self.isTouching = false
    }
    
    // move ended, if figure is inside button display area, call the callback function. Reset is touching to false
    private func onMoveEnd() {
        if self.isTouching {
            self.callback?(self.operatorType)
        }
        self.isTouching = false
    }
}

struct CalculatorButton_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanel()
    }
}
