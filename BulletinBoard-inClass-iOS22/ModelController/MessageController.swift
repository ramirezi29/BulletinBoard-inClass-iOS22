//
//  MessageController.swift
//  BulletinBoard-inClass-iOS22
//
//  Created by Ivan Ramirez on 11/5/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

//messageCell
import Foundation
import CloudKit

// NOTE: - In practice youll want to create a network manager / cloudkit manger like how Nick taught

class MessageController {
    
    static let shared = MessageController()
    
    var message: [Message] = []
    
    // NOTE: - How we actually access the dataBase
    //public, the data shared by all the users
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    // NOTE: - We are making this a Bool completion bc we are using a Source of Truth. our goal is to just let the person know, was the func call successfull or not
    //In the paramaters, we're going to put in text that we get from the view controller (the text field, the user inputs the text with)
    //The bool is just saying, everything is done now. and the table view is like, cool i can refresh my tableView now
    
    func saveNewMessage(with text: String, completion: @escaping (Bool) -> Void) {
        
        // Create a new message object
        let newMessage = Message(text: text)
        // NOTE: - We dont add to the array, until we know it was successfully saved to the server.
        // which means we dont add the 'append(newMEssage) syntaxt in here
        
        // Bundle tup our message so that we can save it to the dataBase
        // a ckRecord is just created
        let messageAsRecord = CKRecord(message: newMessage)
        
        publicDatabase.save(messageAsRecord) { (_, error) in
            if let error = error {
                
                print("\n\n🚀 There was an error with saving the record in: \(#file) \n\n \(#function); \n\n\(error); \n\n\(error.localizedDescription) 🚀\n\n")
                completion(false)
                return
            }
            
            // save the message to the array, var message: [Message] = []
            // the serve gets updated, but we also need to update the users device's array/data
            self.message.append(newMessage)
            completion(true)
        }
        
    }
    
    
    func fetchAllMessages(completion: @escaping (Bool) ->Void) {
        
        // NOTE: - value: true, maans you want all message objects from the database
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: Message.messageTypeKey, predicate: predicate)
        
        publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("\n\n🚀 There was an error with fetching the messages from the databas in: \(#file) \n\n \(#function); \n\n\(error); \n\n\(error.localizedDescription) 🚀\n\n")
                completion(false)
                return
            }
            guard let records = records else {completion(false); return}
            
            //place to put the messages
            // NOTE: - Replace the phones array with this array
            var messagesFromFetch: [Message] = []
            
            // NOTE: - Faliable initializer
            for record in records {
                guard let message = Message(ckRecord: record)else {completion(false); return}
                messagesFromFetch.append(message)
            }
            // NOTE: - The for loop above could be replaced by compact Map
            //self.messages = records.compactMap { Message(ckRecord: $0) }
            // NOTE: - Setting the source of truth the array that we just created from our fetch
            self.message = messagesFromFetch
            completion(true)
        }
    }
}

