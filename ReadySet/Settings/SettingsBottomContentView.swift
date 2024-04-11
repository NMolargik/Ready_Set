//
//  SettingsBottomContentView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI

struct SettingsBottomContentView: View {
    let link = URL(string: "www.google.com")! //TODO: change this!!!
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(35)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 1)
            
            VStack {
                Text("User Information")
                    .bold()
                    .foregroundStyle(.fontGray)
                    .font(.title2)
                
                Rectangle()
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 5)
                
                Divider()
                    .padding(.horizontal)
                    .scaleEffect(y: 3)
                
                HStack {
                    VStack {
                        Text("Ready, Set")
                            .bold()
                            .foregroundStyle(.fontGray)
                            .font(.title2)
                        
                        Text("2024, Nicholas Molargik")
                            .bold()
                            .foregroundStyle(.fontGray)
                            .font(.caption)
                        
                        Text("v1.0.0")
                            .bold()
                            .foregroundStyle(.fontGray)
                            .font(.caption)
                        
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
                                    .frame(width: 100, height: 30)
                                    .foregroundStyle(.ultraThickMaterial)
                                    .shadow(color: .purpleEnd, radius: 3)
                                
                                Text("Share")
                                    .foregroundStyle(.fontGray)
                            }
                        }
                        
                    }
                    .padding(.horizontal, 10)
                    
                    Image("icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 175)
                        .padding(.top, -10)
                }
                .frame(height: 150)
            }
            .padding(.top)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 15)
    }
}

#Preview {
    SettingsBottomContentView()
}
