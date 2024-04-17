//
//  SettingsTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import UIKit

struct SettingsTopContentView: View {
    @AppStorage("appState") var appState: String = "splash"
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 10) {
            settingButton(action: returnToGuide,
                          labelText: "Go To\nGuide",
                          imageName: "arrowshape.turn.up.backward.2.fill",
                          imageColors: [.purple, .pink])

            settingButton(action: { showingDeleteAlert = true },
                          labelText: "Delete\nSet Data",
                          imageName: "trash.fill",
                          imageColors: [.fontGray, .fontGray])
        }
        .padding(.leading, 8)
        .padding(.top, 5)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete all of your set data records? This will remove all set completion history but leave your list of sets in place. This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    performDeleteAction()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func settingButton(action: @escaping () -> Void, labelText: String, imageName: String, imageColors: [Color]) -> some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation {
                action()
            }
        }, label: {
            ZStack {
                defaultRectangle
                HStack {
                    Spacer()
                    Text(labelText)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.fontGray)
                    Spacer()
                    Image(systemName: imageName)
                        .font(.title)
                        .foregroundStyle(imageColors[0], imageColors[1])
                    Spacer()
                }
            }
        })
        .buttonStyle(.plain)
    }

    private var defaultRectangle: some View {
        Rectangle()
            .frame(height: 80)
            .cornerRadius(10)
            .foregroundStyle(.thinMaterial)
            .shadow(radius: 1)
    }

    private func returnToGuide() {
        withAnimation {
            appState = "navigationTutorial"
        }
    }

    private func performDeleteAction() {
        withAnimation {
            exerciseViewModel.exerciseSetRecordEntryRepo.removeAll()
            exerciseViewModel.readInitial()
        }
    }
}

#Preview {
    SettingsTopContentView(exerciseViewModel: ExerciseViewModel())
}
