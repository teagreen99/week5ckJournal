//
//  EntryController.swift
//  Week5AfternoonProject
//
//  Created by Tim Green on 5/10/21.
//

import Foundation
import CloudKit


class EntryController {
    
    // MARK: - Properties
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - SHARED INSTANCE
    static let sharedInstance = EntryController()
    
    // MARK: - SOURCE OF TRUTH
    var entries: [Entry] = []
    
    // MARK: - CRUD Functions
    func createEntryWith(title: String, body: String, completion: @escaping(Result<Entry?, EntryError>) -> Void) {
        let entry = Entry(title: title, body: body)
        save(entry: entry, completion: completion)
    } // End of CREATE function
    
    func save(entry: Entry, completion: @escaping(Result<Entry?, EntryError>) -> Void) {
        
        let entryRecord = CKRecord(entry: entry)
        privateDB.save(entryRecord) { record, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record else { return completion(.failure(.couldNotUnwrap)) }
            let entry = Entry(ckRecord: record)
            if let entry = entry {
                self.entries.append(entry)
                completion(.success(entry))
            }
        }
    } // End of SAVE function
    
    func fetchEntriesWith(completion: @escaping(Result<[Entry], EntryError>) -> Void) {
        
        let fetchAllEntries = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: fetchAllEntries)
        privateDB.perform(query, inZoneWith: nil) {records, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
            let entries = records.compactMap( {Entry(ckRecord: $0)} )
            self.entries = entries
            completion(.success(entries))
        }
    } // End of FETCH function
} // End of EntryController class

