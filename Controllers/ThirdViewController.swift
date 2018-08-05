//
//  ThirdViewController.swift
//  aiFood
//
//  Created by Michael Sun on 7/5/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit
import Alamofire

class ThirdViewController: UITableViewController {
    
    var ingredientList: IngredientList?
    var listOfIngredientLists: ClusterResult?
    var criteria: [Double] = [0, 0, 0, 0]
    var k: Double = -10000
    var p: Double = -10000
    var f: Double = -10000
    var c: Double = -10000
    
    var total_cals: Double = 0
    var total_protein: Double = 0
    var total_fat: Double = 0
    
    var total_carbs: Double = 0
    
    @IBOutlet var calories: UITextField!
    @IBOutlet var protein: UITextField!
    @IBOutlet var fat: UITextField!
    @IBOutlet var carbs: UITextField!
    
    
    @IBAction func cluster(_ sender: Any) {
        
        var tempList: [String] = []
        
        if let ingList = ingredientList?.listToDisplay {
            
            for i in ingList {
                
                tempList.append(i.label.replacingOccurrences(of: " ", with: "_"))
                
            }
            
            let queryString: String = tempList.joined(separator: ",")
            
            let str: String = "https://foodapp-api-heroku.herokuapp.com/?ingredients=\(queryString)&num_meals=3"
            
            Alamofire.request(str).responseJSON { response in
                
                if let data = response.data {
                    
                    self.listOfIngredientLists = try? JSONDecoder().decode(ClusterResult.self, from: data)
                    

                }
                
            }
            
            
        }
        
    }
    
    
    @IBAction func generateList(_ sender: Any) {
        
        let requirements: String = "\(Int(criteria[0]))_\(Int(criteria[1]))_\(Int(criteria[2]))_\(Int(criteria[3]))"
        let str: String = "https://foodapp-api-heroku.herokuapp.com/macros/\(requirements)"
        Alamofire.request(str).responseJSON { response in
            
            if let data = response.data {
                
                let ingList: IngredientList? = try? JSONDecoder().decode(IngredientList.self, from: data)
                self.ingredientList = ingList
                
                self.total_cals = Double(ingList!.requirements[0])
                self.total_protein = Double(ingList!.requirements[1])
                self.total_fat = Double(ingList!.requirements[2])
                self.total_carbs = Double(ingList!.requirements[3])
                self.k = self.total_cals - self.criteria[0]
                self.p = self.total_protein - self.criteria[1]
                self.f = self.total_fat - self.criteria[2]
                self.c = self.total_carbs - self.criteria[3]
                self.calories.text = "\(Int(self.total_cals))"
                self.protein.text = "\(Int(self.total_protein))"
                self.fat.text = "\(Int(self.total_fat))"
                self.carbs.text = "\(Int(self.total_carbs))"
                
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    
    
    @IBAction func regenerate(_ sender: Any) {
        
        if let listToDisplay = ingredientList?.listToDisplay {
            
            k = total_cals - criteria[0]
            p = total_protein - criteria[1]
            f = total_fat - criteria[2]
            c = total_carbs - criteria[3]
            let requirements: String = "\(Int(k))_\(Int(p))_\(Int(f))_\(Int(c))"
            let str: String = "https://foodapp-api-heroku.herokuapp.com/diff/\(requirements)"

            Alamofire.request(str).responseJSON { response in

                print(response)

                if let data = response.data {

                    let ingredient: Ingredient? = try? JSONDecoder().decode(Ingredient.self, from: data)
                    self.ingredientList?.listToDisplay.append(ingredient!)
                    self.total_cals += ingredient!.calories
                    self.total_protein += ingredient!.protein
                    self.total_fat += ingredient!.fat
                    self.total_carbs += ingredient!.carbs
                    self.calories.text = "\(Int(self.total_cals))"
                    self.protein.text = "\(Int(self.total_protein))"
                    self.fat.text = "\(Int(self.total_fat))"
                    self.carbs.text = "\(Int(self.total_carbs))"
                    self.tableView.reloadData()
                    
                }

            }
            
            
            
        }
        
    }
    
    @IBAction func menu(_ sender: Any) {
        
        let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        
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
            let ingredient_to_remove = ingredientList!.listToDisplay[indexPath.row]
            ingredientList!.listToDisplay.remove(at: indexPath.row)
            total_cals -= ingredient_to_remove.calories
            total_protein -= ingredient_to_remove.protein
            total_fat -= ingredient_to_remove.fat
            total_carbs -= ingredient_to_remove.carbs
            calories.text = "\(Int(total_cals))"
            protein.text = "\(Int(total_protein))"
            fat.text = "\(Int(total_fat))"
            carbs.text = "\(Int(total_carbs))"
            tableView.reloadData()
        }
    }
    
    
    
    
}
