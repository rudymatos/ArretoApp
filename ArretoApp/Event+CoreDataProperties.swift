//
//  Event+CoreDataProperties.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 5/7/17.
//  Copyright © 2017 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var active: Bool
    @NSManaged public var firebaseId: String?
    @NSManaged public var listOrder: Int16
    @NSManaged public var published: Bool
    @NSManaged public var type: String?
    @NSManaged public var board: Board?
    @NSManaged public var player: Player?

}
