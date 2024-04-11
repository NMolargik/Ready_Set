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
                    .frame(width: 150)
                
                Spacer()
                
                Text("R")
                    .bold()
                
                Image("TriangleIcon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.fontGray)
                    .padding(.bottom, -3)
                    .padding(.horizontal, -5)
                
                Text("S")
                    .bold()

                Spacer()
                
                HStack (spacing: 4) {
                    Text(currentWeekday())
                        .bold()
                        .font(.caption)
                        .foregroundStyle(.fontGray)
                        .textCase(.uppercase)
                    
                    Text(currentMonth())
                        .bold()
                        .font(.caption)
                        .foregroundStyle(.fontGray)

                    Text(currentDay())
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.fontGray)
                }
                .frame(width: 150)
            }
            .foregroundStyle(Color("FontGray"))
            .font(.caption)
            .padding(.vertical, 10)
            
            HStack (spacing: 0) {
                Rectangle()
                    .frame(width: 100, height: 5)
                    .foregroundStyle(selectedTab.gradient)
                    .shadow(color: selectedTab.color, radius: 5, x: 0, y: 5)

                Rectangle()
                    .frame(height: 5)
                    .foregroundStyle(.gray)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
        }
        .frame(height: 85)
        .background {
            Rectangle()
                .foregroundStyle(.ultraThinMaterial)
        }
    }
    
    func currentWeekday() -> String {
        return String(Date().formatted(Date.FormatStyle().weekday(.abbreviated)))
    }
    
    func currentMonth() -> String {
        return String(Date().formatted(Date.FormatStyle().month(.wide)))
    }

    func currentDay() -> String {
        return String(Date().formatted(Date.FormatStyle().day(.twoDigits)))
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

