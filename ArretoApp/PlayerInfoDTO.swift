//
//  ArrivingOnHoldDTO.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/2/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

struct PlayerInfoDTO {
    let playerName : String
    let arrivingOrder : Int
    let listOrder : Int
    let eventStatus : EventTypeEnum
    let winingStreak : Int
    let losingStreak: Int
    let active : Bool
}
