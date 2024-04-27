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
                
                VStack(spacing: 5) {
                    if (!isTurning) {
                        Image(systemName: "digitalcrown.arrow.clockwise")
                            .padding(.bottom, 4)
                    }
                    
                    Text("+ \(Int(abs(rotation)))\(unitOfMeasurement)")
                        .focusable(true)
                        .digitalCrownRotation($rotation, from: min, through: max, by: step)
                        .opacity(rotation == 0.0 ? 0 : 100)
                        .bold()
                        .shadow(color: .black, radius: 1, x: 1, y: 1)
                        .font(.system(size: 30))
                        .foregroundStyle(gradient)
                        .animation(.easeInOut, value: rotation)
                        .frame(width: isTurning ? 120 : 0, height: isTurning ? 40 : 0)
                        .padding(.bottom, isTurning ? 8 : 0)

                    HStack(spacing: isTurning ? 8 : 0) {
                        Button(action: {
                            onAdd(Int(rotation))
                        }, label: {
                            ZStack {
                                if isTurning {
                                    Rectangle()
                                        .cornerRadius(10)
                                        .foregroundStyle(addColor)
                                }

                                Text("Add")
                                    .bold()
                                    .font(.system(size: isTurning ? 15 : 10))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, isTurning ? 12 : 0)
                                    .padding(.vertical, isTurning ? 10 : 0)
                                    
                            }
                        })
                        .frame(width: isTurning ? 70 : 20, height: isTurning ? 25 : 0)
                        .disabled(!isTurning)
                        .buttonStyle(.plain)
                        
                        Button(action: onCancel, label: {
                            ZStack {
                                if isTurning {
                                    Rectangle()
                                        .cornerRadius(10)
                                        .foregroundStyle(.red)
                                }
                                
                                Text("Cancel")
                                    .bold()
                                    .font(.system(size: isTurning ? 15 : 0))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, isTurning ? 3 : 0)
                                    .padding(.vertical, isTurning ? 10 : 0)
                            }
                            
                        })
                        .frame(width: isTurning ? 70 : 0, height: isTurning ? 25 : 0)
                        .disabled(!isTurning)
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 4)
                .frame(width: isTurning ? 160 : 30, height: isTurning ? 110 : 30)
                .background {
                    RoundedRectangle(cornerRadius: 20.0)
                        .foregroundStyle(isTurning ? .white : .clear)
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
