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
    static let sharedInstance = UserDefaultsHelper()
    
    private init(){
        
    }
    
    func shareBoard(sharing: Bool){
        UserDefaults.standard.set(sharing, forKey: boardBeingShared)
    }
    
    func isBoardBeingShared()-> Bool{
       return UserDefaults.standard.bool(forKey: boardBeingShared)
    }

    
}
