//
//  DataController.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/12/24.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "ReadySet")

    init(){
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreData failed to load: \(error.localizedDescription)")
            }
        }
    }
}
