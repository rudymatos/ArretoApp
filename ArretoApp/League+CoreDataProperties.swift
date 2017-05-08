//
//  League+CoreDataProperties.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 5/7/17.
//  Copyright © 2017 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


extension League {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<League> {
        return NSFetchRequest<League>(entityName: "League")
    }

    @NSManaged public var name: String?
    @NSManaged public var boards: NSSet?

}

// MARK: Generated accessors for boards
extension League {

    @objc(addBoardsObject:)
    @NSManaged public func addToBoards(_ value: Board)

    @objc(removeBoardsObject:)
    @NSManaged public func removeFromBoards(_ value: Board)

    @objc(addBoards:)
    @NSManaged public func addToBoards(_ values: NSSet)

    @objc(removeBoards:)
    @NSManaged public func removeFromBoards(_ values: NSSet)

}
