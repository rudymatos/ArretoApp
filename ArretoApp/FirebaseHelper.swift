//
//  FirebaseHelper.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/1/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHelper {
    
    static let sharedInstance = FirebaseHelper()
    private let databaseRef : FIRDatabaseReference?
    
    private init(){
        databaseRef = FIRDatabase.database().reference()
    }
    
    func checkBoardKeyAlreadyExists(key: String) -> Bool{
        
        var checkBoardKeyAlreadyExists = false
        let keyRef = databaseRef!.child("boards").child("board").child("key")
        keyRef.child(key).observeSingleEvent(of: .value, with: {(snap) in
            let _ = snap.description as String
            checkBoardKeyAlreadyExists = true
        }) {(error) in
            print("key was not found")
        }
        return checkBoardKeyAlreadyExists
    }
    
    
}
