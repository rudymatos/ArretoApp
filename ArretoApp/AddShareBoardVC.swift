//
//  AddShareBoardVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 11/2/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class AddShareBoardVC: UIViewController {
    
    @IBOutlet weak var uniqueKeyToShareLBL: UILabel?
    @IBOutlet weak var shareView: UIView!
    
    var uniqueKeyToShare : String?{
        didSet{
            configureView()
        }
    }
    
    
    func configureView(){
        uniqueKeyToShareLBL?.text = uniqueKeyToShare
        
        if let shareView = shareView{
            shareView.layer.masksToBounds = true
            shareView.layer.cornerRadius = 4
            
            shareView.layer.masksToBounds = false
            shareView.layer.shadowOpacity = 1
            shareView.layer.shadowRadius = 10
            shareView.layer.shadowOffset = CGSize.zero
            shareView.layer.shadowColor = UIColor.black.cgColor
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
