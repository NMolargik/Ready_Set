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
    
    let link = URL(string: "www.google.com")! //TODO: change this to our App listing
    
    var body: some View {
        VStack (spacing: 0) {
            Text("Set Your Name")
                .font(.system(size: 18, weight: .semibold))
                .lineLimit(1)
                .padding(.bottom, 5)
            
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
            .padding(.bottom, 20)
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
