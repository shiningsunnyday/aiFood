//
//  User.swift
//  aiFood
//
//  Created by Michael Sun on 7/12/18.
//  Copyright © 2018 Michael Sun. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User {
    
    let uid: String
    let username: String
    let matrix: [[Int]]
    
    init(uid: String, username: String, matrix: [[Int]]) {
        self.uid = uid
        self.username = username
        self.matrix = matrix
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let dict = snapshot.value as? [String: Any],
            let username = dict["username"] as? String,
            let matrix = dict["matrix"] as? [[Int]]
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        self.matrix = matrix
        
        
    }
    
}
