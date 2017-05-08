//
//  Player+CoreDataClass.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 5/7/17.
//  Copyright © 2017 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


public class Player: NSManagedObject {

    
    static let className = "Player"
    static let minPlayerNameLength = 4
    
    func generateDictionary() -> [String:Any]{
        let dictionary : Dictionary<String,Any> = [
            "name": name ?? "NA"
        ]
        return dictionary
    }
    
    
}
