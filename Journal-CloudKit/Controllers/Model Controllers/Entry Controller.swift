//
//  Entry Controller.swift
//  Journal-CloudKit
//
//  Created by Brooke Kumpunen on 4/8/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    static let shared = EntryController()
    private init() {}
    
    //Got the singleton. Now let's create a save function for saving to CloudKit. As well as a fetchFromCloudKit function. AND, let's create an extension on Date!
    
    //Oh, also, source of truth.
    var entries: [Entry] = []
    
    //CRUD:
    
    //create
    func createEntry(title: String, bodyText: String, completion: @escaping (Entry?) -> Void) {
//        let entry = Entry(title: title, bodyText: bodyText)
//        entries.append(entry)
        saveEntryToCK(title: title, bodyText: bodyText, completion: completion)
    }
    
    //update
    func updateEntry(entry: Entry, newTitle: String, newBody: String, completion: @escaping (Entry?) -> Void) {
        entry.title = newTitle
        entry.bodyText = newBody
        entry.timestamp = Date()
        saveEntryToCK(title: newTitle, bodyText: newBody, completion: completion)
    }
    
    //delete
    func deleteEntry(entry: Entry, completion: @escaping (Entry?) -> Void) {
        guard let index = entries.index(of: entry) else {return}
        entries.remove(at: index)
        CKContainer.default().publicCloudDatabase.delete(withRecordID: entry.recordID) { (ckRecord, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
        }
    }
    
    func saveEntryToCK(title: String, bodyText: String, completion: @escaping (Entry?) -> Void) {
        let entry = Entry(title: title, bodyText: bodyText)
        //This next line is super important. This is where we turn the entry into a record. This is the part we are saving.
        let record = CKRecord(entry: entry)
        CKContainer.default().publicCloudDatabase.save(record) { (ckRecord, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            //Alright, now let's check to see if we have a record.
            guard let ckRecord = ckRecord,
            //Then define an entry from a ckrecord, and then complete with it.
            let entry = Entry(ckRecord: ckRecord) else {completion(nil); return}
            self.entries.append(entry)
            completion(entry)
        }
    }
    
    func fetchAllEntries(completion: @escaping ([Entry]?) -> Void) {
        //In order to fetch, I need a predicate and a query. The predicate sorts the query items, remember
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordType, predicate: predicate)
        //Got 'em. Use the recordType of the entry as the recordType variable. Easy.
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            //If we've got here, let's check to see if we have some records.
            guard let records = records else {completion(nil); return}
            let entries = records.compactMap{ Entry(ckRecord: $0) }
            self.entries = entries
            completion(entries)
        }
    }
}
