//
//  CustomCollectionViewDropDelegate.swift
//  aiFood
//
//  Created by Michael Sun on 8/31/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit

protocol customCollectionViewDragDelegate: UICollectionViewDropDelegate {
    
    func collectionView(_:performDropWith:)
    
}
