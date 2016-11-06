//
//  ViewController.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/22/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ActionExecuter {
    
    
    @IBOutlet weak var eventsTV: UITableView!
    
    private var eventList = [Event]()
    private var currentBoard : Board?
    private let gameImpl = GameImpl()
    
    private var uniqueKeyToShare : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApp()
    }
    
    
    //MARK: - ACTIONEXECUTER
    func changeStatusToPlaying(currentCell: UITableViewCell) {
        createEvent(currentCell: currentCell, newEventType: .playing)
    }
    
    private func createEvent(currentCell: UITableViewCell, newEventType : EventTypeEnum){
        if let indexPath = eventsTV.indexPath(for: currentCell){
            let currentEvent = eventList[indexPath.row]
            if let currentPlayer = currentEvent.player{
                eventsTV.reloadRows(at: [indexPath], with: .fade)
                switch newEventType {
                case .playing:
                    if currentEvent.status == EventTypeEnum.waiting.rawValue{
                        gameImpl.changeEventToPlaying(currentEvent: currentEvent)
                        reloadSameData(currentIndex: indexPath)
                    }else{
                        gameImpl.inactiveEvent(currentEvent: currentEvent)
                        reloadSameData(currentIndex: indexPath)
                        try! gameImpl.createEvent(status: newEventType, board: currentBoard!, player: currentPlayer,winLostStreaks: (0,0))
                        reloadNewData()
                    }
                case .won, .lost:
                    gameImpl.inactiveEvent(currentEvent: currentEvent)
                    gameImpl.changeEventFromPlayingToWinOrLost(currentEvent: currentEvent, win: newEventType == .won ? true : false)
                    reloadSameData(currentIndex: indexPath)
                    let winLostStreak = gameImpl.findWinLostStreak(currentEvent: currentEvent)
                    try! gameImpl.createEvent(status: .waiting, board: currentBoard!, player: currentPlayer,winLostStreaks: winLostStreak)
                    reloadNewData()
                default:
                    print("nothing yet")
                }
            }
        }
    }
    
    func changeStatusFromPlayingToWinOrLost(currentCell: UITableViewCell, win: Bool) {
        if win {
            createEvent(currentCell: currentCell, newEventType: .won)
        }else{
            createEvent(currentCell: currentCell, newEventType: .lost)
        }
    }
    
    //MARK: - VIEW CONFIGURATION
    func configureApp(){
        //Check connectivity to show/hide shared button in navigation bar
        currentBoard = gameImpl.getBoard()
        eventList = gameImpl.getAllEventsFromBoard(board: currentBoard!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPlayerSegue"{
            let destination = segue.destination as! AddPlayerVC
            destination.selectedBoard = currentBoard
        }else if segue.identifier == "addShareBoard"{
            let destination = segue.destination as! AddShareBoardVC
            destination.uniqueKeyToShare = uniqueKeyToShare
        }
    }
    
    
    //MARK: - RELOAD DATA
    private func reloadSameData(currentIndex : IndexPath){
        eventsTV.reloadRows(at: [currentIndex], with: .fade)
        goToLastRow(currentIndex: currentIndex)
    }
    
    private func goToLastRow(currentIndex: IndexPath){
        eventsTV.scrollToRow(at: currentIndex, at: .top, animated: true)
    }
    
    private func reloadNewData(){
        eventList = gameImpl.getAllEventsFromBoard(board: currentBoard!)
        var newEventsIndexes = [IndexPath]()
        for i in eventList.count-1..<eventList.count{
            newEventsIndexes.append(IndexPath(row: i, section: 0))
        }
        DispatchQueue.main.async {
            self.eventsTV.insertRows(at: newEventsIndexes, with: .right)
            self.goToLastRow(currentIndex: newEventsIndexes.first!)
        }
    }
    
    
    //MARK: - VIEW ACTIONS
    @IBAction func shareOrJoinBoard(_ sender: UIBarButtonItem) {
        uniqueKeyToShare = gameImpl.generateUniqueKeyForBoard()
        print("generated key : \(uniqueKeyToShare)")
        performSegue(withIdentifier: "addShareBoard", sender: nil)
        
    }
    @IBAction func goBackFromAddingPlayer(segue : UIStoryboardSegue){
        reloadNewData()
    }
    @IBAction func deleteBoardDidTouch(_ sender: UIBarButtonItem) {
        //First create alert and notify the user
        
        let deleteBoardAC = UIAlertController(title: "Borrar Pizarra", message: "Desea borrar la pizarra? Todas las entradas seran eliminadas", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Si, estoy seguro!", style: .destructive, handler: { _ in
            self.gameImpl.clearBoard(board: self.currentBoard!)
            self.configureApp()
            DispatchQueue.main.async {
                self.eventsTV.reloadData()
            }})
        deleteBoardAC.addAction(cancelAction)
        deleteBoardAC.addAction(deleteAction)
        
        present(deleteBoardAC, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentEvent = eventList[indexPath.row]
        let heightConstant = 10
        if let eventStatus = currentEvent.status, let eventEnumType = EventTypeEnum(rawValue: eventStatus){
            switch eventEnumType {
            case .arrived, .onHold, .waiting:
                if currentEvent.active{
                    return CGFloat(75 + heightConstant)
                }else{
                    return CGFloat(90 + heightConstant)
                }
            case .playing, .won, .lost:
                if currentEvent.active{
                    return CGFloat(50 + heightConstant)
                }else{
                    return CGFloat(120 + heightConstant)
                }
            default:
                return CGFloat(50 + heightConstant)
            }
        }else{
            return CGFloat(50 + heightConstant)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentEvent = eventList[indexPath.row]
        if let eventStatus = currentEvent.status, let eventTypeEnum = EventTypeEnum(rawValue: eventStatus), let playerName = currentEvent.player?.name{
            let playerInfoDTO = PlayerInfoDTO(playerName: playerName, arrivingOrder: Int(currentEvent.arrivingOrder), listOrder: Int(currentEvent.listOrder), eventStatus: eventTypeEnum, winingStreak: Int(currentEvent.winingStreak), losingStreak: Int(currentEvent.losingStreak))
            switch eventTypeEnum{
            case .arrived, .waiting, .onHold:
                if currentEvent.active {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "aWOHCell", for: indexPath) as! AWOHTVC
                    cell.playerInfoDTO = playerInfoDTO
                    cell.delegate = self
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "aWOHInactiveCell", for: indexPath) as! AWOHInactiveTVC
                    cell.playerInfoDTO = playerInfoDTO
                    return cell
                }
            case .playing, .won, .lost:
                if currentEvent.active{ //JUST PLAYING EVENTS WOULD BE ACTIVE
                    let cell = tableView.dequeueReusableCell(withIdentifier: "playingCell", for: indexPath) as! PlayingTVC
                    cell.delegate = self
                    cell.playerInfoDTO = playerInfoDTO
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "wonLostCell", for: indexPath) as! PlayingInactiveTVC
                    cell.playerInfoDTO = playerInfoDTO
                    return cell
                }
            default:
                return UITableViewCell()
            }
        }else{
            return UITableViewCell()
        }
        
    }
}

