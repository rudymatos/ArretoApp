//
//  ViewController.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 10/22/16.
//  Copyright © 2016 Bearded Gentleman. All rights reserved.
//

import UIKit

class MainVC: UIViewController, ActionExecuter {
    
    @IBOutlet weak var eventsTV: UITableView!
    @IBOutlet weak var shareBoardAI: UIActivityIndicatorView!
    @IBOutlet var addPlayerView: UIView!
    @IBOutlet var helpView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    var eventList = [Event]()
    private var currentBoard : Board?
    private let gameImpl = GameImpl()
    private var viewMode = ViewModeEnum.all
    private var uniqueKeyToShare : String?
    private let viewHelper = ViewHelper.sharedInstance
    
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
                        gameImpl.changeEventStatus(currentBoard : currentBoard!, currentEvent: currentEvent, status: newEventType)
                        reloadSameData(currentIndex: indexPath)
                    }else{
                        gameImpl.inactiveEvent(currentBoard: currentBoard!, currentEvent: currentEvent)
                        reloadSameData(currentIndex: indexPath)
                        try! gameImpl.createEvent(status: newEventType, board: currentBoard!, player: currentPlayer,winLostStreaks: (0,0), summaryText: nil)
                        filterEvents(toMode: viewMode)
                    }
                case .won, .lost:
                    gameImpl.inactiveEvent(currentBoard: currentBoard!, currentEvent: currentEvent)
                    gameImpl.changeEventStatus(currentBoard : currentBoard!, currentEvent: currentEvent, status: newEventType)
                    reloadSameData(currentIndex: indexPath)
                    let winLostStreak = gameImpl.findWinLostStreak(currentEvent: currentEvent)
                    try! gameImpl.createEvent(status: .waiting, board: currentBoard!, player: currentPlayer,winLostStreaks: winLostStreak, summaryText: nil)
                    filterEvents(toMode: viewMode)
                case .left:
                    
                    gameImpl.inactiveEvent(currentBoard: currentBoard!, currentEvent: currentEvent)
                    let winLostStreak = gameImpl.findWinLostStreak(currentEvent: currentEvent)
                    currentEvent.winingStreak = Int16(winLostStreak.winStreak)
                    currentEvent.losingStreak = Int16(winLostStreak.lostStreak)
                    gameImpl.changeEventStatus(currentBoard : currentBoard!, currentEvent: currentEvent, status: newEventType)
                    reloadSameData(currentIndex: indexPath)
                    
                    if gameImpl.getAllActiveEventsCountFromBoard(board: currentBoard!) == 0{
                        try! gameImpl.createEvent(status: .summary, board: currentBoard!, player: nil,winLostStreaks: nil, summaryText: generateSummaryText())
                        handleAddPlayerBarButton(shouldShow: false)
                        filterEvents(toMode: viewMode)
                    }
                case .temporaryInjured, .waiting, .onHold:
                    gameImpl.changeEventStatus(currentBoard : currentBoard!, currentEvent: currentEvent, status: newEventType)
                    reloadSameData(currentIndex: indexPath)
                default:
                    print("nothing yet")
                }
            }
        }
    }
    
    private func generateSummaryText() -> String{
        var summaryText = ""
        for currentEvent in eventList{
            if currentEvent.status == EventTypeEnum.left.rawValue{
                if let playerName = currentEvent.player?.name{
                    let totalGamesPlayed = currentEvent.winingStreak + currentEvent.losingStreak
                    summaryText += "\(playerName.uppercased()) - T: \(totalGamesPlayed) - G: \(currentEvent.winingStreak) - P: \(currentEvent.losingStreak)\n"
                }
            }
        }
        return summaryText
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
        blurEffect.effect = nil
        blurEffect.isHidden = true
        shareBoardAI.stopAnimating()
        eventsTV.rowHeight = UITableViewAutomaticDimension
        eventsTV.estimatedRowHeight = 150
        viewHelper.addShadow(toView: helpView)
        displayElementsBasedOnEventListCount()
    }
    
    private func displayElementsBasedOnEventListCount(){
        if eventList.count == 0{
            eventsTV.isHidden = true
            viewHelper.addShadow(toView: addPlayerView)
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
        if eventList.filter({$0.status == EventTypeEnum.summary.rawValue}).count >= 1{
            handleAddPlayerBarButton(shouldShow: false)
        }else{
            handleAddPlayerBarButton()
        }
    }
    
    private func handleAddPlayerBarButton(shouldShow : Bool = true){
        if shouldShow {
            if let addPlayerImage = UIImage(named: "add_player_to_board"){
                let addPlayer = UIBarButtonItem(image: addPlayerImage, style: .plain, target: self, action: #selector(MainVC.goToAddPlayerSegue))
                addPlayer.tintColor = UIColor(red: 49/255.0, green: 54/255.0, blue: 71/255.0, alpha: 1.0)
                if let count = self.navigationItem.rightBarButtonItems?.count, count <= 3{
                    self.navigationItem.rightBarButtonItems?.append(addPlayer)
                }
            }
        }else{
            if let count = navigationItem.rightBarButtonItems?.count , count > 3{
                self.navigationItem.rightBarButtonItems?.remove(at: count - 1)
            }
        }
    }
    
    @objc private func goToAddPlayerSegue(){
        self.performSegue(withIdentifier: "addPlayerSegue", sender: nil)
    }
    
    func configureApp(){
        //Check connectivity to show/hide shared button in navigation bar
        currentBoard = gameImpl.getBoard()
        filterEvents(toMode: viewMode)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPlayerSegue"{
            let destination = segue.destination as! AddPlayerVC
            destination.selectedBoard = currentBoard
        }else if segue.identifier == "addShareBoard"{
            let destination = segue.destination as! AddShareBoardVC
            destination.uniqueKeyToShare = uniqueKeyToShare
        }else if segue.identifier == "changeViewSegue"{
            let destination = segue.destination as! ChangeViewModeVC
            destination.selectedViewMode = viewMode
        }
    }
    
    
    //MARK: - RELOAD DATA
    private func reloadSameData(currentIndex : IndexPath){
        self.eventsTV.reloadRows(at: [currentIndex], with: .fade)
    }
    
    private func goToRow(currentIndex: IndexPath){
        eventsTV.scrollToRow(at: currentIndex, at: .bottom, animated: true)
    }
    
    private func filterEvents(toMode: ViewModeEnum, playerName: String? = nil){
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
            if self.eventList.count > 0{
                self.goToRow(currentIndex: [IndexPath(row: self.eventList.count-1, section: 0)].first!)
            }
        }
        
    }
    
    //MARK: - VIEW ACTIONS
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
        filterEvents(toMode: viewMode)
        displayElementsBasedOnEventListCount()
    }
    
    @IBAction func goBackFromChangeView(segue : UIStoryboardSegue){
        print("unwind")
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
    
    @IBAction func showHelpView(_ sender: UIButton) {
        helpView.alpha = 0
        helpView.center = self.view.center
        self.view.addSubview(helpView)
        self.blurEffect.isHidden = false
        helpView.transform = CGAffineTransform(scaleX: 1.5 , y: 1.5)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: [.curveEaseIn], animations: {
            self.helpView.alpha = 1
            self.helpView.transform = CGAffineTransform.identity
            
            self.blurEffect.effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        }, completion: nil)
        
    }
    
    @IBAction func dismissHelpView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: [.curveEaseIn], animations: {
            self.helpView.transform = CGAffineTransform(scaleX: 1.1 , y: 1.1)
        }, completion: { (value) in
            UIView.animate(withDuration: 0.5, animations: {
                self.helpView.alpha = 0
                self.blurEffect.effect = nil
                self.blurEffect.isHidden = true
            }, completion: { (value) in
                self.helpView.removeFromSuperview()
            })
        })
    }
    
    @IBAction func cancelActionToMainVC(segue: UIStoryboardSegue){
        
    }
    
    
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentEvent = eventList[indexPath.row]
        if let eventStatus = currentEvent.status, let eventTypeEnum = EventTypeEnum(rawValue: eventStatus){
            switch  eventTypeEnum {
            case .won, .lost, .playing, .left:
                return 75
            case .arrived, .waiting, .onHold, .temporaryInjured:
                return 75
            case .summary:
                return CGFloat(75 + (eventList.filter({$0.status == EventTypeEnum.summary.rawValue}).count * 30))
            }
        }else{
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentEvent = eventList[indexPath.row]
        if let eventStatus = currentEvent.status, let eventTypeEnum = EventTypeEnum(rawValue: eventStatus){
            if eventTypeEnum == .summary{
                let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as! SummaryTVC
                cell.currentEvent = currentEvent
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
