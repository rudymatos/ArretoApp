//
//  DeleteBoardVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 12/28/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class DeleteBoardVC: UIViewController {
    
    private let gameImpl = GameImpl()
    private var currentBoard : Board?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApp()

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func deleteBoardDidTouch(_ sender: UIButton) {
        
        
        //First create alert and notify the user
        let deleteBoardAC = UIAlertController(title: "Borrar Pizarra", message: "Desea borrar la pizarra? Todas las entradas seran eliminadas", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Si, estoy seguro!", style: .destructive, handler: { _ in
            self.gameImpl.clearBoard(board: self.currentBoard!)
            self.configureApp()
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?.first
            
        })
        deleteBoardAC.addAction(cancelAction)
        deleteBoardAC.addAction(deleteAction)
        present(deleteBoardAC, animated: true, completion: nil)
    }
    
    func configureApp(){
        //Check connectivity to show/hide shared button in navigation bar
        currentBoard = gameImpl.getBoard()
    }
    
    
    
    
}
