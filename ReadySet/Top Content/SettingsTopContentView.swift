//
//  SettingsTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct SettingsTopContentView: View {
    var body: some View {
        HStack (spacing: 5) {
            ExerciseStatWidgetView()
            
            VStack (spacing: 5) {
                ExerciseStepsWidgetView()
                
                ExerciseHealthWidgetView()
            }
        }
        .padding(.leading, 8)
        .padding(.top, 5)
        .frame(height: 85)
        
    }
}

#Preview {
    SettingsTopContentView()
}
