//
//  ListedItemTableViewCell.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/25/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import UIKit

class ListedItemTableViewCell: UITableViewCell {

    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemSize: UILabel!
    @IBOutlet weak var itemWear: UILabel!
    @IBOutlet weak var itemPoints: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
