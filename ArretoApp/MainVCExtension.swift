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
            createLostEvent(currentIndex:  currentIndex)
        }
    }
    
    func undoEventSTatus(currentCell: UITableViewCell){
        //redo from history
    }
    
    private func createLostEvent(currentIndex : IndexPath){
        let currentEvent = eventList[currentIndex.row]
        if let currentPlayer = currentEvent.player{
            gameImpl.inactiveEvent(currentBoard: currentBoard!, currentEvent: currentEvent)
            //calculate win/lost streak
            //Create history record
            try! gameImpl.createEvent(status: .separator, board: currentBoard!, player: currentPlayer,winLostStreaks: nil, summaryText: nil)
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
            case .lost:
                return 75
            case .arrived:
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
                playerInfoDTO = PlayerInfoDTO(playerName: playerName, arrivingOrder: Int(currentEvent.arrivingOrder), listOrder: Int(currentEvent.listOrder), eventStatus: eventTypeEnum, winingStreak: Int(currentEvent.winingStreak), losingStreak: Int(currentEvent.losingStreak))
            }
            switch eventTypeEnum{
            case .separator:
                let cell = tableView.dequeueReusableCell(withIdentifier: "separatorCell", for: indexPath)
                return cell
            case .arrived:
                let cell = tableView.dequeueReusableCell(withIdentifier: "arrivingCell", for: indexPath) as! ArrivingTVC
                cell.playerInfoDTO = playerInfoDTO
                cell.delegate = self
                return cell
            case .lost:
                let cell = tableView.dequeueReusableCell(withIdentifier: "lostCell", for: indexPath) as! LostTVC
                cell.playerInfoDTO = playerInfoDTO
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
