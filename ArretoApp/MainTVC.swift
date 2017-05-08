//
//  ArrivedOnHoldTVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/2/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class MainTVC: UITableViewCell {
    
    @IBOutlet weak var playerNameLBL: UILabel!
    @IBOutlet weak var playerStatusIV: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var playerOrderNumber: UILabel!
    private let viewHelper = ViewHelper.sharedInstance
    
    var delegate: ActionExecuter?
    
    var playerInfoDTO : PlayerInfoDTO?{
        didSet{
            configureView()
        }
    }
    
    func configureView(){
        if let playerInfoDTO = playerInfoDTO{
            playerNameLBL.text = playerInfoDTO.playerName.uppercased()
            let totalGamesPlayed = playerInfoDTO.winingStreak + playerInfoDTO.losingStreak
            playerOrderNumber.text = "G: \(playerInfoDTO.winingStreak) - P: \(playerInfoDTO.losingStreak) - T: \(totalGamesPlayed)"
            viewHelper.addShadow(toView: cardView, withBackGroundColor: playerInfoDTO.active ? ColorUtil.ACTIVE_COLOR.withAlphaComponent(0.3) : UIColor.gray.withAlphaComponent(0.3))
            switch playerInfoDTO.eventStatus {
            case .lost:
                playerStatusIV.image = UIImage(named: "played_lost")
                playerOrderNumber.text = "\(playerInfoDTO.losingStreak) \(playerInfoDTO.losingStreak > 1 ? "juegos perdidos":"juego perdido")"
                viewHelper.addShadow(toView: cardView, withBackGroundColor: ColorUtil.LOST_COLOR.withAlphaComponent(0.3))
            case .arrived:
                playerStatusIV.image = UIImage(named: "main_player_basketball")
            case .playing:
                playerStatusIV.image = UIImage(named: "playing")
                
            default://waiting
                playerStatusIV.image = UIImage(named: "waiting")
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    @IBAction func changeEventStatus(_ sender: UIButton) {
        delegate?.changeEventType(currentCell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
