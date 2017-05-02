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
    
    func changeEventStatus(currentCell: UITableViewCell) {
        if let currentIndex = eventsTV.indexPath(for: currentCell){
            let currentEvent = eventList[currentIndex.row]
            if currentEvent.active {
                createLostEvent(currentEvent: currentEvent)
            }
        }
    }
    
    func undoEventSTatus(currentCell: UITableViewCell){
        //redo from history
    }
    
    private func createLostEvent(currentEvent: Event){
        if let currentPlayer = currentEvent.player{
            
            //calculate win/lost streak
            //Create history record
            gameImpl.switchEventActiveStatus(currentBoard: currentBoard!, currentEvent: currentEvent)
            gameImpl.changeEventStatus(currentBoard: currentBoard!, currentEvent: currentEvent, status: .lost)
            
            
            //catch exceptions
            try! gameImpl.createEvent(status: .waiting, board: currentBoard!, player: currentPlayer,winLostStreaks: nil, summaryText: nil)
            try! gameImpl.createSeparator(currentBoard: currentBoard!)
            
            gameImpl.processEventsToCalculate(currentBoard: currentBoard!)
            filterEvents(toMode: viewMode)
            eventsTV.reloadData()
            //animate incoming cell with fade in effect
            //animate origin cell with fade in color effect
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
            case .separator:
                return 30
            default:
                return 65
            }
        }else{
            return 150
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentEvent = eventList[indexPath.row]
        var playerInfoDTO : PlayerInfoDTO? = nil
        if let eventStatus = currentEvent.status, let eventTypeEnum = EventTypeEnum(rawValue: eventStatus){
            if let playerName = currentEvent.player?.name{
                playerInfoDTO = PlayerInfoDTO(playerName: playerName, arrivingOrder: Int(currentEvent.arrivingOrder), listOrder: Int(currentEvent.listOrder), eventStatus: eventTypeEnum, winingStreak: Int(currentEvent.winingStreak), losingStreak: Int(currentEvent.losingStreak), active : currentEvent.active)
            }
            switch eventTypeEnum{
            case .separator:
                let cell = tableView.dequeueReusableCell(withIdentifier: "separatorCell", for: indexPath)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTVC
                cell.playerInfoDTO = playerInfoDTO
                cell.delegate = self
                return cell
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
