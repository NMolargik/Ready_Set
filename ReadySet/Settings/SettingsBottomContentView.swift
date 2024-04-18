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
    @State var name : String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Set Your Name")
                .font(.system(size: 18, weight: .semibold))
                .lineLimit(1)
            
            Text("(This will update when you leave Settings)")
                .font(.system(size: 8, weight: .regular))
                .lineLimit(1)
                .padding(.bottom, 5)
            
            TextField("First Name", text: $name)
                .textFieldStyle(OutlinedTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom, 10)
                .onChange(of: name) { value in
                    withAnimation {
                        username = value
                    }
                }
                .onAppear {
                    name = username
                }
            
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
            
            Toggle(isOn: $disableWave, label: {
                Text("Disable Water Wave Animation")
            })
            .toggleStyle(VerticalToggleStyle(height: 50))
            .padding(.top, 10)
            .padding(.horizontal)
            
            HStack {
                VStack (spacing: 0) {
                    Text("Ready, Set")
                        .bold()
                        .font(.caption)
                        .padding(.top, 5)
                    
                    Text("2024, Nicholas Molargik")
                        .bold()
                        .font(.caption)
                    
                    Text("Contributions from nythepegasus, v1.0.0")
                        .bold()
                        .font(.caption)
                        .lineLimit(3)
                        .frame(height: 35)
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
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
            
            Spacer()

        }
    }
}

#Preview {
    SettingsBottomContentView()
}
