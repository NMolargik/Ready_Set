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
            RoundedRectangle(cornerRadius: 25)
                .stroke(.purpleStart, lineWidth: 2)
                .shadow(radius: 2)
                .opacity(0.9)

        )
        .focused($isFocused)
        .onTapGesture {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            isFocused = true
        }
        .padding(.bottom, 3)
    }
}
