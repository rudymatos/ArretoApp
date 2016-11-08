//
//  SummaryTVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/7/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class SummaryTVC: UITableViewCell {
  
    @IBOutlet weak var boardSummaryLBL: UILabel!
    
    var eventList : [Event]?{
        didSet{
            configureView()
        }
    }
    
    func configureView(){
        var summaryText = ""
        if let eventList = eventList{
            for currentEvent in eventList{
                if currentEvent.status == EventTypeEnum.left.rawValue{
                    if let playerName = currentEvent.player?.name{
                        summaryText += "\(currentEvent.winingStreak)G/\(currentEvent.losingStreak)P : \(playerName.uppercased())\n"
                    }
                }
            }
        }
        boardSummaryLBL.text = summaryText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
