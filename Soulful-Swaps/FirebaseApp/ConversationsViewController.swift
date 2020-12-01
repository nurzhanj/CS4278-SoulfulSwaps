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
    
    
    
    private let tableView: UITableView! = {
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
        let inputEmail = safeEmail(with: email)
        DatabaseManager.shared.getAllConvos(for: inputEmail, completion: { [weak self] result in
            switch result{
            case .success(let fetchedConversations):
                guard !self!.conversations.isEmpty else{
                    return
                }
                self?.conversations = fetchedConversations
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("failed to get convos \(error)")
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(backToExplore))
        view.addSubview(tableView)
        view.addSubview(noConvos)
        setupTableView()
        fetchConversations()
        startListeningForConvos()
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
        let vc = ChatsViewController(with: email)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
        let model = conversations[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = conversations[indexPath.row]
        let vc = ChatsViewController(with: model.otherUserEmail)
        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
