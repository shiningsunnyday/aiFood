//
//  dropDelegate.swift
//  aiFood
//
//  Created by Michael Sun on 9/2/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import Foundation
import UIKit

protocol dropDelegate: UICollectionViewDropDelegate {
    
    func collectionView(_: UICollectionView, performDropWith: UICollectionViewDropCoordinator)
    
}
