//
//  ArrivingOnHoldInactiveTVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/5/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class AWOHTIInactiveTVC: UITableViewCell {
    
    @IBOutlet weak var playerStatusLBL: UILabel!
    @IBOutlet weak var playerNameLBL: UILabel!
    
    var playerInfoDTO : PlayerInfoDTO?{
        didSet{
            configureView()
        }
    }
    
    func configureView(){
        if let playerInfoDTO = playerInfoDTO{
            playerStatusLBL.text = "Llegó de #\(playerInfoDTO.arrivingOrder) a la lista"
            playerNameLBL.text = playerInfoDTO.playerName.uppercased()
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
