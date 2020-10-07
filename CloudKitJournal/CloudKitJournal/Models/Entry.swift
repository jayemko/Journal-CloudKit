//
//  Entry.swift
//  CloudKitJournal
//
//  Created by Jason Koceja on 10/5/20.
//

import Foundation
import CloudKit

struct EntryConstants {
    static let keyTitle = "title"
    static let keyBody = "body"
    static let keyTimestamp = "timestamp"
    static let keyRecordType = "Entry"
}

class Entry {
    let title: String
    let body: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.keyTitle] as? String,
              let body = ckRecord[EntryConstants.keyBody] as? String,
              let timestamp = ckRecord[EntryConstants.keyTimestamp] as? Date else { return nil }
        self.init(title: title, body: body, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.keyRecordType, recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: EntryConstants.keyTitle)
        self.setValue(entry.body, forKey: EntryConstants.keyBody)
        self.setValue(entry.timestamp, forKey: EntryConstants.keyTimestamp)
    }
}
