//
//  EventTypeEnum.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/23/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

enum EventTypeEnum: String {
    
    case arrived = "Arrived"
    case left = "Left"
    case playing  = "Playing"
    case onHold = "On Hold"
    case waiting = "Waiting"
    case temporaryInjured = "Temporary Injured"
    case lost = "Lost"
    case won = "Won"
    case summary = "Summary"
    
    func getSpanish() -> String{
        switch  self {
        case .arrived:
            return "Llegó"
        case .left:
            return "Se Fue"
        case .playing:
            return "Jugando"
        case .onHold:
            return "En Espera (Gano)"
        case .waiting:
            return "En Espera"
        case .temporaryInjured:
            return "Lesionado"
        case .lost:
            return "Perdió"
        case .won:
            return "Ganó"
        case .summary:
            return "Resumen"
        }
    }
}
