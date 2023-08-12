//
//  VariableButton.swift
//  Calculator
//
//  Created by Christopher Williams on 8/12/23.
//  Copyright © 2023 bofei. All rights reserved.
//

import SwiftUI

struct Variable {
    var name: String
    var value: NSNumber
}

struct VariableButton: View {
    @State var variable: Variable
    var callback: ((Variable) -> Void)?
    
    var body: some View {
        Button(action: {}) {
            Text("\(variable.name)=\(variable.value.doubleValue, specifier: "%.2f")")
                .font(.title2)
                .bold()
        }
        .buttonStyle(.borderedProminent)
        .simultaneousGesture(
            LongPressGesture()
                .onEnded { _ in
                    print("Loooong")
                }
        )
        .highPriorityGesture(
            TapGesture()
                .onEnded { _ in
                    print("Tap")
                    self.callback?(self.variable)
                }
        )
    }
}
