//
//  HeaderView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct HeaderView: View {
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        VStack (spacing: 0) {
            Spacer()
            
            HStack {
                Text("Hey, Nicholas")
                    .bold()
                    .frame(width: 100)
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image("TriangleIcon")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .shadow(radius: 2, x: 1, y: 1)
                        .foregroundColor(.fontGray)
                })
                .padding(.bottom, -3)

                Spacer()
                
                Text("Weather")
                    .bold()
                    .frame(width: 100)
            }
            .foregroundStyle(Color("FontGray"))
            .font(.caption)
            .padding(.vertical, 15)
            .padding(.horizontal)
            
            HStack (spacing: 0) {
                Rectangle()
                    .frame(width: 100, height: 5)
                    .foregroundStyle(selectedTab.gradient)
                    .shadow(color: selectedTab.color, radius: 5, x: 0, y: 5)

                Rectangle()
                    .frame(height: 5)
                    .foregroundStyle(.fontGray)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            
        }
        .frame(height: 90)
        .background {
            Rectangle()
                .foregroundStyle(.ultraThinMaterial)
        }
    }
}

struct RoundedTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let length = min(rect.size.width, rect.size.height)
        let triangleHeight = length * sqrt(3.0) / 2.0
        let xOffset = (rect.size.width - length) / 2
        let yOffset = (rect.size.height - triangleHeight) / 2
        
        let startPoint = CGPoint(x: rect.midX, y: rect.minY + yOffset)
        
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: rect.minX + xOffset, y: rect.maxY - yOffset))
        path.addLine(to: CGPoint(x: rect.maxX - xOffset, y: rect.maxY - yOffset))
        path.addLine(to: startPoint)
        
        return path
    }
}


#Preview {
    HeaderView(selectedTab: .constant(ExerciseTabItem()))
}

