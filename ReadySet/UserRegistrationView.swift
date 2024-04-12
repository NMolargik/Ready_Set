//
//  UserRegistrationView.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/11/24.
//

import SwiftUI

struct UserRegistrationView: View {
    @State private var name = ""
    @State private var age = 18
    
    
    var body: some View {
        VStack {
            Text("Just need a few details...")
            
            TextField("First Name", text: $name)
                .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "person.text.rectangle"), color: .orange, approved: .constant(true)))
                .textInputAutocapitalization(.never)
                .padding(.horizontal)
                .onAppear {
                    withAnimation {
                        //model.validateEmail()
                    }
                }
                .onChange(of: name) { _ in
                    withAnimation {
                        // model.validateEmail()
                    }
                }
        }
    }
}

#Preview {
    UserRegistrationView()
}
