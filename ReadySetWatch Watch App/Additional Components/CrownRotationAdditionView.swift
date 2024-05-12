//
//  CrownRotationAdditionView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import SwiftUI

struct CrownRotationAdditionView: View {
    @Binding var amount: Double
    var min: Double
    var max: Double
    var step: Double
    var unitOfMeasurement: String
    var gradient: LinearGradient
    var onAdd: (Double) -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack {
            Text("+ \(Int(amount)) \(unitOfMeasurement)")
                .bold()
                .foregroundStyle(gradient)
                .font(.title2)
                .digitalCrownRotation($amount)

            Stepper(value: $amount, step: step, label: {
            })
            .colorMultiply(.baseInvert)
            .padding(.horizontal, 20)
            .onChange(of: amount) {
                if amount < min {
                    amount = min
                } else if amount > max {
                    amount = max
                }
            }

            HStack {
                Button(action: {
                    onAdd(amount)
                }, label: {
                    ZStack {
                        Rectangle()
                            .cornerRadius(10)
                            .foregroundStyle(.blue)

                        Text("Add")
                            .bold()
                            .font(.system(size: 15))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)

                    }
                })
                .frame(width: 70, height: 25)
                .buttonStyle(.plain)

                Button(action: {
                    onCancel()
                }, label: {
                    ZStack {
                        Rectangle()
                            .cornerRadius(10)
                            .foregroundStyle(.red)

                        Text("Cancel")
                            .bold()
                            .font(.system(size: 15))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 3)
                            .padding(.vertical, 10)
                    }

                })
                .frame(width: 70, height: 25)
                .buttonStyle(.plain)
            }
            .padding()
        }
        .frame(width: 155, height: 155)
        .background {
            RoundedRectangle(cornerRadius: 20.0)
                .foregroundStyle(.base)
        }
        .onAppear {
            amount = min
        }
    }
}

#Preview {
    CrownRotationAdditionView(amount: .constant(100), min: 8, max: 128, step: 8, unitOfMeasurement: "oz", gradient: WaterTabItem().gradient, onAdd: { _ in }, onCancel: {})
}
