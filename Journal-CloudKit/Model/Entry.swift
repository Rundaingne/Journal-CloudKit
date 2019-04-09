//
//  Entry.swift
//  Journal-CloudKit
//
//  Created by Brooke Kumpunen on 4/8/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//
//Let's see...because this is also using CloudKit, we also need to create a recordID and a computed property for ckRecord. (Cloud Kit record).

import Foundation
import CloudKit

class Entry {
    
    var title: String
    var bodyText: String
    var timestamp: Date
    let recordID: CKRecord.ID
    
    //I need to create a computed property now. I will use this to create a record to store.
//    var ckRecord: CKRecord {
//        let record = CKRecord(recordType: EntryConstants.recordType, recordID: self.recordID)
//        record.setValue(self.title, forKey: EntryConstants.titleKey)
//        record.setValue(self.bodyText, forKey: EntryConstants.bodyTextKey)
//        return record
//    }
    
    init(title: String, bodyText: String, timeStamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timeStamp
        self.recordID = recordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        
        guard let title = ckRecord[EntryConstants.titleKey] as? String,
            let bodyText = ckRecord[EntryConstants.bodyTextKey] as? String,
            let timestamp = ckRecord[EntryConstants.timestampKey] as? Date else { return nil }
        self.init(title: title, bodyText: bodyText, timeStamp: timestamp, recordID: ckRecord.recordID)
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.title == rhs.title && lhs.bodyText == rhs.bodyText && lhs.timestamp == rhs.timestamp
    }
}

struct EntryConstants {
    static let recordType = "Entry"
    static let titleKey = "title"
    static let bodyTextKey = "bodyText"
    static let timestampKey = "timestamp"
}

extension CKRecord{
    convenience init(entry: Entry){
        self.init(recordType: EntryConstants.recordType, recordID: entry.recordID)
        self.setValue(entry.title, forKey: EntryConstants.titleKey)
        self.setValue(entry.bodyText, forKey: EntryConstants.bodyTextKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.timestampKey)
    }
}
