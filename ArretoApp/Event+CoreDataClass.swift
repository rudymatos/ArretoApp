//
//  Event+CoreDataClass.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 5/7/17.
//  Copyright © 2017 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


public class Event: NSManagedObject {

    
    static let className = "Event"
    
    func generateDictionary() -> [String: Any]{
        let dictionary : Dictionary<String,Any> = [
            "active" : true,
            "listOrder" : listOrder,
            "status" : type ?? "",
            "published" : true,
            "player" : player?.name ?? ""
        ]
        return dictionary
    }

    
}
