//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by Jason Koceja on 10/5/20.
//

import Foundation
import CloudKit

class EntryController {
    
    static let shared = EntryController()
    
    var entries: [Entry] = []
    let privateDB = CKContainer(identifier: "iCloud.com.koceja.dvmtn.CKContainer").privateCloudDatabase
    
    // create
    
    func createEntryWith(title: String, body: String, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        let newEntry = Entry(title: title, body: body)
        save(entry: newEntry) { (result) in
            switch result {
                case .success(let entry):
                    return completion(.success(entry))
                case .failure(let error):
                    print("Error [\(#function):\(#line)] -- \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.ckError(error)))
            }
        }
    }
    
    // save
    
    func save(entry: Entry, completion: @escaping(_ result:Result<Entry?,EntryError>) -> Void) {
        let entryRecord = CKRecord(entry: entry)
        privateDB.save(entryRecord) { (record, error) in
            if let error = error {
                print("Error [\(#function):\(#line)] -- \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                  let savedEntry = Entry(ckRecord: record) else {
                return completion(.failure(.couldNotUnwrap))
            }
            
            self.entries.insert(savedEntry, at: 0)
            return completion(.success(savedEntry))
        }
        
    }
    
    
    // fetch
    
    func fetchEntriesWith(completion: @escaping(_ result:Result<[Entry]?,EntryError>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.keyRecordType, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error [\(#function):\(#line)] -- \(error.localizedDescription) \n---\n \(error)")
            }
            
            guard let records = records else {
                return completion(.failure(.couldNotUnwrap))
                
            }
            let entries = records.compactMap({ Entry(ckRecord: $0) })
            self.entries = entries
            return completion(.success(entries))
            
            
        }
    }
}
