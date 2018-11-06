//
//  messageModel.swift
//  BulletinBoard-inClass-iOS22
//
//  Created by Ivan Ramirez on 11/5/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation
import CloudKit


class Message {
    
    // MARK: - Constants
    let text: String
    let timestamp: Date
    
    static let messageTypeKey = "Message"
    
    
    // NOTE: - No one else needs to access these properites outside of this file
    fileprivate static let textKey = "text"
    fileprivate static let timestampKey = "timestamp"
    
    // MARK: - Computed property for date
    var timestampAsString: String {
        return DateFormatter.localizedString(from: timestamp, dateStyle: .short, timeStyle: .none)
    }
    
    init(text: String) {
        
        // NOTE: - Self is the new instance of the message text
        self.text = text
        self.timestamp = Date()
    }
    
    // NOTE: - Create a model object fromR a CKRecord -- 🔥Fetch
    init?(ckRecord: CKRecord) {
        //Unwrapped the values, and tell the compiler what the properties mean
        //🍕 1unpack the values that i want from the CKREcord
        guard let text = ckRecord[Message.textKey] as? String,
            let timestamp = ckRecord[Message.timestampKey] as? Date
            else {return nil }
        
        //🍕 Set tthose values as my initial values for my new instance
        self.text = text
        self.timestamp = timestamp
    }
}

// NOTE: - Create a CKRecord using our model object -- 🔥Push
extension CKRecord {
    
    convenience init(message: Message) {
        // NOTE: - Usually we would want to use the init with recordID
        // In this example we are using a simplified version
        self.init(recordType: Message.messageTypeKey)
        self.setValue(message.text, forKey: Message.textKey)
        self.setValue(message.timestamp, forKey: Message.timestampKey)
    }
}
