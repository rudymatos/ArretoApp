//
//  PlayerBoardInfo+CoreDataProperties.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 5/7/17.
//  Copyright © 2017 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


extension PlayerBoardInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerBoardInfo> {
        return NSFetchRequest<PlayerBoardInfo>(entityName: "PlayerBoardInfo")
    }

    @NSManaged public var losingStreak: Int16
    @NSManaged public var winingStreak: Int16
    @NSManaged public var arrivingOrder: Int16
    @NSManaged public var board: Board?
    @NSManaged public var player: Player?

}
