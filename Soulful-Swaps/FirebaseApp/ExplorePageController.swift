//
//  ExplorePageController.swift
//  FirebaseApp
//
//  Created by Doug Dahl on 11/16/20.
//

import UIKit

@available(iOS 13.0, *)
class ExplorePageController: UIViewController {
    
    var sections: [AreaContainer]!
    var collectionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<AreaContainer, ListedItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(FeaturedCell.self, forCellWithReuseIdentifier: FeaturedCell.reuseIdentifier)
    }
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with item: ListedItem, for indexPath: IndexPath) -> T{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else{
            //we'd be asking to dequeue a type cell that doesn't exist here, and as we're
            //only working with one type of cell, this statement should never be reached
            fatalError("Unable to dequeue \(cellType)")
        }
        
        cell.configure(with: item)
        return cell;
    }
    
}
