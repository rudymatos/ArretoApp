//
//  UserDefaultsHelper.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/19/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsHelper {
    
    private let keyString = "DEVICE_KEY"
    private let boardBeingShared = "BOARD_BEING_SHARED"
    private let lastActiveIndex = "LAST_ACTIVE_INDEX"
    private let arrivingListCount = "ARRIVING_LIST_COUNT"
    static let sharedInstance = UserDefaultsHelper()
    
    private init(){
        
    }
    //TODO: use generics to have just a single implementation
    
    func incrementArrivingListCount(){
        let currentCount = UserDefaults.standard.integer(forKey: arrivingListCount) + 1
        UserDefaults.standard.set(currentCount, forKey: arrivingListCount)
    }
    
    func cleanUpArrivingListCount(){
        UserDefaults.standard.set(0, forKey: arrivingListCount)
    }
    
    func getArrivingListCount() -> Int{
        return UserDefaults.standard.integer(forKey: arrivingListCount)
    }
    
    
    func saveCurrentActiveIndex(activeIndex : Int){
        UserDefaults.standard.set(activeIndex, forKey: lastActiveIndex)
    }
    
    func currentActiveIndex() -> Int{
        return UserDefaults.standard.integer(forKey: lastActiveIndex)
    }
    
    
    func shareBoard(sharing: Bool){
        UserDefaults.standard.set(sharing, forKey: boardBeingShared)
    }
    
    func isBoardBeingShared()-> Bool{
       return UserDefaults.standard.bool(forKey: boardBeingShared)
    }

    
}
