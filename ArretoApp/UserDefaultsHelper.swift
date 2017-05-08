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
    static let sharedInstance = UserDefaultsHelper()
    
    private init(){
        
    }
    
    enum UserDefaultsHelperKeys : String{
        case arrivingList = "ARRIVING_LIST_COUNT"
        case lostCounter = "LOST_COUNTER"
    }
    
    
    func increaseCounter(onKey : UserDefaultsHelperKeys){
        let currentCounter = UserDefaults.standard.integer(forKey: onKey.rawValue) + 1
        UserDefaults.standard.set((currentCounter), forKey: onKey.rawValue)
    }
    
    
    func cleanUp(onKey : UserDefaultsHelperKeys){
        UserDefaults.standard.set(onKey == .lostCounter ? 1 : 0, forKey: onKey.rawValue)
    }
    
    func getCount(onKey: UserDefaultsHelperKeys) -> Int{
        return UserDefaults.standard.integer(forKey: onKey.rawValue)
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
