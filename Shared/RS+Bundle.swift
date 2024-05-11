//
//  RS+Bundle.swift
//  ReadySet
//
//  Created by nythepegasus on 5/11/24.
//

import Foundation

extension Bundle {
    var groupID: String {
        return Bundle.main.object(forInfoDictionaryKey: "GroupID") as! String
    }
}
