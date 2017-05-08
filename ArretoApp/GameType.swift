//
//  GameType.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/22/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

protocol GameType {
    
    func getBoard() -> Board
    
    func addPlayer(name: String)throws -> Player
    func findPlayers(byName playerName: String) -> [Player]?
    func getAllPlayer() -> [Player]?
    func getAllPlayerWithNoEvents(board : Board) -> [Player]?
    
    func processWiningStreak(currentBoard : Board)
    func processEventsToChangeTypeAndActiveStatus(currentBoard : Board)
    func increase(player: Player, winingStreak : Bool, losingStreak: Bool)
    func getAllActiveEventsCountFromBoard(board : Board) -> Int
    func getAllEventsFromBoard(board : Board, byStatus: EventTypeEnum?) -> [Event]
    func changeEventType(currentBoard : Board, currentEvent: Event, status : EventTypeEnum)
    func switchEventActiveStatus(currentBoard : Board, currentEvent : Event)
    func createEvent(eventType: EventTypeEnum, currentBoard: Board, player: Player?) throws
    func getNextArrivingOrder(currentBoard : Board) -> Int
    func createSeparator(currentBoard: Board) throws
    func shareBoard(currentBoard: Board, completion : @escaping (String) -> Void)
    func clearBoard(board : Board)

    
    

}
