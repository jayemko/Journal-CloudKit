//
//  EntryError.swift
//  CloudKitJournal
//
//  Created by Jason Koceja on 10/5/20.
//

import Foundation

enum EntryError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
}
