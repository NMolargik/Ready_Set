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
    @AppStorage("userName") var username: String = ""
    
    let link = URL(string: "www.google.com")! //TODO: change this to our App listing
    
    var body: some View {
        VStack (spacing: 0) {
            HStack (spacing: 20) {
                Toggle(isOn: $useMetric, label: {
                    Text("Use Metric Units")
                })
                .toggleStyle(VerticalToggleStyle(width: 120, height: 90))
                
                Toggle(isOn: $decreaseHaptics, label: {
                    Text("Decrease Haptics")
                })
                .toggleStyle(VerticalToggleStyle(width: 120, height: 90))
            }
            
            Toggle(isOn: $disableWave, label: {
                Text("Disable Water Animation")
            })
            .toggleStyle(VerticalToggleStyle(width: 290, height: 50))
            .padding(.vertical, 20)
            
            Text("Set Your Name")
                .font(.system(size: 18, weight: .semibold))
                .lineLimit(1)
                .padding(.vertical, 5)
            
            TextField("Name", text: $username)
                .textFieldStyle(OutlinedTextFieldStyle())
                .padding(.horizontal)
        
            Spacer()
            
            Divider()
                .padding(.horizontal)
                .scaleEffect(y: 3)
                .shadow(radius: 2, y: 2)
                .padding(.bottom, 10)
            
            legalStack
        }
        .padding(.top, 20)
    }
    
    private var legalStack: some View {
            HStack {
                VStack(alignment: .center) {
                    userText("Ready, Set", style: .title2)
                    userText("2024, Nicholas Molargik", style: .caption)
                    userText("Contributions from Nicholas Yoder", style: .caption)
                        .multilineTextAlignment(.center)
                    userText("v1.0.0", style: .caption)
                    
                    ShareLink(
                        item: link,
                        message: Text("Check out Ready, Set - a new fitness tracking app!"),
                        preview: SharePreview(
                            "Ready, Set | App Store",
                            image: Image("icon")
                        )
                    ) {
                        ZStack {
                            Capsule()
                                .frame(width: 130, height: 30)
                                .foregroundStyle(.ultraThickMaterial)
                                .shadow(color: .white, radius: 3)
                            
                            Text("Share App")
                                .bold()
                        }
                    }
                }
                .padding(.leading, 10)
                .padding(.bottom)

                Spacer()

                Image("icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
                    .padding(.top, -10)
            }
        }

        private func userText(_ text: String, style: Font) -> some View {
            Text(text)
                .bold()
                .font(style)
        }
}

#Preview {
    SettingsBottomContentView()
}
