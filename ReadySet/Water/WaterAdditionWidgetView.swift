//
//  WaterAdditionWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI

struct WaterAdditionWidgetView: View {
    @State private var expanded = false
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            
            VStack (alignment: .trailing) {
                Button(action: {
                    withAnimation {
                        expanded.toggle()
                    }
                }, label: {
                    ZStack {
                        Rectangle()
                            .frame(width: expanded ? .infinity : 50, height: expanded ? 80 : 50)
                            .cornerRadius(expanded ? 20 : 50)
                            .foregroundStyle(WaterTabItem().gradient)
                            .shadow(radius: 4, x: 2, y: 2)
                        
                        if (!expanded) {
                            Image("Droplet")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .overlay {
                                    Image(systemName: "plus")
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                        .offset(y: 3)
                                }
                        }
                    }
                })
                .padding(.horizontal, 20)
                .disabled(expanded)
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    WaterAdditionWidgetView()
}
