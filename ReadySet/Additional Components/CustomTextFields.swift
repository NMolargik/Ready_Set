//
//  CustomTextFields.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI

struct OutlinedTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme
    @State var icon: Image?
    @State var color: Color?
    @FocusState var isFocused: Bool

    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if icon != nil {
                icon
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 10)
                    .padding(.trailing, 3)
            }
            configuration
                .foregroundStyle(.fontGray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color(UIColor.separator), lineWidth: 1)
                .shadow(radius: 3, x: 1, y: 1)
                .opacity(0.9)
            

        )
        .focused($isFocused)
        .onTapGesture {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            isFocused = true
        }
        .padding(.bottom, 3)
    }
}

