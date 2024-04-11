//
//  ExerciseHealthWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct ExerciseHealthWidgetView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 35)
                .cornerRadius(10)
                .foregroundStyle(.thinMaterial)
                .shadow(radius: 1)
            
            HStack {
                Image(systemName: "list.bullet.clipboard.fill")
                    .foregroundStyle(.fontGray)
                
                Text("Open Health")
                    .bold()
                    .foregroundStyle(.fontGray)
            }
        }
        
    }
}

#Preview {
    ExerciseHealthWidgetView()
}
