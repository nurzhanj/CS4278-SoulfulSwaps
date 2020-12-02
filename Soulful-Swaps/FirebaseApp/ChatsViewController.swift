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
    
    public static func safeEmail(with email: String) -> String{
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
    private let conversationID: String?
    private var messages = [Message]()
    private var selfSender: Sender? = {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let mEmail = safeEmail(with: UserDefaults.standard.value(forKey: "email") as! String)
        return Sender(senderId: mEmail, displayName: "Me")

    }()

    init(with email: String, id: String?){
        self.otherUserEmail = email
        self.conversationID = id
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
        if let convoID = conversationID {
            listenForMessages(id: convoID, shouldScrollToBottom: true)
        }
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool){
        DatabaseManager.shared.getAllMessagesForConvo(with: id, completion: { [weak self] result in
            switch result{
            case .success(let messages):
                guard !messages.isEmpty else{
                    return
                }
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    if shouldScrollToBottom{
                        self?.messagesCollectionView.scrollToBottom()
                    }
                }
                
                
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
        })
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
        let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .text(text))
        if isNewConvo{
            //create convo in db
            DatabaseManager.shared.createNewConvo(with: otherUserEmail, name: self.title ?? "User", firstMessage: message, completion: { [weak self]
                success in
                if success{
                    print("message sent")
                    self?.messageInputBar.inputTextView.text = nil
                    self?.isNewConvo = false
                }
                else{
                    print("failed to send")
                }
            })
        }
        else{
            
            guard let convID = conversationID, let name = self.title else{
                return
            }
            //append to existing convo data
            DatabaseManager.shared.sendMessage(to: convID, name: name, message: message, completion: {
                success in
                if success{
                    self.messageInputBar.inputTextView.text = nil
                    print("message sent to preexisting convo")
                }
                else{
                    print("failed to send to preexisting convo")
                }
            })
        }
    }
    
    private func createMessageID() -> String? {
        
        
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") else{
            return nil
        }
        
        let myEmail = ChatsViewController.safeEmail(with: currentUserEmail as! String)
        
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
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
