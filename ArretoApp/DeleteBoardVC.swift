//
//  DeleteBoardVC.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 12/28/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class DeleteBoardVC: UIViewController {
    
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var totalRecordsCount: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    private let gameImpl = GameImpl()
    private var currentBoard : Board?
    var delegate : MainVCHandler?
    private let viewHelper = ViewHelper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApp()
        configureView()
    }
    
    func configureView(){
        viewHelper.addShadow(toView: cardView)
        if let count = currentBoard?.events?.count, let date = currentBoard?.createdOn{
            totalRecordsCount.text = "\(count) registros encontrados"
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .medium
            dateFormatter.locale = Locale(identifier: "es-DO")
            creationDate.text = "Esta pizarra fue creada \(dateFormatter.string(from: date  as Date))"
        }
    }
    
    func configureApp(){
        currentBoard = gameImpl.getBoard()
    }
    
    @IBAction func deleteBoardDidTouch(_ sender: UIButton) {
        
        let deleteBoardAC = UIAlertController(title: "Borrar Pizarra", message: "Desea borrar la pizarra? Todas las entradas seran eliminadas", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Si, estoy seguro!", style: .destructive, handler: { _ in
            self.gameImpl.clearBoard(board: self.currentBoard!)
            self.configureApp()
            self.delegate?.removeAllRecordsHandler()
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?.first
            
        })
        deleteBoardAC.addAction(cancelAction)
        deleteBoardAC.addAction(deleteAction)
        present(deleteBoardAC, animated: true, completion: nil)
    }
    
    
}
