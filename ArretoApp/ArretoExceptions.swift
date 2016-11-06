//
//  ArretoExceptions.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/23/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

enum ArretoExceptions : Error{
    
    case PlayerAlreadyExists
    case ArrivingEventAlreadyExists
    
    
    //MARK: - SmartPlay Exceptions
    case EventListIsEmpty
    case NoEnoughActiveEventsToProcess
    case PlayersHaveNoTeam
    
    case KeyAlreadyExists
    
}
