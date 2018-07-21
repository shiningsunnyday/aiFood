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
            
            
            var str: String = "http://localhost:5000/macros/\(requirements)"
            
            Alamofire.request(str).responseJSON { response in
                
                print(response)
                
                if let data = response.data {
                    
                    let ingredientList: IngredientList? = try? JSONDecoder().decode(IngredientList.self, from: data)
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

