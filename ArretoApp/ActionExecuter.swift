//
//  ActionExecuter.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/2/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import UIKit

protocol ActionExecuter {
    
    func changeEventStatus(currentCell: UITableViewCell)
    func undoEventSTatus(currentCell: UITableViewCell)
}
