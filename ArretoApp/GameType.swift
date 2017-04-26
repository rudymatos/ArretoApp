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
    func findWinLostStreak(currentEvent: Event) -> (winStreak: Int, lostStreak: Int)
    
    func getAllActiveEventsCountFromBoard(board : Board) -> Int
    func getAllEventsFromBoard(board : Board, byStatus: EventTypeEnum?) -> [Event]
    func changeEventStatus(currentBoard : Board, currentEvent: Event, status : EventTypeEnum)
    func inactiveEvent(currentBoard : Board, currentEvent : Event)
    func createEvent(status: EventTypeEnum, board: Board, player: Player?, winLostStreaks : (winStreak: Int, lostStreak: Int)?, summaryText : String?) throws
    func createSeparator(currentBoard: Board) throws
    func shareBoard(currentBoard: Board, completion : @escaping (String) -> Void)
    func clearBoard(board : Board)

    
    

}
