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
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                ZStack {
                    dateAndGreetingView
                        .padding(.horizontal, 30)
                    triangleIcon
                }
                
                .padding(.vertical, 5)
                
                progressBar(geometry: geometry)
            }
            .foregroundStyle(.fontGray)
            .background(Material.ultraThinMaterial)
        }
        .frame(height: 85)
    }
    
    private var dateAndGreetingView: some View {
        HStack(spacing: 4) {
            Text(currentWeekday())
                .bold()
                .font(.caption)
            
            Text(currentMonth())
                .bold()
                .font(.caption)
            
            Text(currentDay())
                .bold()
                .font(.caption)
            
            Spacer()
            
            Text("Hey, \(username)")
                .bold()
                .font(.caption)
                .truncationMode(.tail)
            
        }
    }

    private var triangleIcon: some View {
        Image("TriangleIcon")
            .resizable()
            .renderingMode(.template)
            .frame(width: 20, height: 20)
            .opacity(0.7)
    }

    private func progressBar(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 5)
                .foregroundColor(.gray)
            
            Rectangle()
                .frame(width: max(geometry.size.width * min(progress, 1.0), 0), height: 5)
                .foregroundStyle(selectedTab.gradient)
                .shadow(color: selectedTab.secondaryColor, radius: 4, x: 0, y: 3)
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
    
    private func currentWeekday() -> String {
        Date().formatted(Date.FormatStyle().weekday(.abbreviated))
    }
    
    private func currentMonth() -> String {
        Date().formatted(Date.FormatStyle().month(.wide))
    }

    private func currentDay() -> String {
        Date().formatted(Date.FormatStyle().day(.twoDigits))
    }
}
// Preview
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(progress: .constant(2), selectedTab: .constant(ExerciseTabItem()))
    }
}



#Preview {
    HeaderView(progress: .constant(0.85), selectedTab: .constant(ExerciseTabItem()))
}

