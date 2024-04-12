//
//  GestureModalView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI

struct GestureModalView: View {
    @State var selectedTab: any ITabItem = ExerciseTabItem()
    @Binding var navigationDragWidth: Double
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(selectedTab.gradient)
                .frame(height: 200)
                .cornerRadius(25)
            
            Text("Add \(navigationDragWidth) \(selectedTab.text)s")
                .foregroundStyle(.white)
               
        }
        .padding(.horizontal)
    }
}

#Preview {
    GestureModalView(navigationDragWidth: .constant(200.0))
}
