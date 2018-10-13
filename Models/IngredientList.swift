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
    
    mutating func insert(ingredient: Ingredient, row: Int) {
        
        listToDisplay.insert(ingredient, at: row)
        requirements = [requirements[0] + Int(ingredient.calories), requirements[1] + Int(ingredient.protein), requirements[2] + Int(ingredient.fat), requirements[3] + Int(ingredient.carbs)]
        
    }
    
    mutating func remove(ingredient: Ingredient, row: Int) {
        
        listToDisplay.remove(at: row)
        requirements = [requirements[0] - Int(ingredient.calories), requirements[1] - Int(ingredient.protein), requirements[2] - Int(ingredient.fat), requirements[3] - Int(ingredient.carbs)]
        
    }
    
}
