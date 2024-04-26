//
//  CrownRotationAdditionView.swift
//  ReadySetWatch Watch App
//
//  Created by Nick Molargik on 4/25/24.
//

import SwiftUI

struct CrownRotationAdditionView: View {
    @Binding var isTurning: Bool
    @Binding var rotation: Double
    
    var min: Double
    var max: Double
    var step: Double
    var unitOfMeasurement: String
    var addColor: Color
    var gradient: LinearGradient
    var onAdd: (Int) -> Void
    var onCancel: () -> Void
    
    var orientation = WKInterfaceDevice.current().crownOrientation
    
    var body: some View {
        VStack {
            if orientation == .left && !isTurning {
                Spacer()
            }
            
            HStack {
                if orientation == .right && !isTurning {
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    if (!isTurning) {
                        Image(systemName: "chevron.up")
                            .scaleEffect(y: 0.6)
                            .padding(.bottom, 4)
                    }
                    
                    Text("+\(Int(abs(rotation)))\(unitOfMeasurement)")
                        .focusable(true)
                        .digitalCrownRotation($rotation, from: min, through: max, by: step)
                        .opacity(rotation == 0.0 ? 0 : 100)
                        .bold()
                        .font(.system(size: 30))
                        .foregroundStyle(gradient)
                        .animation(.easeInOut, value: rotation)
                        .transition(.blurReplace())
                        .frame(width: isTurning ? 100 : 0, height: isTurning ? 40 : 0)

                    HStack(spacing: 0) {
                        Button(action: {
                            onAdd(Int(rotation))
                        }, label: {
                            Text("Add")
                                .bold()
                                .font(.system(size: isTurning ? 15 : 10))
                                .foregroundStyle(addColor)
                                .padding(.horizontal, isTurning ? 20 : 0)
                                .padding(.vertical, isTurning ? 10 : 0)
                                .frame(width: isTurning ? 80 : 20)
                                .background {
                                    if isTurning {
                                        Rectangle()
                                            .cornerRadius(10)
                                            .foregroundStyle(.white)
                                            .padding()
                                    }
                                }
                        })
                        .disabled(!isTurning)
                        .buttonStyle(.plain)
                        
                        Button(action: onCancel, label: {
                            Text("Cancel")
                                .bold()
                                .font(.system(size: isTurning ? 15 : 0))
                                .foregroundStyle(.white)
                                .padding(.horizontal, isTurning ? 5 : 0)
                                .padding(.vertical, isTurning ? 10 : 0)
                                .frame(width: isTurning ? 80 : 0)
                                .background {
                                    if isTurning {
                                        Rectangle()
                                            .cornerRadius(10)
                                            .foregroundStyle(.red)
                                            .padding()
                                    }
                                }
                        })
                        .disabled(!isTurning)
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 4)
                .frame(width: isTurning ? 150 : 30, height: isTurning ? 150 : 30)
                .background {
                    RoundedRectangle(cornerRadius: 20.0)
                        .foregroundStyle(.thinMaterial)
                }
                
                if orientation == .left && !isTurning {
                    Spacer()
                }
            }
            
            if orientation == .right && !isTurning {
                Spacer()
            }
        }
        .animation(.easeInOut, value: isTurning)
        .transition(.opacity)
    }
}
