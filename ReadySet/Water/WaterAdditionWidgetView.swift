//
//  WaterAdditionWidgetView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI

struct WaterAdditionWidgetView: View {
    @ObservedObject var waterViewModel: WaterViewModel
    
    @State private var expanded = false
    
    @State private var waterToAdd = ""
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            
            VStack (alignment: .trailing) {
                Button(action: {
                    withAnimation {
                        if (!expanded) {
                            expanded.toggle()
                        }
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
                        } else {
                            HStack {
                                TextField("Add Water", text: $waterToAdd)
                                    .tint(.white)
                                
                                Button(action: {
                                    withAnimation {
                                        if let water = Double($waterToAdd.wrappedValue) {
                                            waterViewModel.addWater(waterOunces: water)
                                        } else {
                                            print("Couldn't parse \($waterToAdd.wrappedValue)")
                                        }
                                        // Call for water addtion
                                        waterToAdd = ""
                                        expanded = false
                                    }
                                }, label: {
                                    Text("Add")
                                })
                                
                                Button(action: {
                                    withAnimation {
                                        waterToAdd = ""
                                        expanded = false
                                    }
                                }, label: {
                                    Text("Cancel")
                                })
                            }
                        }
                    }
                })
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    WaterAdditionWidgetView(waterViewModel: WaterViewModel())
}
