//
//  FirstViewController.swift
//  aiFood
//
//  Created by Michael Sun on 7/3/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class FirstViewController: UIViewController {

    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var proteinField: UITextField!
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var carbsField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case "generate":
            
            let destination = segue.destination as! ThirdViewController
            
            let requirements: String = "\(caloriesField.text!)_\(proteinField.text!)_\(fatField.text!)_\(carbsField.text!)"
            
            
            var str: String = "https://foodapp-api-heroku.herokuapp.com/macros/\(requirements)"
            
            Alamofire.request(str).responseJSON { response in
                
                print(response)
                
                if let data = response.data {
                    
                    let ingredientList: IngredientList? = try? JSONDecoder().decode(IngredientList.self, from: data)
                    
                     destination.calories.text = "\(ingredientList!.requirements[0])"
                    destination.total_cals = Double(destination.calories.text!)!
                     destination.protein.text = "\(ingredientList!.requirements[1])"
                    destination.total_protein = Double(destination.protein.text!)!
                     destination.fat.text = "\(ingredientList!.requirements[2])"
                    destination.total_fat = Double(destination.fat.text!)!
                     destination.carbs.text = "\(ingredientList!.requirements[3])"
                    destination.total_carbs = Double(destination.carbs.text!)!
                    
                    if let cals = Double(self.caloriesField.text!),
                        let pro = Double(self.proteinField.text!),
                        let fat = Double(self.fatField.text!),
                        let carbs = Double(self.carbsField.text!) {
                        

                            destination.criteria = [cals, pro, fat, carbs]
                            
                    }
                    
                    destination.ingredientList = ingredientList!
                    destination.tableView.reloadData()
                    
                }
                
            }
            
            
        case "member":
            
            print("YES")
            
        default:
            print("segue identifier")
        }
    }


}

