//
//  FitnessAlertButtonsView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct FitnessAlertButtonsView: View {
    @Binding var showAlert: Bool
    var installURL = "https://apps.apple.com/us/app/fitness/id1208224953"
    
    var body: some View {
        Button("Install", role: .cancel) {
            UIApplication.shared.open(URL(string: installURL)!)
        }
        Button("Cancel", role: .destructive) {
            showAlert = false
        }
    }
}

#Preview {
    FitnessAlertButtonsView(showAlert: .constant(true))
}
