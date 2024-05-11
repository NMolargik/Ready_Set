//
//  UserView.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/10/24.
//

import SwiftUI

struct UserView: View {
    @Environment(\.managedObjectContext)
    private var context

    @FetchRequest(sortDescriptors: [])
    private var user: FetchedResults<User>

    @State private var username: String = ""
    @State private var age: Int16 = 0
    @State private var height: Float = 0.0
    @State private var weight: Float = 0.0

    var body: some View {
        VStack {
            TextField("Username", text: $username)
            Stepper("Age: \($age.wrappedValue)", value: $age)
            Stepper("Height: \($height.wrappedValue)", value: $height)
            Stepper("Weight: \($weight.wrappedValue)", value: $weight)
            Button(action: {

                if user.count == 1 {
                    let us = user[0]
                    if us.name != $username.wrappedValue {
                        us.name = $username.wrappedValue
                    }
                    if us.age != $age.wrappedValue {
                        us.age = $age.wrappedValue
                    }
                    if us.height != $height.wrappedValue {
                        us.height = $height.wrappedValue
                    }
                    if us.weight != $weight.wrappedValue {
                        us.weight = $weight.wrappedValue
                    }
                } else {
                    let us = User(context: context)

                    us.uuid = UUID()
                    us.name = $username.wrappedValue
                    us.age = $age.wrappedValue
                    us.height = $height.wrappedValue
                    us.weight = $weight.wrappedValue
                }
                try? context.save()
            }, label: {Text("Add User")})
            .padding()
            List {
                ForEach(user, id: \.self) { u in
                    if let uuid = u.uuid {
                        Text(uuid.uuidString)
                    }
                    Text("\(u.name ?? "")")
                    Text("\(u.age)")
                    Text("\(u.height)")
                    Text("\(u.weight)")
                }
            }
        }
    }
}

#Preview {
    UserView()
}
