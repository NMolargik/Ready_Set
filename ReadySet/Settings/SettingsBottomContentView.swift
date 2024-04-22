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
            
            Divider()
                .padding(.horizontal)
                .scaleEffect(y: 3)
                .shadow(radius: 5)
            
            HStack {
                VStack (spacing: 0) {
                    Text("Ready, Set")
                        .bold()
                        .font(.title3)
                        .padding(.top, 5)
                    
                    Text("2024, Nicholas Molargik")
                        .font(.caption)
                    
<<<<<<< HEAD
                    Text("Contributions from nythepegasus and Dante Maslin\n v1.0.0")
=======
                    Text("Contributions from nythepegasus and Dante Maslin\nv\(Bundle.main.bundleVersion)")
>>>>>>> f9285fc60e79dd742b3d8a060b8eca495c063b6e
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
