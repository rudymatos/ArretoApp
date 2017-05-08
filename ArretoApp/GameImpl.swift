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
    static let NUM_OF_MAX_ACTIVE_EVENTS = 10
    static let MAX_LOST_COUNTER  = GameImpl.NUM_OF_MAX_ACTIVE_EVENTS / 2
    
    
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
        return coreDataHelper.getAllEventsFromBoard(board: board, byType: byStatus)
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
        let allEventsCount = coreDataHelper.getAllEventsFromBoard(board: currentBoard).filter({$0.type != EventTypeEnum.separator.rawValue}).count
        if allEventsCount % 5 == 0 && allEventsCount >= 10{
            try createEvent(eventType: .separator, currentBoard: currentBoard, player: nil)
        }
    }
    
    func processWiningStreak(currentBoard : Board){
        //check if there is 20 or more
        let firstActiveEvents = getAllEventsFromBoard(board: currentBoard, byStatus: nil).filter({$0.active == true})
        for index in 0..<GameImpl.NUM_OF_MAX_ACTIVE_EVENTS / 2 {
            let currentEvent = firstActiveEvents[index]
            if let currentPlayer = currentEvent.player{
                increase(player: currentPlayer, winingStreak: true, losingStreak: false)
            }
        }
    }
    
    
    func processEventsToChangeTypeAndActiveStatus(currentBoard : Board){
        let allEvents = getAllEventsFromBoard(board: currentBoard, byStatus: nil)
        if allEvents.count >= GameImpl.NUM_OF_MAX_ACTIVE_EVENTS{
            let numberOfEventsToWork = (GameImpl.NUM_OF_MAX_ACTIVE_EVENTS - getAllActiveEventsCountFromBoard(board: currentBoard))
            var lastActiveIndex = userDefaultsHelper.currentActiveIndex()
            if numberOfEventsToWork > 0 {
                var eventChangedCounter = 0
                while(eventChangedCounter < numberOfEventsToWork){
                    let currentEvent = allEvents[lastActiveIndex]
                    if currentEvent.type != EventTypeEnum.separator.rawValue{
                        switchEventActiveStatus(currentBoard: currentBoard, currentEvent: currentEvent)
                        if currentEvent.type == EventTypeEnum.waiting.rawValue{
                            changeEventType(currentBoard: currentBoard, currentEvent: currentEvent, status: .playing)
                        }
                        eventChangedCounter += 1
                    }
                    lastActiveIndex += 1
                }
            }
            userDefaultsHelper.saveCurrentActiveIndex(activeIndex: lastActiveIndex)
        }
    }
    
    
    func getNextArrivingOrder(currentBoard : Board) -> Int{
        return  coreDataHelper.getNextArrivingEventNumber(activeBoard: currentBoard)
    }
    
    
    func createEvent(eventType: EventTypeEnum, currentBoard: Board, player: Player?) throws {
        if let player = player, eventType == EventTypeEnum.arrived && coreDataHelper.doesArrivingEventWasAlreadyCreated(player: player, activeBoard: currentBoard){
            throw ArretoExceptions.ArrivingEventAlreadyExists
        }else{
            
            let nextNumber = coreDataHelper.getNextEventNumber(activeBoard: currentBoard)
            let event = coreDataHelper.createObjectContext(entityName: Event.className) as! Event
            
            event.listOrder = Int16(nextNumber)
            event.type = eventType.rawValue
            event.board = currentBoard
            event.player = player
            event.active = false
            
            if eventType == .arrived{
                let nextArrivingOrder = getNextArrivingOrder(currentBoard: currentBoard)
                let playerBoardInfo = coreDataHelper.createObjectContext(entityName: PlayerBoardInfo.className) as! PlayerBoardInfo
                playerBoardInfo.winingStreak = 0
                playerBoardInfo.losingStreak = 0
                playerBoardInfo.arrivingOrder = Int16(nextArrivingOrder)
                playerBoardInfo.player = player
                player?.playerBoardInfo = playerBoardInfo
            }
            
            if userDefaultsHelper.isBoardBeingShared(){
                //check this because the device id implementation should be different
                event.firebaseId = firebaseHelper.createEventFor( currentBoard: currentBoard, event: event)
            }
            coreDataHelper.saveContext()
        }
    }
    
    
    func increase(player: Player, winingStreak : Bool, losingStreak: Bool){
        if winingStreak || losingStreak{
            if let playerBoardInfo = player.playerBoardInfo{
                if winingStreak  {
                    playerBoardInfo.winingStreak = playerBoardInfo.winingStreak + 1
                }
                if losingStreak {
                    playerBoardInfo.losingStreak = playerBoardInfo.losingStreak + 1
                }
                coreDataHelper.saveContext()
            }
        }
    }
    
    
    func changeEventType(currentBoard : Board, currentEvent: Event, status : EventTypeEnum){
        coreDataHelper.changeEventType(currentEvent: currentEvent, newEventType: status)
        if userDefaultsHelper.isBoardBeingShared(){
            firebaseHelper.changeEventStatus( currentBoard: currentBoard, currentEvent: currentEvent, newEventStatus: status)
        }
        
    }
    
    func clearBoard(board: Board) {
        
        //        coreDataHelper.getAllEventsFromBoard(board: board).
        
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
