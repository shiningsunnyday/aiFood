//
//  ClusterResult.swift
//  aiFood
//
//  Created by Michael Sun on 8/4/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import Foundation
import UIKit

struct ClusterResult: Codable {
    
    var listOfIngredientLists: [IngredientList]
    
    init(list: [IngredientList]) {
        
        self.listOfIngredientLists = list
        
    }
    
}
