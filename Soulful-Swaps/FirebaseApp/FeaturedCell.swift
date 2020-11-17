//
//  FeaturedCell.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/16/20.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import UIKit;

@available(iOS 13.0, *)
class FeaturedCell: UICollectionViewCell, SelfConfiguringCell {
    
    
    static let reuseIdentifier: String = "Featured Item"
    
    let name = UILabel()
    let brand = UILabel()
    let pointVal = UILabel()
    let image = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        name.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        name.textColor = .systemBlue
        
        brand.font = UIFont.preferredFont(forTextStyle: .title2)
        brand.textColor = .label
        
        pointVal.font = UIFont.preferredFont(forTextStyle: .title2)
        pointVal.textColor = .secondaryLabel
        
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [name, brand, pointVal, image])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
        
        stackView.setCustomSpacing(10, after: pointVal)
        
        
        
        
    }
    
    
    func configure(with item: ListedItem) {
        name.text = item.name.uppercased()
        brand.text = item.brand.uppercased()
        let points = String(item.pointVal)
        pointVal.text = points.uppercased()
        image.image = item.picture
    }
    
    required init?(coder: NSCoder) {
        fatalError("This code should not be able to be reached")
    }
    
    
}
