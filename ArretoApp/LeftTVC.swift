//
//  LeftTVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/7/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class LeftTVC: UITableViewCell {
    
    @IBOutlet weak var playerNameLBL: UILabel!
    @IBOutlet weak var playerInfoLBL: UILabel!
    
    var playerInfoDTO: PlayerInfoDTO?{
        didSet{
            configureView()
        }
    }
    
    
    func configureView(){
        if let playerInfoDTO = playerInfoDTO{
            playerNameLBL.text = playerInfoDTO.playerName.uppercased()
            playerInfoLBL.text = "Ganó \(playerInfoDTO.winingStreak) \(playerInfoDTO.winingStreak == 1 ? "juego" : "juegos") y Perdió \(playerInfoDTO.losingStreak) \(playerInfoDTO.losingStreak == 1 ? "juego" : "juegos")"
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






