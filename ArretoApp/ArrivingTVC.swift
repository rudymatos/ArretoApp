//
//  ArrivedOnHoldTVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/2/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class ArrivingTVC: UITableViewCell {
    
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
        viewHelper.addShadow(toView: cardView, withBackGroundColor: UIColor.white.withAlphaComponent(0.5))
        if let playerInfoDTO = playerInfoDTO{
            playerNameLBL.text = playerInfoDTO.playerName.uppercased()
            playerOrderNumber.text = "Llegó de #\(playerInfoDTO.arrivingOrder) a la lista"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    @IBAction func changeEventStatus(_ sender: UIButton) {
        delegate?.changeEventStatus(currentCell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
