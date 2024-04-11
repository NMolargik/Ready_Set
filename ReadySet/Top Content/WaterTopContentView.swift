//
//  WaterTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct WaterTopContentView: View {
    @State var progress: CGFloat = 0.5
    @State var startAnimation: CGFloat = 0
    
    var body: some View {
        HStack (spacing: 5) {
            ZStack {
                Capsule()
                    .frame(width: 300, height: 80)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 1)
                
                WaterWave(progress: 0.2, waveHeight: 0.05, offset: startAnimation)
                    .fill(LinearGradient(colors: [.teal, .blue, .indigo], startPoint: .top, endPoint: .bottom))
                    .overlay(content: {
                        ZStack {
                            if (progress > 0.5) {
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 15, height: 15)
                                    .offset(x: -20)
                                
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 15, height: 15)
                                    .offset(x: 70, y: 10)
                                
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 25, height: 25)
                                    .offset(x: -80, y: 2)
                            }
                            
                            Rectangle()
                                .frame(width: 60, height: 40)
                                .cornerRadius(10)
                                .foregroundStyle(.ultraThinMaterial)
                                .shadow(radius: 1)
                                .offset(y: 35)
                                
                            
                            Text("90%")
                                .bold()
                                .foregroundStyle(.white)
                                .offset(y: 30)
                        }
                    })
                    .mask {
                        Capsule()
                            .frame(width: 300, height: 80)
                            .foregroundStyle(.thinMaterial)
                    }
            }
        }
        .padding(.leading, 8)
        .padding(.top, 5)
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                startAnimation = 350
            }
        }
        
    }
}

struct WaterWave: Shape {
    var progress: CGFloat
    var waveHeight: CGFloat
    var offset: CGFloat
    var animatableData: CGFloat {
        get {offset}
        set {offset = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, to: rect.width, by: 2) {
                let x: CGFloat = value
                let sine: CGFloat = sin(Angle(degrees: value + offset).radians)
                let y: CGFloat = progressHeight + (height * sine)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
        }
    }
}

#Preview {
    WaterTopContentView()
}
