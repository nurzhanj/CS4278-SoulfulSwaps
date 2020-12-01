import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind

}

struct Sender: SenderType{
    var senderId: String
    
    var displayName: String
    
}

class ChatsViewController: MessagesViewController {
    
    private var messages = [Message]()
    private let selfSender = Sender(senderId: "1", displayName: "John Doe")
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .red
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello, World!")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello, World, it's the d o double g!")))
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

    }
    

}

extension ChatsViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
