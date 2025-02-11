//
//  DisplayArea.swift
//  Calculator
//
//  Created by Bofei Wang on 29/4/20.
//  Copyright © 2020 bofei. All rights reserved.
//

import SwiftUI

enum DisplayAreaEvent {
    case Delete
    case CopyToClipBoard
    case Paste
}

// display area displays current result
struct DisplayArea: View {
    var eventCallback: ((DisplayAreaEvent) -> Void)?
    
    // bindind display text from calculator
    @Binding var currentDisplay: String
    @Binding var currentExpression: String
    
    @Binding var isPresentingPopover: Bool
    
    // dynamic font size for different display text length so that it does not exceed the control panel width
    var fontSize: CGFloat {
        get {
            if currentDisplay.count > 11 {
                return 70
            } else if currentDisplay.count > 9 {
                return 75
            } else if currentDisplay.count > 8 {
                return 80
            } else {
                return 100
            }
        }
    }
    
    var body: some View {
        Text(currentDisplay)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundColor(Color.white)
            .font(.system(size: fontSize))
            .contextMenu {
                Button(action: {
                    self.eventCallback?(.CopyToClipBoard)
                }) {
                    Text("Copy")
                    Image(systemName: "doc.on.doc")
                }
                Button(action: {
                    self.eventCallback?(.Paste)
                }) {
                    Text("Paste")
                    Image(systemName: "doc.on.clipboard")
                }
        }
        .id(UUID.init())
        .frame(minHeight: 120)
        
        ScrollView(.horizontal, showsIndicators: false) {
            Text(currentExpression)
                .foregroundColor(Color.white)
                .font(.system(size: fontSize / 3))
        }
        .frame(minHeight: 60)
    }
}

struct DisplayArea_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
