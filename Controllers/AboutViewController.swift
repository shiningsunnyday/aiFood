//
//  aboutViewController.swift
//  aiFood
//
//  Created by Michael Sun on 8/9/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func email(_ sender: Any) {
        
        if let url = URL(string: "https://www.shiningsunnyday.com") {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    
    @IBAction func linkedIn(_ sender: Any) {
        
        if let url = URL(string: "https://www.linkedin.com/in/michael-sun-1610b2155/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func facebook(_ sender: Any) {
        
        if let url = URL(string: "https://www.facebook.com/profile.php?id=100012022903836") {
            UIApplication.shared.open(url, options: [:])
        
    }
    
    
}


}
