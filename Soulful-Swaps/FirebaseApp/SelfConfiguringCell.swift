//
//  SelfConfiguringCell.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/16/20.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: ListedItem)
}
