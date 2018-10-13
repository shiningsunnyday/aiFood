//
//  SecondViewController.swift
//  aiFood
//
//  Created by Michael Sun on 7/3/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit
import Alamofire

class SecondViewController: UIViewController {
    
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var dietPlan: UISegmentedControl!
    @IBOutlet weak var activeness: UISegmentedControl!
    
    @IBOutlet weak var goal: UISegmentedControl!
    
    @IBOutlet weak var calories: UITextField!
    @IBOutlet weak var protein: UITextField!
    @IBOutlet weak var fat: UITextField!
    @IBOutlet weak var carbs: UITextField!
    
    @IBOutlet weak var calculateValue: UIButton!
    var ingredientList: IngredientList? = IngredientList(listToDisplay: [], requirements: [])
    @IBAction func calculate(_ sender: Any) {
        
        if let recordedAge = Double(age.text!), let recordedWeight = Double(weight.text!), let recordedHeight = Double(height.text!) {
            
            var REE: Double = 0
            switch gender.selectedSegmentIndex {
            case 0:
                REE = 10 * recordedWeight + 6.25 * recordedHeight - 5 * recordedAge + 5
            case 1:
                REE = 10 * recordedWeight + 6.25 * recordedHeight - 5 * recordedAge - 161
            default:
                break
            }
            
            switch activeness.selectedSegmentIndex {
            case 0:
                REE = 1.2 * REE
            case 1:
                REE = 1.375 * REE
            case 2:
                REE = 1.55 * REE
            case 3:
                REE = 1.725 * REE
            default:
                break
            }
            
            switch goal.selectedSegmentIndex {
            case 0:
                REE = 0.8 * REE
            case 1:
                REE = 0.9 * REE
            case 2:
                break
            case 3:
                REE = 1.1 * REE
            default:
                break
            }
            
            calories.text = "\(Int(REE))"
            
            switch dietPlan.selectedSegmentIndex {
            case 0:
                protein.text = "\(Int(0.15 * REE / 4))"
                fat.text = "\(Int(0.30 * REE / 9))"
                carbs.text = "\(Int(0.55 * REE / 4))"
            case 1:
                protein.text = "\(Int(0.20 * REE / 4))"
                fat.text = "\(Int(0.75 * REE / 9))"
                carbs.text = "\(Int(0.05 * REE / 4))"
            case 2:
                protein.text = "\(Int(0.30 * REE / 4))"
                fat.text = "\(Int(0.60 * REE / 9))"
                carbs.text = "\(Int(0.10 * REE / 4))"
            default:
                break
            }
            
            
            
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.calculateValue.titleLabel!.text = "Invalid inputs, try again!"
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FirstViewController.dismissKeyboard)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height + 64
        } else {
            view.frame.origin.y = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "generateAfterHelp":
            
            let destination = segue.destination as! ThirdViewController
            
            let requirements: String = "\(calories.text!)_\(protein.text!)_\(fat.text!)_\(carbs.text!)"
            
            destination.k = Double(calories.text!)!
            destination.p = Double(protein.text!)!
            destination.f = Double(fat.text!)!
            destination.c = Double(carbs.text!)!
            
            let str: String = "https://foodapp-api-heroku.herokuapp.com/macros/\(requirements)"
            
            
                
                Alamofire.request(str).responseJSON { response in
                    
                    print(response)
                    
                    if let data = response.data {
                        
                        self.ingredientList = try? JSONDecoder().decode(IngredientList.self, from: data)
                        
                        if let ingredientList = self.ingredientList {
                            
                            destination.calories.text = "\(ingredientList.requirements[0])"
                            destination.total_cals = Double(destination.calories.text!)!
                            destination.protein.text = "\(ingredientList.requirements[1])"
                            destination.total_protein = Double(destination.protein.text!)!
                            destination.fat.text = "\(ingredientList.requirements[2])"
                            destination.total_fat = Double(destination.fat.text!)!
                            destination.carbs.text = "\(ingredientList.requirements[3])"
                            destination.total_carbs = Double(destination.carbs.text!)!
                        }
                        
                        
                        
                        if let cals = Double(self.calories.text!),
                            let pro = Double(self.protein.text!),
                            let fat = Double(self.fat.text!),
                            let carbs = Double(self.carbs.text!) {
                            
                            
                            destination.criteria = [cals, pro, fat, carbs]
                            
                        }
                        destination.ingredientList = self.ingredientList!
                        destination.tableView.reloadData()
                        
                        
                        
                    }
                    
                }
                
            
            
        default:
            break
        }
        
    }
    
    


}

extension SecondViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

