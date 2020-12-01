//
//  ConversationTableViewCell.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 12/1/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    static let identifier = "ConversationTableViewCell"
    
    private let userNameLabel: UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
        
    }()
    
    private let userMessageLabel: UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        userNameLabel.frame = CGRect(x: 20, y: 10, width: Int(contentView.bounds.width) - 20 - 100, height: Int(contentView.bounds.height)-20/2)

        userMessageLabel.frame = CGRect(x: 20, y: 20, width: Int(contentView.bounds.width) - 20 - 100, height: Int(contentView.bounds.height)-20/2)
    }
    
    public func configure(with model: String){
        
    }

}
