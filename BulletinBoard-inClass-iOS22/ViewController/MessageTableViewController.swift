//
//  MessageTableViewController.swift
//  BulletinBoard-inClass-iOS22
//
//  Created by Ivan Ramirez on 11/5/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1️⃣ notication tapped
        // NOTE: - The code for this is in the app delegage
        // NOTE: - Add ourself as an observer for the remoteNotifciation Recieved notifciation, listening for the School Bell 🔔
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMessages), name: AppDelegate.remoteNotificationRecieved, object: nil)
    }
    
    //2️⃣ notication tapped
    @objc func refreshMessages() {
        MessageController.shared.fetchAllMessages { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // NOTE: -
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MessageController.shared.message.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        // NOTE: - Getting the message out of the array at that given index path
        let message = MessageController.shared.message[indexPath.row]
        
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = "\(message.timestampAsString)"
        
        return cell
    }
    
    // MARK: - Oulets
    @IBAction func postButtonTapped(_ sender: Any) {
        
        //Test Print
        print("\n\npost button tapped\n\n")
        
        // Step 1 - Unwrap the text from the message text field
        guard let text = messageTextField.text, !text.isEmpty else {return}
        messageTextField.resignFirstResponder()
        messageTextField.text = ""
        
        MessageController.shared.saveNewMessage(with: text) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
