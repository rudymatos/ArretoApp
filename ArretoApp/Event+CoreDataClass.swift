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
    
    func generateDictionary() -> [String: Any]{
        let dictionary : Dictionary<String,Any> = [
            "active" : true,
            "arrivingOrder" : arrivingOrder,
            "listOrder" : listOrder,
            "losingStreak" : losingStreak,
            "winingStreak" : winingStreak,
            "status" : status ?? "",
            "published" : true,
            "summaryText": summaryText ?? "",
            "player" : player?.name ?? ""
        ]
        return dictionary
    }

}
