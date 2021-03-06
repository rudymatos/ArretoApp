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
        configureView()
    }
    
    
    //MARK: - ACTIONEXECUTER
    func changeStatusToPlaying(currentCell: UITableViewCell) {
        createEvent(currentCell: currentCell, newEventType: .playing)
    }
    
    func handleActionSheet(currentCell: UITableViewCell) {
        if let currentIndex = eventsTV.indexPath(for: currentCell){
            let currentEvent = eventList[currentIndex.row]
            if let playerName = currentEvent.player?.name{
                let actionSheet = UIAlertController(title: playerName, message: "Seleccione la accion a realizar", preferredStyle: .actionSheet)
                
                if currentEvent.status != EventTypeEnum.playing.rawValue{
                    let left = UIAlertAction(title: EventTypeEnum.left.getSpanish(), style: .destructive, handler: { (action) in
                        self.createEvent(currentCell: currentCell, newEventType: .left)
                    })
                    actionSheet.addAction(left)
                }
                
                if currentEvent.status != EventTypeEnum.arrived.rawValue{
                    
                    let temporalInjured = UIAlertAction(title: EventTypeEnum.temporaryInjured.getSpanish(), style: .default, handler: { (action) in
                        self.createEvent(currentCell: currentCell, newEventType: .temporaryInjured)
                    })
                    actionSheet.addAction(temporalInjured)
                    
                    if currentEvent.status != EventTypeEnum.waiting.rawValue && currentEvent.status != EventTypeEnum.playing.rawValue{
                        let waiting = UIAlertAction(title: EventTypeEnum.waiting.getSpanish(), style: .default, handler: { (action) in
                            self.createEvent(currentCell: currentCell, newEventType: .waiting)
                        })
                        actionSheet.addAction(waiting)
                    }
                    
                    if currentEvent.status != EventTypeEnum.onHold.rawValue && currentEvent.status != EventTypeEnum.playing.rawValue{
                        let onHold = UIAlertAction(title: EventTypeEnum.onHold.getSpanish(), style: .default, handler: { (action) in
                            self.createEvent(currentCell: currentCell, newEventType: .onHold)
                        })
                        actionSheet.addAction(onHold)
                    }
                }
                
                let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                actionSheet.addAction(cancel)
                
                present(actionSheet, animated: true, completion: nil)
            }
        }
    }
    
    private func createEvent(currentCell: UITableViewCell, newEventType : EventTypeEnum){
        if let indexPath = eventsTV.indexPath(for: currentCell){
            let currentEvent = eventList[indexPath.row]
            if let currentPlayer = currentEvent.player{
                eventsTV.reloadRows(at: [indexPath], with: .fade)
                switch newEventType {
                case .playing:
                    if currentEvent.status == EventTypeEnum.waiting.rawValue || currentEvent.status == EventTypeEnum.temporaryInjured.rawValue || currentEvent.status == EventTypeEnum.onHold.rawValue{
                        gameImpl.changeEventStatus(currentEvent: currentEvent, status: newEventType)
                        reloadSameData(currentIndex: indexPath)
                    }else{
                        gameImpl.inactiveEvent(currentEvent: currentEvent)
                        reloadSameData(currentIndex: indexPath)
                        try! gameImpl.createEvent(status: newEventType, board: currentBoard!, player: currentPlayer,winLostStreaks: (0,0))
                        reloadNewData()
                    }
                case .won, .lost:
                    gameImpl.inactiveEvent(currentEvent: currentEvent)
                    gameImpl.changeEventStatus(currentEvent: currentEvent, status: newEventType)
                    reloadSameData(currentIndex: indexPath)
                    let winLostStreak = gameImpl.findWinLostStreak(currentEvent: currentEvent)
                    try! gameImpl.createEvent(status: .waiting, board: currentBoard!, player: currentPlayer,winLostStreaks: winLostStreak)
                    reloadNewData()
                case .left:
                    
                    gameImpl.inactiveEvent(currentEvent: currentEvent)
                    let winLostStreak = gameImpl.findWinLostStreak(currentEvent: currentEvent)
                    currentEvent.winingStreak = Int16(winLostStreak.winStreak)
                    currentEvent.losingStreak = Int16(winLostStreak.lostStreak)
                    gameImpl.changeEventStatus(currentEvent: currentEvent, status: newEventType)
                    reloadSameData(currentIndex: indexPath)
                    
                    if gameImpl.getAllActiveEventsCountFromBoard(board: currentBoard!) == 0{
                        try! gameImpl.createEvent(status: .summary, board: currentBoard!, player: nil,winLostStreaks: nil)
                        reloadNewData()
                    }
                case .temporaryInjured, .waiting, .onHold:
                    gameImpl.changeEventStatus(currentEvent: currentEvent, status: newEventType)
                    reloadSameData(currentIndex: indexPath)
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
    func configureView(){
        eventsTV.estimatedRowHeight = 150
        eventsTV.rowHeight = UITableViewAutomaticDimension
    }
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
        self.eventsTV.reloadRows(at: [currentIndex], with: .fade)
    }
    
    private func goToRow(currentIndex: IndexPath){
        eventsTV.scrollToRow(at: currentIndex, at: .bottom, animated: true)
    }
    
    private func reloadNewData(){
        eventList = gameImpl.getAllEventsFromBoard(board: currentBoard!)
        DispatchQueue.main.async {
            self.eventsTV.reloadData()
            self.goToRow(currentIndex: [IndexPath(row: self.eventList.count-1, section: 0)].first!)
        }
    }
    
    
    //MARK: - VIEW ACTIONS
    @IBAction func shareOrJoinBoard(_ sender: UIButton) {
        uniqueKeyToShare = gameImpl.generateUniqueKeyForBoard()
        print("generated key : \(uniqueKeyToShare)")
        performSegue(withIdentifier: "addShareBoard", sender: nil)
        
    }
    @IBAction func goBackFromAddingPlayer(segue : UIStoryboardSegue){
        reloadNewData()
    }
    
    @IBAction func deleteBoardDidTouch(_ sender: UIButton) {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentEvent = eventList[indexPath.row]
        if let eventStatus = currentEvent.status, let eventTypeEnum = EventTypeEnum(rawValue: eventStatus){
            if eventTypeEnum == .summary{
                let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as! SummaryTVC
                cell.eventList = eventList
                return cell
            }else{
                if let playerName = currentEvent.player?.name{
                    let playerInfoDTO = PlayerInfoDTO(playerName: playerName, arrivingOrder: Int(currentEvent.arrivingOrder), listOrder: Int(currentEvent.listOrder), eventStatus: eventTypeEnum, winingStreak: Int(currentEvent.winingStreak), losingStreak: Int(currentEvent.losingStreak))
                    switch eventTypeEnum{
                    case .arrived, .waiting, .onHold, .temporaryInjured:
                        if currentEvent.active {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "aWOHTICell", for: indexPath) as! AWOHTITVC
                            cell.playerInfoDTO = playerInfoDTO
                            cell.delegate = self
                            return cell
                        }else{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "AWOHTIInactiveCell", for: indexPath) as! AWOHTIInactiveTVC
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
                    case .left:
                        let cell = tableView.dequeueReusableCell(withIdentifier: "leftCell", for: indexPath) as! LeftTVC
                        cell.playerInfoDTO = playerInfoDTO
                        return cell
                    default:
                        return UITableViewCell()
                    }
                }else{
                    return UITableViewCell()
                }
                
            }
        }else{
            return UITableViewCell()
        }
    }
    
}
