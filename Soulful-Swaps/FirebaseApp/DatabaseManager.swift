//
//  DatabaseManager.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/30/20.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference();
    
    public func safeEmail(with email: String) -> String{
        var safe = email.replacingOccurrences(of: "@", with: "-")
        safe = safe.replacingOccurrences(of: ".", with: "-")
        return safe
    }
    
    public func insertUser(with user: User,
                           completion: @escaping ((Bool) -> Void)){
        var safe = user.username?.replacingOccurrences(of: ".", with: "-")
        safe = user.username?.replacingOccurrences(of: "#", with: "-")
        safe = user.username?.replacingOccurrences(of: "$", with: "-")
        safe = user.username?.replacingOccurrences(of: "[", with: "-")
        safe = user.username?.replacingOccurrences(of: "]", with: "-")
        safe = user.username?.replacingOccurrences(of: "@", with: "-")
        safe = user.username?.replacingOccurrences(of: " ", with: "-")
        database.child(user.safeEmail).setValue([
            "username":safe
        ], withCompletionBlock: {error, _ in
            guard error == nil else{
                print("db write failed")
                completion(false)
                return
            }
            
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]]{
                //append to user dict
                    let newElement = [
                        "username": user.username!,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    
                    self.database.child("users").setValue(usersCollection, withCompletionBlock: {
                        error, _ in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
                else{
                    //create dict
                    let newCollection: [[String: String]] = [[
                        "username": user.username!,
                        "email": user.safeEmail
                    ]]
                    
                    self.database.child("users").setValue(newCollection, withCompletionBlock: {
                        error, _ in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            
            })
            
            
        })
    }
    
    public func userExists(with email: String, completion: @escaping((Bool) -> Void)){
        
        database.child(email).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else{
                completion(.failure(DBError.failedToFetch))
                return
            }
            
            completion(.success(value))
        })
    }
    
    public enum DBError: Error{
        case failedToFetch
    }
    
}

extension DatabaseManager{
    
    public func createNewConvo(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void){
        //create new convo with target user email and first message sent
        
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let currentUsername = UserDefaults.standard.value(forKey: "username") as? String
        else{
            return
        }
        
        let updatedEmail = safeEmail(with: currentEmail)
        
        print(updatedEmail)
        
        let ref = database.child("\(updatedEmail)")
        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found")
                return
            }
            
            let messageDate = firstMessage.sentDate
            let dateString = ChatsViewController.dateFormatter.string(from: messageDate)
            
            var message = ""
            
            switch firstMessage.kind{
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let convoID = "conversation_\(firstMessage.messageId)"
            let newConvoData: [String: Any] = [
                "ID": convoID,
                "other_user_email": otherUserEmail,
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "isRead": false
                ]
            
            ]
            
            let recipientNewConvoData: [String: Any] = [
                "ID": convoID,
                "other_user_email": updatedEmail,
                "name": currentUsername,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "isRead": false
                ]
            
            ]
            //update recipient entry
            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                if var conversations = snapshot.value as? [[String: Any]]{
                    //append
                    conversations.append(recipientNewConvoData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipientNewConvoData])
                }
                else{
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipientNewConvoData])
                }
            })
            
            // update current user convo entry
            if var conversations = userNode["conversations"] as? [[String: Any]]{
                //convo array exists, append
                
                conversations.append(newConvoData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: { [weak self]
                    error, _ in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    self?.finishCreatingConvo(conversationID: convoID, name: name, firstMessage: firstMessage, completion: completion)
                })
                
            }
            else{
                
                //convo array doesn't exist, create it
                userNode["conversations"] = [
                    newConvoData
                ]
                
                ref.setValue(userNode, withCompletionBlock: { [weak self]
                    error, _ in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    
                    self?.finishCreatingConvo(conversationID: convoID, name: name, firstMessage: firstMessage, completion: completion)
                })
                
            }
        })
    }
    
    private func finishCreatingConvo(conversationID: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void){
        
//        "id": String,
//        "type": text, photo, video,
//        "content": String,
//        "date": Date()
//        "sender_email": String,
//        "isRead" : Bool
        
        
        var content = ""
        
        switch firstMessage.kind{
        case .text(let messageText):
            content = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        let messageDate = firstMessage.sentDate
        let dateString = ChatsViewController.dateFormatter.string(from: messageDate)
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else{
            completion(false)
            return
        }
        
        let currentUserEmail = safeEmail(with: myEmail)
        
        let message: [String: Any] = [
        
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": content,
            "date": dateString,
            "sender_email": currentUserEmail,
            "isRead" : false,
            "name": name
            
        ]
        let value: [String: Any] = [
            
            "messages": [
                message
            ]
        
        ]
        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else{
                completion(false)
                return
            }
            completion(true)
        })
        
    }
    
    public func getAllConvos(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void){
        //fetches and returns all convos
        database.child("\(email)/conversations").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                print("failed to fetch convos")
                return
            }
            
            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationID = dictionary["ID"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["isRead"] as? Bool else{
                    return nil
                }
                
                let latestMessageObject = LatestMessage(date: date, text: message, isRead: isRead)
                return Conversation(id: conversationID, name: name, otherUserEmail: otherUserEmail, latestMessage: latestMessageObject)
                
            })
            completion(.success(conversations))
        })
    }
    
    public func getAllMessagesForConvo(with id: String, completion: @escaping (Result<[Message], Error>) -> Void){
        //get all messages in a convo
        database.child("\(id)/messages").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                print("failed to fetch msgs")
                return
            }
            
            let messages: [Message] = value.compactMap({ dictionary in
                    guard let name = dictionary["name"] as? String,
                          let isRead = dictionary["isRead"] as? Bool,
                          let messageId = dictionary["id"] as? String,
                          let content = dictionary["content"] as? String,
                          let senderEmail = dictionary["sender_email"] as? String,
                          let dateString = dictionary["date"] as? String,
                          let type = dictionary["type"] as? String,
                          let date = ChatsViewController.dateFormatter.date(from: dateString) else{
                            return nil}
                
                let sender = Sender(senderId: senderEmail, displayName: name)
                return Message(sender: sender, messageId: messageId, sentDate: date, kind: .text(content))
                        
                
                })
            completion(.success(messages))
        })
    }
    
    public func sendMessage(to conversation: String, name: String, message: Message, completion: @escaping (Bool) -> Void){
        //sends a message to a pre-existing convo
        database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else{
                return
            }
            guard var currentMessages = snapshot.value as? [[String: Any]] else{
                print("check here 1")
                completion(false)
                return
            }
            
            var content = ""
            
            switch message.kind{
            case .text(let messageText):
                content = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let messageDate = message.sentDate
            let dateString = ChatsViewController.dateFormatter.string(from: messageDate)
            
            guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else{
                print("check here 2")
                completion(false)
                return
            }
            
            let currentUserEmail = strongSelf.safeEmail(with: myEmail)
            
            let message: [String: Any] = [
            
                "id": message.messageId,
                "type": message.kind.messageKindString,
                "content": content,
                "date": dateString,
                "sender_email": currentUserEmail,
                "isRead" : false,
                "name": name
                
            ]
            
            currentMessages.append(message)
            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages, withCompletionBlock: { error, _ in
                guard error == nil else{
                    print("check here 3")
                    completion(false)
                    return
                }
                completion(true)
            })
            
        })
        
        
        
    }
    
}
