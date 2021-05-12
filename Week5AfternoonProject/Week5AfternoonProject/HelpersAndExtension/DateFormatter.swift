//
//  DateFormatter.swift
//  Week5AfternoonProject
//
//  Created by Tim Green on 5/10/21.
//

import Foundation

extension Date {
    
    func formatToString() -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}  // End of Date extension
