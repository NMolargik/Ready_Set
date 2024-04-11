//
//  ExerciseStepsWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseStepsWidgetView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 35)
                .cornerRadius(10)
                .foregroundStyle(.thinMaterial)
                .shadow(radius: 1)
            
            HStack {
                Image(systemName: "shoeprints.fill")
                
                Text("1000 / 5000")
                    .bold()
            }
            .foregroundStyle(.fontGray)
        }
    }
}

#Preview {
    ExerciseStepsWidgetView()
}
