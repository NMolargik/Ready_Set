//
//  VerticalToggleStyle.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/16/24.
//

import Foundation
import SwiftUI

struct VerticalToggleStyle: ToggleStyle {
    var width: CGFloat
    var height: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        return VStack(alignment: .leading) {
            configuration.label
                .font(.system(size: 18, weight: .semibold))
                .lineLimit(2)
            
            HStack {
                if configuration.isOn {
                    Text("On")
                } else {
                    Text("Off")
                }
                Spacer()
                Toggle(configuration).labelsHidden()
            }
        }
        .frame(width: width, height: height)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(configuration.isOn ? Color.green: Color.purple, lineWidth: 2)
                .shadow(radius: 2)
        )
    }
}
