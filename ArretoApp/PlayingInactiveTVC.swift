//
//  PlayingInactiveTVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/5/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class PlayingInactiveTVC: UITableViewCell {
    
    @IBOutlet weak var playingIV: UIImageView!
    @IBOutlet weak var playingPlayerNameLBL: UILabel!
    @IBOutlet weak var playingStatusLBL: UILabel!
    @IBOutlet weak var playingSummaryLBL: UILabel!
    
    var playerInfoDTO : PlayerInfoDTO?{
        didSet{
            configureView()
        }
    }
    
    
    func configureView(){
        if let playerInfoDTO = playerInfoDTO{
            switch playerInfoDTO.eventStatus {
            case .won:
                playingIV.image = UIImage(named: "played_won")
                playingStatusLBL.text = "GANÓ"
                playingStatusLBL.textColor = ColorUtil.WON_COLOR
            default:
                playingIV.image = UIImage(named: "played_lost")
                playingStatusLBL.text = "PERDIÓ"
                playingStatusLBL.textColor = ColorUtil.LOST_COLOR
            }
            playingSummaryLBL.text = "Lleva \(playerInfoDTO.winingStreak) ganados y \(playerInfoDTO.losingStreak) perdidos"
            playingPlayerNameLBL.text = playerInfoDTO.playerName.uppercased()
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
