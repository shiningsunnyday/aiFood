//
//  IngredientList.swift
//  aiFood
//
//  Created by Michael Sun on 7/6/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit
import Foundation

struct IngredientList: Codable {
    
    var listToDisplay: [Ingredient]
    var requirements: [Int]
    
    init(listToDisplay: [Ingredient], requirements: [Int]) {
        self.requirements = requirements
        self.listToDisplay = listToDisplay
    }
    
}
