//
//  ExerciseStatWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseStatWidgetView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 75)
                .cornerRadius(10)
                .foregroundStyle(.thinMaterial)
                .shadow(radius: 1)
        
            VStack (alignment: .leading) {
                Text("Sets Recorded: 1000")
                
                Text("Sets Recorded: 1000")
                
                Text("Sets Recorded: 1000")
                
                Text("Sets Recorded: 1000")
                    
            }
            .font(.caption)
            .foregroundStyle(.fontGray)
        }
        .frame(width: 150)
    }
}

#Preview {
    ExerciseStatWidgetView()
}
