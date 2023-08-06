//
//  ModalCalcs.swift
//  Calculator
//
//  Created by Christopher Williams on 8/6/23.
//  Copyright © 2023 bofei. All rights reserved.
//

import SwiftUI

struct ModalCalcs: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("This is a modal view")
            Button("Dismiss") {
                isPresented = false
            }
        }
        .padding()
    }
}
struct ModalCalcs_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        ModalCalcs(isPresented: $isPresented)
    }
}
