//
//  Event+CoreDataClass.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/22/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


public class Event: NSManagedObject {
    static let className = "Event"
    
    func generateDictionary() -> [String: AnyObject]{
        let dictionary : Dictionary<String,AnyObject> = [
            "active" : true as AnyObject,
            "arrivingOrder" : arrivingOrder as AnyObject,
            "listOrder" : listOrder as AnyObject,
            "losingStreak" : losingStreak as AnyObject,
            "winingStreak" : winingStreak as AnyObject,
            "status" : status as AnyObject,
            "published" : true as AnyObject,
            "summaryText": summaryText as AnyObject, 
            "player" : player?.name as AnyObject
        ]
        return dictionary
    }

}
