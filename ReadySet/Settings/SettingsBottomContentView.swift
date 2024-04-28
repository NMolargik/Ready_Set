//
//  SettingsBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct SettingsBottomContentView: View {
    @AppStorage("useMetric") var useMetric: Bool = false
    @AppStorage("decreaseHaptics") var decreaseHaptics: Bool = false
    @AppStorage("disableWave") var disableWave: Bool = false
    
    let vectorURL = "https://www.vecteezy.com/free-vector/iphone-15"

    var body: some View {
        VStack {
            HStack (spacing: 0) {
                Toggle(isOn: $useMetric, label: {
                    Text("Use Metric Units")
                })
                .toggleStyle(VerticalToggleStyle(height: 90))
                
                Spacer()
                
                Toggle(isOn: $decreaseHaptics, label: {
                    Text("Decrease Haptics")
                })
                .toggleStyle(VerticalToggleStyle(height: 90))
            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            Toggle(isOn: $disableWave, label: {
                Text("Disable Water Wave Animation")
            })
            .toggleStyle(VerticalToggleStyle(height: 50))
            .padding(.top, 10)
            .padding(.horizontal)
            
            Spacer()
            
            Rectangle()
                .padding(.horizontal)
                .frame(height: 3)
                .cornerRadius(4)
                .colorMultiply(.purpleStart)
                .shadow(radius: 5)
            
            HStack {
                VStack (spacing: 0) {
                    Text("Ready, Set")
                        .bold()
                        .font(.title3)
                        .padding(.top, 5)
                    
                    Text("2024, Nicholas Molargik")
                        .font(.caption)
                    
                    Text("Contributions from nythepegasus and Dante Maslin")
                        .font(.caption)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        UIApplication.shared.open(URL(string: vectorURL)!)
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }, label: {
                        Text("iPhone 15 Vectors by Vecteezy")
                            .font(.caption)
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.blue)
                    })
                    .buttonStyle(.plain)
                    
                    Text("Version \(Bundle.main.bundleVersion)")
                        .font(.caption)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                    
                    
                    ShareLink(
                        item: URL(string: "https://apps.apple.com/app/id6484503374")!,
                        subject: Text("Ready, Set"),
                        message: Text("Check out Ready, Set - a new fitness trend tracking app!")
                    ) {
                        ZStack {
                            Capsule()
                                .foregroundStyle(.ultraThickMaterial)
                            
                            Text("Share App")
                                .bold()
                        }
                    }
                    .frame(width: 100, height: 30)
                    .padding(.top, 5)
                }
                
                Image("icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 10)

        }
    }
}

#Preview {
    SettingsBottomContentView()
}
