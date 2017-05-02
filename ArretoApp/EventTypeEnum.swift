//
//  EventTypeEnum.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/23/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

enum EventTypeEnum: String {
    
    case onBoard = "On Board"
    case lost = "Lost"
    case separator = "Separator"
    case waiting = "Waiting"
    
    func getSpanish() -> String{
        switch  self {
        case .onBoard:
            return "En Pizarra"
        case .lost:
            return "Perdió"
        case .separator:
            return "Separador"
        case .waiting:
            return "Esperando"
        }
    }
}

