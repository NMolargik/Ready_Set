//
//  HeaderView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import Foundation

struct HeaderView: View {
    @AppStorage("userName") var username: String = ""
    @Binding var progress: Double
    @Binding var selectedTab: any ITabItem
    
    var body: some View {
        GeometryReader() { geometry in
            VStack (spacing: 0) {
                Spacer()
                
                ZStack {
                    HStack (spacing: 4) {
                        Text(currentWeekday())
                            .bold()
                            .font(.caption)
                            .foregroundStyle(.fontGray)
                            .padding(.leading, 30)
                        
                        Text(currentMonth())
                            .bold()
                            .font(.caption)
                            .foregroundStyle(.fontGray)
                        
                        Text(currentDay())
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.fontGray)
                        
                        Spacer()
                        
                        Text("Hey, \(username)")
                            .bold()
                            .truncationMode(.tail)
                            .padding(.trailing, 30)
                    }
                    
                    Image("TriangleIcon")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.primary)
                        .padding(.bottom, -3)
                        .padding(.horizontal, -5)
                        .shadow(radius: 1, y: 1)
                        .opacity(0.7)
                    
                    Spacer()
                }
                .foregroundStyle(Color("FontGray"))
                .font(.caption)
                .padding(.vertical, 10)
                
                ZStack (alignment: .leading) {
                    Rectangle()
                        .frame(height: 5)
                        .foregroundStyle(.gray)
                        .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    
                    Rectangle()
                        .frame(width: min(geometry.size.width * max(progress, 0.05), geometry.size.width), height: 5)
                        .foregroundStyle(selectedTab.gradient)
                        .shadow(color: selectedTab.secondaryColor, radius: 5, x: 0, y: 5)
                        .animation(.easeInOut, value: progress)
                }
                
            }
            .frame(height: 85)
            .background {
                Rectangle()
                    .foregroundStyle(.ultraThinMaterial)
            }
        }
        .frame(height: 85)
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
    HeaderView(progress: .constant(0.85), selectedTab: .constant(ExerciseTabItem()))
}

