//
//  CalorieTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct CalorieTopContentView: View {
    var body: some View {
        HStack (spacing: 5) {
            ExerciseStatWidgetView()
            
            ExerciseStatWidgetView()
        }
        .padding(.leading, 8)
        .padding(.top, 5)
        .frame(height: 85)
        
    }
}

#Preview {
    CalorieTopContentView()
}
