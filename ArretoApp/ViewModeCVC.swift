//
//  ViewModeCVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/23/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit


class ViewModeCVC: UICollectionViewCell {
    
    @IBOutlet weak var viewModeImage: UIImageView?
    @IBOutlet weak var viewModeLabel: UILabel?
    @IBOutlet weak var cardView: UIView!
    private let viewHelper = ViewHelper.sharedInstance
    
    var isCellSelected = false
    var currentViewMode : ViewModeEnum?{
        didSet{
            configureView()
        }
    }
    
    func changeSelectionColor(){
        isCellSelected = !isCellSelected
        cardView.backgroundColor = isCellSelected ?  ColorUtil.LOST_COLOR : UIColor.white
    }
    
    func configureView(){
        viewHelper.addShadow(toView: cardView, withBackGroundColor: UIColor.white)
        if let currentViewMode = currentViewMode{
            viewModeLabel?.text = currentViewMode.rawValue
            viewModeImage?.image = UIImage(named: currentViewMode.getImage())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
}
