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
    private let NUM_OF_MAX_ACTIVE_EVENTS = 10
    
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
    
    func switchEventActiveStatus(currentBoard : Board, currentEvent : Event){
        coreDataHelper.switchEventActiveStatus(currentEvent: currentEvent)
        if userDefaultsHelper.isBoardBeingShared(){
            //check this because the device id implementation should be different
            firebaseHelper.updateEventActiveStatus(currentBoard: currentBoard, event: currentEvent)
        }
    }
    
    func createSeparator(currentBoard: Board) throws{
        let allEventsCount = coreDataHelper.getAllEventsFromBoard(board: currentBoard).filter({$0.status != EventTypeEnum.separator.rawValue}).count
        if allEventsCount % 5 == 0 && allEventsCount >= 10{
            try createEvent(status: .separator, board: currentBoard, player: nil, winLostStreaks: nil, summaryText: nil)
        }
    }
    
    func processEventsToCalculate(currentBoard : Board){
        let allEvents = getAllEventsFromBoard(board: currentBoard, byStatus: nil)
        if allEvents.count >= NUM_OF_MAX_ACTIVE_EVENTS{
            let numberOfEventsToWork = (NUM_OF_MAX_ACTIVE_EVENTS - getAllActiveEventsCountFromBoard(board: currentBoard))
            var lastActiveIndex = userDefaultsHelper.currentActiveIndex()
            if numberOfEventsToWork > 0 {
                var eventChangedCounter = 0
                while(eventChangedCounter < numberOfEventsToWork){
                    let currentEvent = allEvents[lastActiveIndex]
                    if currentEvent.status != EventTypeEnum.separator.rawValue{
                        switchEventActiveStatus(currentBoard: currentBoard, currentEvent: currentEvent)
                        if currentEvent.status == EventTypeEnum.waiting.rawValue{
                            changeEventStatus(currentBoard: currentBoard, currentEvent: currentEvent, status: .onBoard)
                        }
                        eventChangedCounter += 1
                    }
                    lastActiveIndex += 1
                }
            }
            userDefaultsHelper.saveCurrentActiveIndex(activeIndex: lastActiveIndex)
        }
    }
    
    
    
    func createEvent(status: EventTypeEnum, board: Board, player: Player?, winLostStreaks : (winStreak: Int, lostStreak: Int)?, summaryText : String?) throws {
        if let player = player , status == EventTypeEnum.onBoard && coreDataHelper.doesArrivingEventWasAlreadyCreated(player: player, activeBoard: board){
            throw ArretoExceptions.ArrivingEventAlreadyExists
        }else{
            let nextNumber = coreDataHelper.getNextEventNumber(activeBoard: board)
            let event = coreDataHelper.createObjectContext(entityName: Event.className) as! Event
            event.listOrder = Int16(nextNumber)
            
            if status == EventTypeEnum.onBoard{
                let nextArrivingOrder = coreDataHelper.getNextArrivingEventNumber(activeBoard: board)
                event.arrivingOrder = Int16(nextArrivingOrder)
            }
            
            event.status = status.rawValue
            event.board = board
            event.player = player
            
            event.active = false
            
            if let winLostStreaks = winLostStreaks{
                event.winingStreak = Int16(winLostStreaks.winStreak)
                event.losingStreak = Int16(winLostStreaks.lostStreak)
            }
            
            if userDefaultsHelper.isBoardBeingShared(){
                //check this because the device id implementation should be different
                event.firebaseId = firebaseHelper.createEventFor( currentBoard: board, event: event)
            }
            coreDataHelper.saveContext()
        }
    }
    
    func changeEventStatus(currentBoard : Board, currentEvent: Event, status : EventTypeEnum){
        coreDataHelper.changeEventStatus(currentEvent: currentEvent, newEventStatus: status)
        if userDefaultsHelper.isBoardBeingShared(){
            firebaseHelper.changeEventStatus( currentBoard: currentBoard, currentEvent: currentEvent, newEventStatus: status)
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
    
    func shareBoard(currentBoard: Board, completion : @escaping (String) -> Void){
        firebaseHelper.createBoard(board: currentBoard, completion: { (boardKey , boardFBId) in
            currentBoard.firebaseId = boardFBId
            currentBoard.published = true
            if let events = currentBoard.events{
                for event in events.allObjects as! [Event] {
                    event.firebaseId = self.firebaseHelper.createEventFor(currentBoard: currentBoard, event: event)
                }
            }
            self.coreDataHelper.saveContext()
            self.userDefaultsHelper.shareBoard(sharing: true)
            completion(boardKey)
        })
    }
}
