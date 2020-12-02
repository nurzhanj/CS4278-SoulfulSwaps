//
//  ConversationsViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/30/20.


import UIKit
import FirebaseAuth
import JGProgressHUD

struct Conversation{
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage{
    let date: String
    let text: String
    let isRead: Bool
}

class ConversationsViewController: UIViewController{
    
    public func safeEmail(with email: String) -> String{
        var safe = email.replacingOccurrences(of: "@", with: "-")
        safe = safe.replacingOccurrences(of: ".", with: "-")
        return safe
    }
    
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()
    
    private var conversations = [Conversation]()
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let noConvos: UILabel = {
        let label = UILabel()
        label.text = "No Convos"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private func startListeningForConvos(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
            return
        }
        print("starting convo fetch")
        let inputEmail = safeEmail(with: email)
        DatabaseManager.shared.getAllConvos(for: inputEmail, completion: { [weak self] result in
            switch result{
            case .success(let fetchedConversations):
                print("successfully got convo models")
                print(fetchedConversations[0].latestMessage)
                guard !fetchedConversations.isEmpty else{
                    self?.tableView.isHidden = true
                    self?.noConvos.isHidden = false
                    return
                }
                self?.conversations = fetchedConversations
                
                self?.noConvos.isHidden = true
                self?.tableView.isHidden = false
                self?.conversations = fetchedConversations
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.tableView.isHidden = true
                self?.noConvos.isHidden = false
                print("failed to get convos \(error)")
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(backToExplore))
        setupTableView()
        fetchConversations()
        startListeningForConvos()
        view.addSubview(tableView)
        view.addSubview(noConvos)
    }
    
    @objc private func backToExplore(){
        navigationController?.performSegue(withIdentifier: "messageToMarketplace", sender: self)
    }
    
    @objc private func didTapComposeButton(){
        let vc = NewConvoViewController()
        vc.completion = { [weak self] result in
            print("\(result)")
            self?.createNewConvo(result: result)

        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func createNewConvo(result: [String: String]){
        guard let username = result["username"], let email = result["email"] else{
            return
        }
        let vc = ChatsViewController(with: email, id: nil)
        vc.isNewConvo = true
        vc.title = username
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchConversations(){
        tableView.isHidden = false
    }
    
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        print(model.latestMessage.text)
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = conversations[indexPath.row]
        let vc = ChatsViewController(with: model.otherUserEmail, id: model.id)
        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
