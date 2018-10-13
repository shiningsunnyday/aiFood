//
//  CollectionView.swift
//  aiFood
//
//  Created by Michael Sun on 8/5/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit

class SelfSizedCollectionView: UICollectionView {
    

    
    
    
    var maxHeight: CGFloat = 200
    var items: ClusterResult?
    /*var dragDelegate: UICollectionViewDragDelegate
    var dropDelegate: UICollectionViewDropDelegate*/

    
    override func reloadData() {
        
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
        self.dragInteractionEnabled = true
        
    }
    
    override var intrinsicContentSize: CGSize {
        
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
        
    }
    
}


