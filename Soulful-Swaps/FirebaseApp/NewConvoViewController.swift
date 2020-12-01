//
//  NewConvoViewController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 12/1/20.
//

import UIKit

class NewConvoViewController: UIViewController {
    
    private let searchBar: UISearchBar =  {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Conversations"
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResults: UILabel = {
        let label = UILabel()
        label.text = "No users matching your search"
        label.textAlignment = .center
        label.textColor = .gray
        label.isHidden = true
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))

        // Do any additional setup after loading the view.
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    


}

extension NewConvoViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}
