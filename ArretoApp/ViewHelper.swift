//
//  TableVCExtension.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 12/31/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import Foundation
import UIKit

class ViewHelper{
    
    static let sharedInstance = ViewHelper()
    
    private init(){
        
    }
    
    func addShadow( toView: UIView, withBackGroundColor : UIColor = ColorUtil.BASE_COLOR){
        toView.layer.cornerRadius = 5
        toView.layer.backgroundColor = withBackGroundColor.cgColor
        toView.layer.masksToBounds = false
        toView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        toView.layer.shadowOffset = CGSize(width: 0, height: 3)
        toView.layer.shadowOpacity = 0.8
    }
    
    
    func applyRoundedCorner(toButtons: [UIButton]){
        for button in toButtons{
            button.layer.cornerRadius = button.frame.width / 2
        }
    }
    
}
