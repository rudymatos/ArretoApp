//
//  FirebaseType.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/18/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

protocol FirebaseType{
    
    func generateDictionary(key: String) -> [String: AnyObject]
    
}
