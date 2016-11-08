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
    private let keyGenHelper = KeyGeneratorHelper.sharedInstance
    
    internal let maxNumberOfActiveEvents = 10
    
    func generateUniqueKeyForBoard() -> String{
        return keyGenHelper.generateUniqueKey()
    }
    
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
    
    func getAllEventsFromBoard(board : Board) -> [Event]{
        return coreDataHelper.getAllEventsFromBoard(board:board)
    }
    
    
    func getAllActiveEventsCountFromBoard(board : Board) -> Int{
        return coreDataHelper.getAllActiveEventsCountFromBoard(board: board)
    }
    
    func inactiveEvent(currentEvent : Event){
        coreDataHelper.inactiveEvent(currentEvent: currentEvent)
    }
    
    func createEvent(status: EventTypeEnum, board: Board, player: Player?, winLostStreaks : (winStreak: Int, lostStreak: Int)?) throws {
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
            coreDataHelper.saveContext()
        }
    }
    
    func changeEventStatus(currentEvent: Event, status : EventTypeEnum){
        coreDataHelper.changeEventStatus(currentEvent: currentEvent, newEventStatus: status)
    }
    
    func findWinLostStreak(currentEvent: Event) -> (winStreak: Int, lostStreak: Int){
        return coreDataHelper.findWiningLoseStreakForPlayer(event: currentEvent)
    }
    
    func clearBoard(board: Board) {
        coreDataHelper.changeBoardStatusToClose(board: board)
    }
    
    func findPlayers(byName playerName: String) -> [Player]? {
        return coreDataHelper.findPlayersByNameLike(name: playerName)
    }
    
}
