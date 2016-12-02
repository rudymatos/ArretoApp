//
//  GameImpl.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/22/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

class GameImpl: GameType{
    
    private let coreDataHelper = CoreDataHelper.sharedInstance
    private let firebaseHelper = FirebaseHelper.sharedInstance
    private let userDefaultsHelper = UserDefaultsHelper.sharedInstance
    
    internal let maxNumberOfActiveEvents = 10
    
    
    func getBoard() -> Board {
        return coreDataHelper.isThereAnActiveBoard() ? coreDataHelper.getActiveBoard() : coreDataHelper.createBoard()
    }
    
    func getAllPlayer() -> [Player]?{
        return coreDataHelper.getAllPlayers()
    }
    
    func getAllPlayerWithNoEvents(board : Board) -> [Player]?{
        return coreDataHelper.getAllPlayerWithNoEvents(board: board)
    }
    
    
    func addPlayer(name: String)throws -> Player{
        if coreDataHelper.doesPlayerExistsAlready(name: name){
            throw ArretoExceptions.PlayerAlreadyExists
        }else{
            return coreDataHelper.createPlayer(name: name)
        }
    }
    
    func getAllEventsFromBoard(board : Board, byStatus: EventTypeEnum?) -> [Event]{
        return coreDataHelper.getAllEventsFromBoard(board: board, byStatus: byStatus)
    }
    
    func getAllActiveEventsCountFromBoard(board : Board) -> Int{
        return coreDataHelper.getAllActiveEventsCountFromBoard(board: board)
    }
    
    func inactiveEvent(currentBoard : Board, currentEvent : Event){
        coreDataHelper.inactiveEvent(currentEvent: currentEvent)
        if userDefaultsHelper.isBoardBeingShared(){
            //check this because the device id implementation should be different
            firebaseHelper.inactiveEvent(deviceId: userDefaultsHelper.retriveDeviceKey(), currentBoard: currentBoard, event: currentEvent)
        }
    }
    
    func createEvent(status: EventTypeEnum, board: Board, player: Player?, winLostStreaks : (winStreak: Int, lostStreak: Int)?, summaryText : String?) throws {
        if let player = player , status == EventTypeEnum.arrived && coreDataHelper.doesArrivingEventWasAlreadyCreated(player: player, activeBoard: board){
            throw ArretoExceptions.ArrivingEventAlreadyExists
        }else{
            let nextNumber = coreDataHelper.getNextEventNumber(activeBoard: board)
            let event = coreDataHelper.createObjectContext(entityName: Event.className) as! Event
            event.listOrder = Int16(nextNumber)
            
            if status == EventTypeEnum.arrived{
                let nextArrivingOrder = coreDataHelper.getNextArrivingEventNumber(activeBoard: board)
                event.arrivingOrder = Int16(nextArrivingOrder)
            }
            
            event.status = status.rawValue
            event.board = board
            if let winLostStreaks = winLostStreaks{
                event.winingStreak = Int16(winLostStreaks.winStreak)
                event.losingStreak = Int16(winLostStreaks.lostStreak)
            }
            
            if status != EventTypeEnum.summary{
                event.player = player
            }
            
            if let summaryText = summaryText , status == EventTypeEnum.summary{
                event.summaryText = summaryText
            }
            
            if userDefaultsHelper.isBoardBeingShared(){
                //check this because the device id implementation should be different
                event.firebaseId = firebaseHelper.createEventFor(deviceId: userDefaultsHelper.retriveDeviceKey(), currentBoard: board, event: event)
            }
            
            coreDataHelper.saveContext()
            
        }
    }
    
    func changeEventStatus(currentBoard : Board, currentEvent: Event, status : EventTypeEnum){
        coreDataHelper.changeEventStatus(currentEvent: currentEvent, newEventStatus: status)
        if userDefaultsHelper.isBoardBeingShared(){
            firebaseHelper.changeEventStatus(deviceId: userDefaultsHelper.retriveDeviceKey(), currentBoard: currentBoard, currentEvent: currentEvent, newEventStatus: status)
        }
        
    }
    
    func findWinLostStreak(currentEvent: Event) -> (winStreak: Int, lostStreak: Int){
        return coreDataHelper.findWiningLoseStreakForPlayer(event: currentEvent)
    }
    
    func clearBoard(board: Board) {
        coreDataHelper.changeBoardStatusToClose(board: board)
        userDefaultsHelper.shareBoard(sharing: false)

    }
    
    func findPlayers(byName playerName: String) -> [Player]? {
        return coreDataHelper.findPlayersByNameLike(name: playerName)
    }
    
    
    func shareBoard(currentBoard: Board) -> String{
        let deviceId = userDefaultsHelper.isThereADeviceKey() ? userDefaultsHelper.retriveDeviceKey() : userDefaultsHelper.saveDeviceKey(deviceKey: firebaseHelper.createDeviceId())
        let keys = firebaseHelper.createBoard(deviceId: deviceId, board: currentBoard)
        currentBoard.firebaseId = keys.boardFBId
        currentBoard.published = true
        
        if let events = currentBoard.events{
            for event in events.allObjects as! [Event] {
               event.firebaseId = firebaseHelper.createEventFor(deviceId: deviceId, currentBoard: currentBoard, event: event)
            }
        }
        
        coreDataHelper.saveContext()
        userDefaultsHelper.shareBoard(sharing: true)
        return keys.boardKey
    }
    
}
