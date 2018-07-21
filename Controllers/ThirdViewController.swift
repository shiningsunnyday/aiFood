//
//  ThirdViewController.swift
//  aiFood
//
//  Created by Michael Sun on 7/5/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit

class ThirdViewController: UITableViewController {
    
    var ingredientList: IngredientList?
    
    @IBAction func regenerate(_ sender: Any) {
        
        print("hi")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        if let listToDisplay = ingredientList?.listToDisplay {
            return listToDisplay.count
        } else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "thirdViewTableViewCell", for: indexPath) as! ThirdViewTableViewCell
        
        if let listToDisplay = ingredientList?.listToDisplay {
  
   
            let ingredient: Ingredient = listToDisplay[indexPath.row]

        cell.ingredientLabel.text = "\(ingredient.amount) of \(ingredient.label)"
        cell.subtitle.text = "Protein: \(ingredient.protein) Fat: \(ingredient.fat) Carbs: \(ingredient.carbs)"
            
        cell.accessoryType = .detailButton
            
     
        return cell
            
        }
        return UITableViewCell()
        
    }
    
  
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            ingredientList!.listToDisplay.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    
    
}
