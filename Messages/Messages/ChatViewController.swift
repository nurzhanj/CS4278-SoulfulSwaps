//
//  ChatViewController.swift
//  Messages
//
//  Created by CJ Rorex on 11/18/20.
//  Copyright © 2020 CJ Rorex. All rights reserved.
//

import UIKit
import MessageKit

struct Sender: SenderType { // Uses this to know if the message was sent or recieved by the users
    var senderId: String // id for the user sending the message
    var displayName: String // name displayed for the sender
}

struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    let currentUser = Sender(senderId: "self", displayName: "John")
    
    // other user sending messages in this simulation
    let otherUser = Sender(senderId: "other", displayName: "Mark")

    // Mock messages to mock what this will look like when the messages are pulled from the DB, backend, etc.
    var messages = [MessageType]()
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        // Slightly misleading, wants the number of messages that we currently have
        
        return messages.count
    }
    
    
    // 3 main concepts
    // MessageType goves all requirements for messages
        // Has a message kind
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: currentUser, messageId: "1", sentDate:Date().addingTimeInterval(-86400),kind: .text("Hello. Can we negociate the Black Nike Shirt")))
        
        messages.append(Message(sender: otherUser, messageId: "2", sentDate:Date().addingTimeInterval(-7000),kind: .text("Yes!")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
