//
//  DateExtension.swift
//  CloudKitJournal
//
//  Created by Jason Koceja on 10/6/20.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}
