//
//  UserRegistrationView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI

struct UserRegistrationView: View {
    @State private var name = ""
    @State private var age = 18
    
    
    var body: some View {
        VStack {
            Text("Just need a few details...")
            
            TextField("First Name", text: $name)
                .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "person.text.rectangle"), color: .orange, approved: .constant(true)))
                .textInputAutocapitalization(.never)
                .padding(.horizontal)
                .onAppear {
                    withAnimation {
                        //model.validateEmail()
                    }
                }
                .onChange(of: name) { _ in
                    withAnimation {
                       // model.validateEmail()
                    }
                }
            
//            VStack {
//                Text("Physical Information")
//                    .bold()
//                    .font(.title2)
//                    .padding(.top)
//                    .foregroundStyle(.neuText)
//
//                HStack {
//                    Text("Height")
//                        .bold()
//
//                    Image(systemName: "checkmark")
//                        .font(.title2)
//                        .foregroundStyle(.green, .white)
//                        .frame(width: 20, height: 10)
//                }
//                .padding(.top, 2)
//
//                HStack(alignment: .center) {
//                    VStack {
//                        Text(String(model.heightFeet) + " ft")
//                            .font(.title2)
//                            .padding(.horizontal)
//                            .foregroundStyle(.neuText)
//
//                        Stepper(String(model.heightFeet) + " ft", value: $model.heightFeet)
//                            .padding(.leading)
//                            .labelsHidden()
//                            .onChange(of: model.heightFeet) { value in
//                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
//                                impactMed.impactOccurred()
//                                if value == 9 {
//                                    model.heightFeet = 8
//                                }
//
//                                if value == 2 {
//                                    model.heightFeet = 3
//                                }
//                            }
//                            .padding(.trailing)
//                            .softOuterShadow()
//                        .labelsHidden()
//                    }
//
//                    VStack {
//                        Text(String(model.heightInches) + ((model.heightInches == 1) ? " inch" : " inches"))
//                            .font(.title2)
//                            .padding(.horizontal)
//                            .foregroundStyle(.neuText)
//
//                        Stepper(String(model.heightInches) + " in", value: $model.heightInches)
//                            .onChange(of: model.heightInches) { value in
//                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
//                                impactMed.impactOccurred()
//                                if value == 12 {
//                                    model.heightInches = 0
//                                }
//
//                                if value == -1 {
//                                    model.heightInches = 0
//                                }
//                            }
//                            .padding(.trailing)
//                            .softOuterShadow()
//                        .labelsHidden()
//                    }
//                }
//                .scaledToFit()
//                .padding(.bottom)
//
//                TextField("Weight (lbs)", text: $model.weight)
//                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "scalemass.fill"), color: .orange, approved: $weightApproved))
//                    .textInputAutocapitalization(.words)
//                    .keyboardType(.decimalPad)
//                    .padding(.horizontal)
//                    .onChange(of: model.weight) { _ in
//                        withAnimation {
//                            weightApproved = (Double(model.weight) ?? 0.0 > 0.0)
//                        }
//                    }
//            }
//            .padding(.horizontal)
        }
    }
}

#Preview {
    UserRegistrationView()
}
