//
//  ViewModeEnum.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/23/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import UIKit

enum ViewModeEnum: String {
    case all = "Todos"
    case activeOnly = "Activos"
    case inactiveOnly = "Inactivos"
    case arrived = "Lista"
    case left = "Se Fue"
    case playing = "Jugando"
    case onHold = "Gano 2"
    case waiting = "Esperando"
    case temporaryInjured = "Lesionado"
    case lost = "Perdio"
    case won = "Gano"
    case summary = "Resumen"
    case byPlayer = "Por Jugador"
    
    
    static let allValues = [all,activeOnly, inactiveOnly, arrived, left, playing, onHold, waiting, temporaryInjured, lost, won, summary, byPlayer]
    
    func getActionAlert(completion: ((UIAlertAction)->Void)?) -> UIAlertAction{
        return UIAlertAction(title: self.rawValue, style: .default, handler: completion)
    }
    
    func getImage() -> String{
        switch self {
        case .arrived:
            return "vm_arrived"
        case .left:
            return "vm_left"
        case .lost:
            return "vm_lost"
        case .onHold:
            return "vm_on_hold"
        case .playing:
            return "vm_playing"
        case .summary:
            return "vm_summary"
        case .temporaryInjured:
            return "vm_temporary_injured"
        case .waiting:
            return "vm_waiting"
        case .won:
            return "vm_won"
        case .byPlayer:
            return "vm_by_player"
        case .activeOnly:
            return "vm_active"
        case .inactiveOnly:
            return "vm_inactive"
        case .all:
            return "vm_all"
        }
    }
    
    func getEventType() -> EventTypeEnum?{
        switch self {
        case .arrived:
            return EventTypeEnum.arrived
        case .left:
            return EventTypeEnum.left
        case .lost:
            return EventTypeEnum.lost
        case .onHold:
            return EventTypeEnum.onHold
        case .playing:
            return EventTypeEnum.playing
        case .summary:
            return EventTypeEnum.summary
        case .temporaryInjured:
            return EventTypeEnum.temporaryInjured
        case .waiting:
            return EventTypeEnum.waiting
        case .won:
            return EventTypeEnum.won
        default:
            return nil
        }
    }
    
}

