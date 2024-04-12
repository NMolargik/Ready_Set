//
//  SettingsTopContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct SettingsTopContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack (spacing: 10) {
            Button(action: {
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
                
                withAnimation {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        DispatchQueue.main.async {
                            UIApplication.shared.open(appSettings)
                        }
                    }
                }
            }, label: {
                ZStack {
                    Rectangle()
                        .frame(height: 60)
                        .cornerRadius(10)
                        .foregroundStyle(.thinMaterial)
                        .shadow(radius: 1)
                    
                    HStack {
                        Spacer()
                        
                        Text("Privacy\nSettings")
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.fontGray)
                        
                        Spacer()
                        
                        Image(systemName: "hand.raised.slash.fill")
                            .font(.title)
                            .foregroundStyle(.pink, .purple)
                        
                        Spacer()
                    }
                }
            })
            
            Button(action: {
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
                
                withAnimation {
                    //TODO:
                }
            }, label: {
                ZStack {
                    Rectangle()
                        .frame(height: 60)
                        .cornerRadius(10)
                        .foregroundStyle(.thinMaterial)
                        .shadow(radius: 1)
                    
                    HStack {
                        Spacer()
                        
                        Image(systemName: "trash.fill")
                            .font(.title)
                            .foregroundStyle(.purple, .pink)
                        
                        Spacer()
                        
                        Text("Delete\nData")
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.fontGray)
                        Spacer()
                    }
                    
                }
            })
        }
        .padding(.leading, 8)
        .padding(.top, 5)
    }
}

#Preview {
    SettingsTopContentView()
}
