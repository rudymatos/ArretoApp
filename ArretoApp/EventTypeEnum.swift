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
    case lost = "Lost"
    case separator = "Separator"
    
    func getSpanish() -> String{
        switch  self {
        case .arrived:
            return "Llegó"
        case .lost:
            return "Perdió"
        case .separator:
            return "Separador"
        }
    }
}

