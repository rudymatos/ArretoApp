//
//  Board+CoreDataClass.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 5/7/17.
//  Copyright © 2017 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


public class Board: NSManagedObject {

    static let className = "Board"
    
    func generateDictionary(key: String) -> [String: Any] {
        let dictionary : Dictionary<String, Any> = [
            "active":  true,
            "createdOn": createdOn!.timeIntervalSince1970,
            "key": key,
            "published": published
        ]
        return dictionary
    }

    
}
