//
//  MemberViewController.swift
//  aiFood
//
//  Created by Michael Sun on 7/12/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class MemberViewController: UIViewController {
    
    
    override func viewDidLoad() {
        
    
        super.viewDidLoad()
        
        guard let authUI = FUIAuth.defaultAuthUI() else { return }
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}

extension MemberViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        guard let user = authDataResult?.user else { return }
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        userRef.observeSingleEvent(of: .value, with:  { (snapshot) in
            
            if let user = User(snapshot: snapshot) {
                print("Welcome back, \(user.username)")
            } else {
                print("New user!")
            }
            
        })

    }
    
    
}
