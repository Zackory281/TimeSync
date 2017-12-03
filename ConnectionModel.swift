//
//  ConnectionModel.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/17/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore

class Connection {
    
    var user:Any?
    
    init() {
        Auth.auth().signInAnonymously(completion: {(user, error) in
            if let err = error {
                return
            }
            self.user = user
        })
    }
    
    func connect() -> Void {
        let ref = Database.database().reference()
        ref.child("pussy/da").setValue(user)
    }
}
