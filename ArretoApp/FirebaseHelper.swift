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
    
    func createBoard(board: Board, completion: @escaping ((String, String) -> Void)) {
        var validBoard = false
        var keepLooking = true
        
        DispatchQueue.global(qos: .default).async {
            while(!validBoard){
                if keepLooking {
                    keepLooking = false
                    let boardKey = self.keyGenHelper.generateUniqueKey()
                    self.databaseRef?.child(FirebaseKeysEnum.FBK_BOARD.rawValue)
                        .queryOrdered(byChild: FirebaseKeysEnum.FBK_KEY.rawValue)
                        .queryEqual(toValue: boardKey).observeSingleEvent(of: .value, with: { (snapshot) in
                            if !snapshot.exists() {
                                validBoard = true
                                let boardIdRef = self.databaseRef!.child(FirebaseKeysEnum.FBK_BOARD.rawValue).childByAutoId()
                                boardIdRef.setValue(board.generateDictionary(key: boardKey))
                                completion(boardKey, boardIdRef.key)
                            }else{
                                keepLooking = true
                            }
                        }, withCancel: {(error) in
                            print(error)
                        })
                }
            }
        }
        
    }
    
    func inactiveEvent(currentBoard: Board, event: Event){
        let currentBoardRef = getBoardRef(currentBoard: currentBoard)!
        currentBoardRef.child(FirebaseKeysEnum.FBK_EVENTS.rawValue).child(event.firebaseId!).child(FirebaseKeysEnum.FBK_ACTIVE.rawValue).setValue(false)
    }
    
    func changeEventStatus(currentBoard: Board, currentEvent: Event, newEventStatus : EventTypeEnum){
        let currentBoardRef = getBoardRef(currentBoard: currentBoard)!
        if newEventStatus == .won{
            currentBoardRef.child(FirebaseKeysEnum.FBK_EVENTS.rawValue).child(currentEvent.firebaseId!).child(FirebaseKeysEnum.FBK_WINING_STREAK.rawValue).setValue(currentEvent.winingStreak)
        }else if newEventStatus == .lost{
            currentBoardRef.child(FirebaseKeysEnum.FBK_EVENTS.rawValue).child(currentEvent.firebaseId!).child(FirebaseKeysEnum.FBK_LOSING_STREAK.rawValue).setValue(currentEvent.losingStreak)
        }
        currentBoardRef.child(FirebaseKeysEnum.FBK_EVENTS.rawValue).child(currentEvent.firebaseId!).child(FirebaseKeysEnum.FBK_STATUS.rawValue).setValue(newEventStatus.rawValue)
    }
    
    
    func createEventFor(currentBoard : Board, event: Event) -> String{
        let currentBoardRef = getBoardRef(currentBoard: currentBoard)!
        let eventRefId = currentBoardRef.child(FirebaseKeysEnum.FBK_EVENTS.rawValue).childByAutoId()
        eventRefId.setValue(event.generateDictionary())
        return eventRefId.key
    }
    
    private func getBoardRef(currentBoard: Board) -> FIRDatabaseReference?{
        return databaseRef?.child(FirebaseKeysEnum.FBK_BOARD.rawValue).child(currentBoard.firebaseId!)
    }
    
}
