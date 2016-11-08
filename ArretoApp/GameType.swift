//
//  GameType.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/22/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation

protocol GameType {
    
    var maxNumberOfActiveEvents : Int {get}
    
    func getBoard() -> Board
    
    func addPlayer(name: String)throws -> Player
    func findPlayers(byName playerName: String) -> [Player]?
    func getAllPlayer() -> [Player]?
    func getAllPlayerWithNoEvents(board : Board) -> [Player]?
    func findWinLostStreak(currentEvent: Event) -> (winStreak: Int, lostStreak: Int)
    
    func getAllActiveEventsCountFromBoard(board : Board) -> Int
    func getAllEventsFromBoard(board : Board) -> [Event]
    func changeEventStatus(currentEvent: Event, status : EventTypeEnum)
    func createEvent(status: EventTypeEnum, board: Board, player: Player?, winLostStreaks : (winStreak: Int, lostStreak: Int)?) throws
    
    func clearBoard(board : Board)
    
    //MARK: - FIREBASE METHODS
    func generateUniqueKeyForBoard() -> String
    
    

}
