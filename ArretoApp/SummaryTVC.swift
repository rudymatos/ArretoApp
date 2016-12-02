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
    
    var currentEvent : Event?{
        didSet{
            configureView()
        }
    }
    
    func configureView(){
        if let currentEvent = currentEvent{
               boardSummaryLBL.text = currentEvent.summaryText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
