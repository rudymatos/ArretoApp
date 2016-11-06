//
//  Event+CoreDataProperties.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/22/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData 

extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event");
    }

    @NSManaged public var status: String?
    @NSManaged public var listOrder: Int16
    @NSManaged public var arrivingOrder: Int16
    @NSManaged public var winingStreak: Int16
    @NSManaged public var losingStreak: Int16
    @NSManaged public var board: Board?
    @NSManaged public var active: Bool
    @NSManaged public var player: Player?

}
