//
//  ViewController.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/22/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var eventsTV: UITableView!
    @IBOutlet weak var shareBoardAI: UIActivityIndicatorView!
    @IBOutlet var addPlayerView: UIView!
    @IBOutlet var helpView: UIView!
    
    var eventList = [Event]()
    var currentBoard : Board?
    let gameImpl = GameImpl()
    var viewMode = ViewModeEnum.all
    private var uniqueKeyToShare : String?
    private let userDefaultsHelper = UserDefaultsHelper.sharedInstance
    private let viewHelper = ViewHelper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApp(appLoading: true)
        configureView()
    }
    
    
    
    //MARK: - VIEW CONFIGURATION
    func configureView(){
        shareBoardAI.stopAnimating()
        eventsTV.rowHeight = UITableViewAutomaticDimension
        eventsTV.estimatedRowHeight = 150
        viewHelper.addShadow(toView: helpView, withBackGroundColor: UIColor.white)
        displayElementsBasedOnEventListCount()
    }
    
    func configureApp(appLoading : Bool = false){
        //Check connectivity to show/hide shared button in navigation bar
        currentBoard = gameImpl.getBoard()
        filterEvents(toMode: viewMode)
        
        if let deleteTabVC = self.tabBarController?.viewControllers?[1] as? DeleteBoardVC{
            deleteTabVC.delegate = self
        }
        
    }
    
    private func displayElementsBasedOnEventListCount(){
        if eventList.count == 0{
            eventsTV.isHidden = true
            viewHelper.addShadow(toView: addPlayerView, withBackGroundColor: ColorUtil.WHITE_COLOR)
            addPlayerView.alpha = 0
            self.view.addSubview(addPlayerView)
            UIView.animate(withDuration: 1.0, animations: {
                self.addPlayerView.alpha = 1.0
            })
            addPlayerView.center = self.view.center
        }else{
            eventsTV.isHidden = false
            if addPlayerView != nil{
                addPlayerView.removeFromSuperview()
            }
        }
        handleAddPlayerBarButton()
    }
    
    func handleAddPlayerBarButton(){
        if let addPlayerImage = UIImage(named: "add_player_to_board"){
            let addPlayer = UIBarButtonItem(image: addPlayerImage, style: .plain, target: self, action: #selector(MainVC.goToAddPlayerSegue))
            addPlayer.tintColor = UIColor(red: 49/255.0, green: 54/255.0, blue: 71/255.0, alpha: 1.0)
            if let count = self.navigationItem.rightBarButtonItems?.count, count <= 3{
                self.navigationItem.rightBarButtonItems?.append(addPlayer)
            }
        }
        self.navigationItem.rightBarButtonItems?[0].title = "\(userDefaultsHelper.getArrivingListCount())"
    }
    
    //MARK: - RELOAD DATA
    func reloadSameData(currentIndex : IndexPath){
        self.eventsTV.reloadRows(at: [currentIndex], with: .fade)
    }
    
    private func goToRow(currentIndex: IndexPath){
        eventsTV.scrollToRow(at: currentIndex, at: .bottom, animated: true)
    }
    
    func filterEvents(toMode: ViewModeEnum, playerName: String? = nil){
        switch toMode {
        case .all:
            eventList = gameImpl.getAllEventsFromBoard(board: currentBoard!, byStatus: nil)
        case .activeOnly:
            eventList = gameImpl.getAllEventsFromBoard(board: currentBoard!, byStatus: nil).filter({$0.active})
        case .inactiveOnly:
            eventList = gameImpl.getAllEventsFromBoard(board: currentBoard!, byStatus: nil).filter({$0.active == false})
        case .byPlayer:
            if let playerName = playerName{
                eventList = gameImpl.getAllEventsFromBoard(board: currentBoard!, byStatus: nil).filter({ (currentEvent) -> Bool in
                    if let currentPlayer = currentEvent.player, let currentPlayerName = currentPlayer.name{
                        if currentPlayerName.contains(playerName){
                            return true
                        }
                    }
                    return false
                })
            }
        default:
            eventList = gameImpl.getAllEventsFromBoard(board: currentBoard!, byStatus: toMode.getEventType())
        }
        
        DispatchQueue.main.async {
            self.eventsTV.reloadData()
            
            //TODO: JUST SCROLL WHEN ADDING NEW PLAYER
//            if self.eventList.count > 0{
//                self.goToRow(currentIndex: [IndexPath(row: self.eventList.count-1, section: 0)].first!)
//            }
        }
        
    }
    
    //MARK: - VIEW ACTIONS
    
    @objc private func goToAddPlayerSegue(){
        self.performSegue(withIdentifier: "addPlayerSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPlayerSegue"{
            let destination = segue.destination as! AddPlayerVC
            destination.currentBoard = currentBoard
        }else if segue.identifier == "addShareBoard"{
            let destination = segue.destination as! AddShareBoardVC
            destination.uniqueKeyToShare = uniqueKeyToShare
        }else if segue.identifier == "changeViewSegue"{
            let destination = segue.destination as! ChangeViewModeVC
            destination.selectedViewMode = viewMode
        }
    }
    
    @IBAction func shareOrJoinBoard(_ sender: UIButton) {
        shareBoardAI.startAnimating()
        gameImpl.shareBoard(currentBoard: currentBoard! , completion: { (key)  in
            self.uniqueKeyToShare = key
            self.shareBoardAI.stopAnimating()
            self.performSegue(withIdentifier: "addShareBoard", sender: nil)
        })
    }
    
    @IBAction func changeViewMode(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "Filtrar Eventos", message: "Seleccione el tipo de eventos que desea visualizar", preferredStyle: .actionSheet)
        for currentViewMode in ViewModeEnum.allValues{
            alertVC.addAction(currentViewMode.getActionAlert(completion: { (action) in
                self.filterEvents(toMode: currentViewMode)
                self.viewMode = currentViewMode
            }))
            
        }
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func goBackFromAddingPlayer(segue : UIStoryboardSegue){
        self.navigationItem.rightBarButtonItems?[0].title = "\(userDefaultsHelper.getArrivingListCount())"
        filterEvents(toMode: viewMode)
        displayElementsBasedOnEventListCount()
    }
    
    @IBAction func goBackFromChangeView(segue : UIStoryboardSegue){
        let changeViewVC = segue.source as! ChangeViewModeVC
        let selectedViewMode =  changeViewVC.selectedViewMode
        viewMode = selectedViewMode
        if viewMode == .byPlayer{
            if let playerName =  changeViewVC.playerNameToSearch{
                filterEvents(toMode: viewMode, playerName: playerName)
            }else{
                filterEvents(toMode: viewMode, playerName: "")
            }
        }else{
            filterEvents(toMode: viewMode)
        }
    }
    
    @IBAction func dismissHelpView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: [.curveEaseIn], animations: {
            self.helpView.transform = CGAffineTransform(scaleX: 1.1 , y: 1.1)
        }, completion: { (value) in
            UIView.animate(withDuration: 0.5, animations: {
                self.helpView.alpha = 0
            }, completion: { (value) in
                self.helpView.removeFromSuperview()
            })
        })
    }
    
    @IBAction func cancelActionToMainVC(segue: UIStoryboardSegue){
        
    }
    
}

