//
//  FirebaseHelper.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/1/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHelper {
    
    static let sharedInstance = FirebaseHelper()
    private let keyGenHelper = KeyGeneratorHelper.sharedInstance
    private let databaseRef : FIRDatabaseReference?
    
    private init(){
        databaseRef = FIRDatabase.database().reference()
    }
    
    func createDeviceId() -> String{
        let deviceRef = databaseRef!.child("devices").childByAutoId()
        return deviceRef.key
    }
    
    func createBoard(deviceId : String, board: Board) -> (boardKey: String, boardFBId: String){
        let boardKey = self.keyGenHelper.generateUniqueKey()
        let boardIdRef = self.databaseRef!.child("devices").child(deviceId).child("boards").childByAutoId()
        boardIdRef.setValue(board.generateDictionary(key: boardKey))        
        return(boardKey, boardIdRef.key)
    }
    
    func inactiveEvent(deviceId: String, currentBoard: Board, event: Event){
        let currentBoardRef = getBoardRef(deviceId: deviceId, currentBoard: currentBoard)!
        currentBoardRef.child("events").child(event.firebaseId!).child("active").setValue(false)
    }
    
    func changeEventStatus(deviceId: String, currentBoard: Board, currentEvent: Event, newEventStatus : EventTypeEnum){
        let currentBoardRef = getBoardRef(deviceId: deviceId, currentBoard: currentBoard)!
        if newEventStatus == .won{
            currentBoardRef.child("events").child(currentEvent.firebaseId!).child("winingStreak").setValue(currentEvent.winingStreak)
        }else if newEventStatus == .lost{
            currentBoardRef.child("events").child(currentEvent.firebaseId!).child("losingStreak").setValue(currentEvent.losingStreak)
        }
        currentBoardRef.child("events").child(currentEvent.firebaseId!).child("status").setValue(newEventStatus.rawValue)
    }

    
    func createEventFor(deviceId: String, currentBoard : Board, event: Event) -> String{
        let currentBoardRef = getBoardRef(deviceId: deviceId, currentBoard: currentBoard)!
        let eventRefId = currentBoardRef.child("events").childByAutoId()
        eventRefId.setValue(event.generateDictionary())
        return eventRefId.key
    }
    
    private func getBoardRef(deviceId: String, currentBoard: Board) -> FIRDatabaseReference?{
        return databaseRef?.child("devices").child(deviceId).child("boards").child(currentBoard.firebaseId!)
    }
    
}
