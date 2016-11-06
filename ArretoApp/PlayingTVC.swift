//
//  PlayingTVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/5/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class PlayingTVC: UITableViewCell {
    
    @IBOutlet weak var playerNameLBL: UILabel!
    @IBOutlet weak var playerWiningStreak: UILabel!
    
    var playerInfoDTO : PlayerInfoDTO?{
        didSet{
            configureView()
        }
    }
    
    var delegate : ActionExecuter?
    
    func configureView(){
        if let playerInfoDTO = playerInfoDTO{
            playerNameLBL.text = playerInfoDTO.playerName.uppercased()
            playerWiningStreak.text = "Ha ganado \(playerInfoDTO.winingStreak) juegos"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func playerWon(_ sender: UIButton) {
        self.changeStatusFromPlayingToWinOrLost( win: true)
    }
    @IBAction func playerLost(_ sender: UIButton) {
        self.changeStatusFromPlayingToWinOrLost( win: false)
    }
    
    func changeStatusFromPlayingToWinOrLost(win: Bool) {
        delegate?.changeStatusFromPlayingToWinOrLost(currentCell: self, win: win)
    }
    
}
