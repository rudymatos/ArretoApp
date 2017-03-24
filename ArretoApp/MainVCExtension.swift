//
//  MainVCActionExecuterExtension.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 1/2/17.
//  Copyright © 2017 Bearded Gentleman. All rights reserved.
//

import Foundation
import UIKit

extension MainVC : ActionExecuter{
    
    //MARK: - ACTIONEXECUTER
    func changeStatusToPlaying(currentCell: UITableViewCell) {
        createEvent(currentCell: currentCell, newEventType: .playing)
    }
    
    func handleActionSheet(currentCell: UITableViewCell) {
        if let currentIndex = eventsTV.indexPath(for: currentCell){
            let currentEvent = eventList[currentIndex.row]
            if let playerName = currentEvent.player?.name{
                let actionSheet = UIAlertController(title: playerName, message: "Seleccione la accion a realizar", preferredStyle: .actionSheet)
                
                if currentEvent.status != EventTypeEnum.playing.rawValue{
                    let left = UIAlertAction(title: EventTypeEnum.left.getSpanish(), style: .destructive, handler: { (action) in
                        self.createEvent(currentCell: currentCell, newEventType: .left)
                    })
                    actionSheet.addAction(left)
                }
                
                if currentEvent.status != EventTypeEnum.arrived.rawValue{
                    
                    let temporalInjured = UIAlertAction(title: EventTypeEnum.temporaryInjured.getSpanish(), style: .default, handler: { (action) in
                        self.createEvent(currentCell: currentCell, newEventType: .temporaryInjured)
                    })
                    actionSheet.addAction(temporalInjured)
                    
                    if currentEvent.status != EventTypeEnum.waiting.rawValue && currentEvent.status != EventTypeEnum.playing.rawValue{
                        let waiting = UIAlertAction(title: EventTypeEnum.waiting.getSpanish(), style: .default, handler: { (action) in
                            self.createEvent(currentCell: currentCell, newEventType: .waiting)
                        })
                        actionSheet.addAction(waiting)
                    }
                    
                    if currentEvent.status != EventTypeEnum.onHold.rawValue && currentEvent.status != EventTypeEnum.playing.rawValue{
                        let onHold = UIAlertAction(title: EventTypeEnum.onHold.getSpanish(), style: .default, handler: { (action) in
                            self.createEvent(currentCell: currentCell, newEventType: .onHold)
                        })
                        actionSheet.addAction(onHold)
                    }
                }
                
                let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                actionSheet.addAction(cancel)
                
                present(actionSheet, animated: true, completion: nil)
            }
        }
    }
    
    private func createEvent(currentCell: UITableViewCell, newEventType : EventTypeEnum){
        if let indexPath = eventsTV.indexPath(for: currentCell){
            let currentEvent = eventList[indexPath.row]
            if let currentPlayer = currentEvent.player{
                eventsTV.reloadRows(at: [indexPath], with: .fade)
                switch newEventType {
                case .playing:
                    if currentEvent.status == EventTypeEnum.waiting.rawValue || currentEvent.status == EventTypeEnum.temporaryInjured.rawValue || currentEvent.status == EventTypeEnum.onHold.rawValue{
                        gameImpl.changeEventStatus(currentBoard : currentBoard!, currentEvent: currentEvent, status: newEventType)
                        reloadSameData(currentIndex: indexPath)
                    }else{
                        gameImpl.inactiveEvent(currentBoard: currentBoard!, currentEvent: currentEvent)
                        reloadSameData(currentIndex: indexPath)
                        try! gameImpl.createEvent(status: newEventType, board: currentBoard!, player: currentPlayer,winLostStreaks: (0,0), summaryText: nil)
                        filterEvents(toMode: viewMode)
                    }
                case .won, .lost:
                    gameImpl.inactiveEvent(currentBoard: currentBoard!, currentEvent: currentEvent)
                    gameImpl.changeEventStatus(currentBoard : currentBoard!, currentEvent: currentEvent, status: newEventType)
                    reloadSameData(currentIndex: indexPath)
                    let winLostStreak = gameImpl.findWinLostStreak(currentEvent: currentEvent)
                    try! gameImpl.createEvent(status: .waiting, board: currentBoard!, player: currentPlayer,winLostStreaks: winLostStreak, summaryText: nil)
                    filterEvents(toMode: viewMode)
                case .left:
                    
                    gameImpl.inactiveEvent(currentBoard: currentBoard!, currentEvent: currentEvent)
                    let winLostStreak = gameImpl.findWinLostStreak(currentEvent: currentEvent)
                    currentEvent.winingStreak = Int16(winLostStreak.winStreak)
                    currentEvent.losingStreak = Int16(winLostStreak.lostStreak)
                    gameImpl.changeEventStatus(currentBoard : currentBoard!, currentEvent: currentEvent, status: newEventType)
                    reloadSameData(currentIndex: indexPath)
                    
                    if gameImpl.getAllActiveEventsCountFromBoard(board: currentBoard!) == 0{
                        try! gameImpl.createEvent(status: .summary, board: currentBoard!, player: nil,winLostStreaks: nil, summaryText: generateSummaryText())
                        handleAddPlayerBarButton(shouldShow: false)
                        filterEvents(toMode: viewMode)
                    }
                case .temporaryInjured, .waiting, .onHold:
                    gameImpl.changeEventStatus(currentBoard : currentBoard!, currentEvent: currentEvent, status: newEventType)
                    reloadSameData(currentIndex: indexPath)
                default:
                    print("nothing yet")
                }
            }
        }
    }
    
    private func generateSummaryText() -> String{
        var summaryText = ""
        for currentEvent in eventList{
            if currentEvent.status == EventTypeEnum.left.rawValue{
                if let playerName = currentEvent.player?.name{
                    let totalGamesPlayed = currentEvent.winingStreak + currentEvent.losingStreak
                    summaryText += "\(playerName.uppercased()) - T: \(totalGamesPlayed) - G: \(currentEvent.winingStreak) - P: \(currentEvent.losingStreak)\n"
                }
            }
        }
        return summaryText
    }
    
    func changeStatusFromPlayingToWinOrLost(currentCell: UITableViewCell, win: Bool) {
        if win {
            createEvent(currentCell: currentCell, newEventType: .won)
        }else{
            createEvent(currentCell: currentCell, newEventType: .lost)
        }
    }
    
    
}


extension MainVC: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentEvent = eventList[indexPath.row]
        if let eventStatus = currentEvent.status, let eventTypeEnum = EventTypeEnum(rawValue: eventStatus){
            switch  eventTypeEnum {
            case .won, .lost, .playing, .left:
                return 75
            case .arrived, .waiting, .onHold, .temporaryInjured:
                return 75
            case .summary:
                return CGFloat(75 + (eventList.filter({$0.status == EventTypeEnum.summary.rawValue}).count * 30))
            }
        }else{
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentEvent = eventList[indexPath.row]
        if let eventStatus = currentEvent.status, let eventTypeEnum = EventTypeEnum(rawValue: eventStatus){
            if eventTypeEnum == .summary{
                let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as! SummaryTVC
                cell.currentEvent = currentEvent
                return cell
            }else{
                if let playerName = currentEvent.player?.name{
                    let playerInfoDTO = PlayerInfoDTO(playerName: playerName, arrivingOrder: Int(currentEvent.arrivingOrder), listOrder: Int(currentEvent.listOrder), eventStatus: eventTypeEnum, winingStreak: Int(currentEvent.winingStreak), losingStreak: Int(currentEvent.losingStreak))
                    switch eventTypeEnum{
                    case .arrived, .waiting, .onHold, .temporaryInjured:
                        if currentEvent.active {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "aWOHTICell", for: indexPath) as! AWOHTITVC
                            cell.playerInfoDTO = playerInfoDTO
                            cell.delegate = self
                            return cell
                        }else{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "AWOHTIInactiveCell", for: indexPath) as! AWOHTIInactiveTVC
                            cell.playerInfoDTO = playerInfoDTO
                            return cell
                        }
                    case .playing, .won, .lost:
                        if currentEvent.active{ //JUST PLAYING EVENTS WOULD BE ACTIVE
                            let cell = tableView.dequeueReusableCell(withIdentifier: "playingCell", for: indexPath) as! PlayingTVC
                            cell.delegate = self
                            cell.playerInfoDTO = playerInfoDTO
                            return cell
                        }else{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "wonLostCell", for: indexPath) as! PlayingInactiveTVC
                            cell.playerInfoDTO = playerInfoDTO
                            return cell
                        }
                    case .left:
                        let cell = tableView.dequeueReusableCell(withIdentifier: "leftCell", for: indexPath) as! LeftTVC
                        cell.playerInfoDTO = playerInfoDTO
                        return cell
                    default:
                        return UITableViewCell()
                    }
                }else{
                    return UITableViewCell()
                }
                
            }
        }else{
            return UITableViewCell()
        }
    }
}


extension MainVC: MainVCHandler{

    func removeAllRecordsHandler() {
        shareBoardAI.startAnimating()
        configureApp()
        configureView()
        shareBoardAI.stopAnimating()
    }
    
}
