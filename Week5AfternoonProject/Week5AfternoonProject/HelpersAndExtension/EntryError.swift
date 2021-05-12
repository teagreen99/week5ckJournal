//
//  EntryError.swift
//  Week5AfternoonProject
//
//  Created by Tim Green on 5/10/21.
//

import Foundation

enum EntryError: LocalizedError {
    
    case ckError(Error)
    case couldNotUnwrap
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .couldNotUnwrap:
            return "Entry could not be unwrapped."
        }
    }
} // End of EntryError enum
