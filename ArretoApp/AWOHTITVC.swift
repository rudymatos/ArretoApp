//
//  ArrivedOnHoldTVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/2/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class AWOHTITVC: UITableViewCell {
    
    @IBOutlet weak var playerNameLBL: UILabel!
    @IBOutlet weak var playerStatusIV: UIImageView!
    @IBOutlet weak var arrivingOrderLBL: UILabel!
    
    var delegate : ActionExecuter?
    var playerInfoDTO : PlayerInfoDTO?{
        didSet{
            configureView()
        }
    }
    
    func configureView(){
        if let playerInfoDTO = playerInfoDTO{
            playerNameLBL.text = playerInfoDTO.playerName.uppercased()
            let eventStatus = playerInfoDTO.eventStatus.rawValue
            if let eventType = EventTypeEnum(rawValue: eventStatus){
                switch eventType {
                case .arrived:
                    playerStatusIV.image = UIImage(named: "arrived_active")
                    arrivingOrderLBL.text = "Llegó de #\(playerInfoDTO.arrivingOrder) a la lista"
                case .temporaryInjured:
                    playerStatusIV.image = UIImage(named: "temporary_injured")
                    arrivingOrderLBL.text = "Habia ganado \(playerInfoDTO.winingStreak) \(playerInfoDTO.winingStreak == 1 ? "juego" : "juegos")"
                case .onHold:
                    playerStatusIV.image = UIImage(named: "on_hold")
                    arrivingOrderLBL.text = "Ganó 2: G\(playerInfoDTO.winingStreak)-P\(playerInfoDTO.losingStreak)-T\(playerInfoDTO.winingStreak + playerInfoDTO.losingStreak)"
                default:
                    playerStatusIV.image = UIImage(named: "waiting")
                    arrivingOrderLBL.text = "Ha ganado \(playerInfoDTO.winingStreak) \(playerInfoDTO.winingStreak == 1 ? "juego" : "juegos")"
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func showMoreActions(_ sender: UIButton) {
        delegate?.handleActionSheet(currentCell: self)
    }
    
    @IBAction func changeStatusToPlaying(_ sender: UIButton) {
        delegate?.changeStatusToPlaying(currentCell: self)
    }
    
}
