//
//  PlayerNameTCV.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/24/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class PlayerNameTCV: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    var playerName : String = "NA"{
        didSet{
            configureView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    
    func configureView(){
        playerNameLabel.text = playerName
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
