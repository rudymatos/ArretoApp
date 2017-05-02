//
//  PlayingInactiveTVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/5/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class LostTVC: UITableViewCell {
    
    @IBOutlet weak var playingIV: UIImageView!
    @IBOutlet weak var playingPlayerNameLBL: UILabel!
    @IBOutlet weak var playingStatusLBL: UILabel!
    @IBOutlet weak var playingSummaryLBL: UILabel!
    @IBOutlet weak var cardView: UIView!
    private let viewHelper = ViewHelper.sharedInstance
    var playerInfoDTO : PlayerInfoDTO?{
        didSet{
            configureView()
        }
    }
    
    
    func configureView(){
        if let playerInfoDTO = playerInfoDTO{
            playingIV.image = UIImage(named: "played_lost")
            playingStatusLBL.text = playerInfoDTO.eventStatus.getSpanish().uppercased()
            playingStatusLBL.textColor = ColorUtil.LOST_COLOR
            playingPlayerNameLBL.text = playerInfoDTO.playerName.uppercased()
            viewHelper.addShadow(toView: cardView, withBackGroundColor: UIColor.gray.withAlphaComponent(0.3))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
