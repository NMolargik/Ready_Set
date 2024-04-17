//
//  ExerciseHealthWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseHealthWidgetView: View {
    var body: some View {
        
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            UIApplication.shared.open(URL(string: "x-apple-health://")!)
        }, label: {
            ZStack {
                Rectangle()
                    .frame(height: 35)
                    .cornerRadius(10)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 1)
                
                HStack {
                    Image(systemName: "heart.fill")

                    Text("Health")
                }
                .foregroundStyle(.pink)
            }
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    ExerciseHealthWidgetView()
}
