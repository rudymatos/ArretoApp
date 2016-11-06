import UIKit

class SelectTeamVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private let gameImpl = GameImpl()
    private var eventList = [Event]()
    private var currentBoard : Board?
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var playerTeamListTV: UITableView!
    
    private var playersInTeamAIndexes = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView(){
        currentBoard = gameImpl.getBoard()
        let allAvailableEvents = gameImpl.getAllEventsFromBoard(board: currentBoard!)
        eventList = try! gameImpl.getNextNoTeamPlayerEvents(allAvailableEvents: allAvailableEvents)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            configureView()
        }else{
            eventList = eventList.filter({ (currentEvent) -> Bool in
                if let player = currentEvent.player, let playerName  = player.name{
                    return playerName.uppercased().contains(searchText.uppercased())
                }
                return false
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerTeamCell", for: indexPath) as! PlayerTeamTVC
        let currentEvent = eventList[indexPath.row]
        cell.currentEvent = currentEvent
        return cell
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        for index in 0..<eventList.count{
            eventList[index].team = TeamEnum.noTeam.rawValue
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func setSelectRestOfPlayers(select : Bool){
        for i in 0..<eventList.count{
            let currentIndex = IndexPath(row: i, section: 0)
            if !playersInTeamAIndexes.contains(currentIndex){
                if select{
                    eventList[i].team = TeamEnum.teamB.rawValue
                }else{
                    eventList[i].team = TeamEnum.noTeam.rawValue
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as! PlayerTeamTVC
        currentCell.setSelected(false, animated: false)
        
        if eventList[indexPath.row].team != TeamEnum.teamB.rawValue{
            
            var playersInTeamA = playersInTeamAIndexes.count
            
            if playersInTeamAIndexes.contains(indexPath){
                playersInTeamAIndexes.remove(at: playersInTeamAIndexes.index(of: indexPath)!)
                eventList[indexPath.row].team  = TeamEnum.noTeam.rawValue
            }else{
                if playersInTeamA <= gameImpl.maxNumberOfActiveEvents / 2{
                    playersInTeamAIndexes.append(indexPath)
                    currentCell.changePlayerTeam()
                }
            }
            
            playersInTeamA = playersInTeamAIndexes.count
            
            DispatchQueue.main.async {
                if playersInTeamA == self.gameImpl.maxNumberOfActiveEvents / 2{
                    self.titleLBL.text = "Verifique su seleccion"
                    self.setSelectRestOfPlayers(select: true)
                }else{
                    let numberOfPlayersLeft = (self.gameImpl.maxNumberOfActiveEvents / 2) - playersInTeamA
                    self.titleLBL.text = "Seleccione \(numberOfPlayersLeft) Jugadores (Negros)"
                    self.setSelectRestOfPlayers(select: false)
                }
                self.playerTeamListTV.reloadData()
            }
        }
    }
    
}
