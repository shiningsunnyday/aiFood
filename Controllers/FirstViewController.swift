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
    

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var about: UIButton!
    
    var ingredientList: IngredientList? = IngredientList(listToDisplay: [], requirements: [])
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FirstViewController.dismissKeyboard)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    var isSeguingToMemberZone = false
    var offset: CGFloat = 66
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        let bottomOfScreen: CGFloat = scrollView.contentSize.height - view.frame.height + offset
        offset = 0
        scrollView.setContentOffset(CGPoint(x: 0, y: bottomOfScreen), animated: false)
        isSeguingToMemberZone = false
        
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
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case "info":
            
            let destination = segue.destination as! UseAppViewController
            destination.viewDidLoad()
            
        case "generate":
            
            let destination = segue.destination as! ThirdViewController
            
            let requirements: String = "\(caloriesField.text!)_\(proteinField.text!)_\(fatField.text!)_\(carbsField.text!)"
            
            
            var str: String = "https://foodapp-api-heroku.herokuapp.com/macros/\(requirements)"
            
            
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
                        
                
                    
                    if let cals = Double(self.caloriesField.text!),
                        let pro = Double(self.proteinField.text!),
                        let fat = Double(self.fatField.text!),
                        let carbs = Double(self.carbsField.text!) {
                        
                        
                        destination.criteria = [cals, pro, fat, carbs]
                        
                    }
                    
                    if let x = self.ingredientList {

                    destination.ingredientList = x
                    destination.tableView.reloadData()
                    
                    }
            }
            }
            
        case "member":
            
            print("yay")
            
        default:
            
            print("hi")

        }
    }
    



}



extension FirstViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension FirstViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= -65, !isSeguingToMemberZone {
            
            isSeguingToMemberZone = true
            self.performSegue(withIdentifier: "member", sender: nil)
            
        }
        
    }
    
}

