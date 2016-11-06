//
//  KeyGeneratorHelper.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/1/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

class KeyGeneratorHelper : KeyGenerator {
    
    static let sharedInstance = KeyGeneratorHelper()
    
    private init(){
    }
    
    private let firebaseHelper = FirebaseHelper.sharedInstance
    private let characters = ["A","B","C","D","E","F"]
    
    func generateUniqueKey() -> String{
        var key = ""
        repeat{
            let firstCharacter = arc4random_uniform(UInt32(characters.count))
            let secondCharacter = arc4random_uniform(UInt32(characters.count))
            var numbers = ""
            for _ in 0..<3{
                numbers += "\(arc4random_uniform(10))"
            }
            key = "\(characters[Int(firstCharacter)])\(characters[Int(secondCharacter)])\(numbers)"
        }while(checkIfKeyAlreadyExists(key: key))
        return key
    }
    
    private func checkIfKeyAlreadyExists(key: String) -> Bool{
        return firebaseHelper.checkBoardKeyAlreadyExists(key: key)
    }
    
}
