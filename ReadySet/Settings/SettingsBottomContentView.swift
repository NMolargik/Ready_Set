//
//  SettingsBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct SettingsBottomContentView: View {
    let link = URL(string: "www.google.com")! //TODO: change this to our App listing
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(35)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 1)
            
            VStack (spacing: 0) {
                //TODO: insert some settings, like haptics
                
                Spacer()
                
                Divider()
                    .padding(.horizontal)
                    .scaleEffect(y: 3)
                
                legalStack
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 15)
    }
    
    private var legalStack: some View {
            HStack {
                VStack(alignment: .center) {
                    userText("Ready, Set", style: .title2)
                    userText("2024, Nicholas Molargik", style: .caption)
                    userText("Contributions from Nicholas Yoder", style: .caption)
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
            .frame(height: 150)
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
