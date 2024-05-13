//
//  Bundle+Extension.swift
//  ReadySet
//
//  Created by Nick Molargik on 5/12/24.
//

import Foundation

extension Bundle {
    var bundleVersion: String {
        return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
