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
        
        var backgroundColor = UIColor.black
        if let playerInfoDTO = playerInfoDTO{
            
            playingIV.image = UIImage(named: "played_won")
            playingStatusLBL.text = "GANÓ"
            playingStatusLBL.textColor = ColorUtil.WON_COLOR
            backgroundColor = UIColor(red: 150/255.0, green: 154/255.0, blue: 168/255.0, alpha: 1.0)
            
            playingSummaryLBL.text = "Lleva \(playerInfoDTO.winingStreak) \(playerInfoDTO.winingStreak == 1 ? "ganado" : "ganados") y \(playerInfoDTO.losingStreak) \(playerInfoDTO.losingStreak == 1 ? "perdido" : "perdidos")"
            playingPlayerNameLBL.text = playerInfoDTO.playerName.uppercased()
            self.backgroundColor = UIColor.white
            viewHelper.addShadow(toView: cardView, withBackGroundColor: backgroundColor)
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
