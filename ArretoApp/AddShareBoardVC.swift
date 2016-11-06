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
    
    var uniqueKeyToShare : String?{
        didSet{
            configureView()
        }
    }
    
    
    func configureView(){
        print("\(uniqueKeyToShare)")
        uniqueKeyToShareLBL?.text = uniqueKeyToShare
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
