//
//  Ingredients.swift
//  aiFood
//
//  Created by Michael Sun on 7/6/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit
import Foundation

class Ingredient: Codable {
    
    var label: String
    var amount: String
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double

    init(label: String, amount: String, calories: Double, protein: Double, fat: Double, carbs: Double) {
        self.label = label
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.carbs = carbs
        self.amount = amount
    }
    
}
