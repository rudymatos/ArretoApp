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
    @IBOutlet weak var cardView: UIView!
    private let viewHelper = ViewHelper.sharedInstance
    
    var playerInfoDTO : PlayerInfoDTO?{
        didSet{
            configureView()
        }
    }
    
    func configureView(){
        let bgColor = UIColor(red: 180/255.0, green: 203/255.0, blue: 182/255.0, alpha: 1.0)
        viewHelper.addShadow(toView: cardView, withBackGroundColor: bgColor)
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
