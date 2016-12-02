//
//  Board+CoreDataClass.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/22/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


public class Board: NSManagedObject,FirebaseType {
    static let className = "Board"
    
    func generateDictionary(key: String) -> [String: AnyObject] {
        let dictionary : Dictionary<String, AnyObject> = [
        "active":  true as AnyObject,
        "createdOn": createdOn!.timeIntervalSince1970 as AnyObject,
        "key":key as AnyObject,
        "publised": published as AnyObject
        ]
        return dictionary
    }
    
}
