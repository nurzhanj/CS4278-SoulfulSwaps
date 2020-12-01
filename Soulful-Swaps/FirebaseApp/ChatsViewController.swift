import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind

}

extension MessageKind{
    var messageKindString: String{
        switch self{
        
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attr_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
}

struct Sender: SenderType{
    var senderId: String
    
    var displayName: String
    
}


class ChatsViewController: MessagesViewController {
    
    public func safeEmail(with email: String) -> String{
        var safe = email.replacingOccurrences(of: "@", with: "-")
        safe = safe.replacingOccurrences(of: ".", with: "-")
        return safe
    }
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    public var isNewConvo = false
    public let otherUserEmail: String
    private var messages = [Message]()
    private var selfSender: Sender? = {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        return Sender(senderId: email as! String, displayName: "John Doe")

    }()
    
    

    init(with email: String){
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .red

        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    

}

extension ChatsViewController: InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        let selfSender = self.selfSender,
        let messageID = createMessageID() else{
            return
        }
        
        print("Sending \(text)")
        //send message
        if isNewConvo{
            //create convo in db
            let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .text(text))
            DatabaseManager.shared.createNewConvo(with: otherUserEmail, name: self.title ?? "User", firstMessage: message, completion: {
                success in
                if success{
                    print("message sent")
                }
                else{
                    print("failed to send")
                }
            })
        }
        else{
            //append to existing convo data
        }
    }
    
    private func createMessageID() -> String? {
        
        
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") else{
            return nil
        }
        
        let myEmail = safeEmail(with: currentUserEmail as! String)
        
        let dateString = Self.dateFormatter.string(from: Date())
        
        let newID = "\(otherUserEmail)_\(myEmail)_\(dateString)"
        return newID
    }
    
}

extension ChatsViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    
    func currentSender() -> SenderType {
        if let sender = selfSender{
            return sender
        }
        fatalError("message sender is nil, email should be cached")
        return Sender(senderId: "1", displayName: "1")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
