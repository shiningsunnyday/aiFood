//
//  TableView.swift
//  aiFood
//
//  Created by Michael Sun on 7/29/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
    
    var maxHeight: CGFloat = 200
    
    
    override func reloadData() {
        
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
        
    }
    
    override var intrinsicContentSize: CGSize {
        
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
        
    }
}
