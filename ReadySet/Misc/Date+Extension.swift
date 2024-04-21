//
//  Date+Extension.swift
//  ReadySet
//
//  Created by Nicholas Yoder on 4/21/24.
//

import Foundation

extension Date {
    var weekday: Int {
        if let day = Calendar.current.dateComponents([.weekday], from: self).weekday {
            return day
        } else {
            return 1
        }
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }

    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
