import UIKit

class AddPlayerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var playersTable: UITableView!
    @IBOutlet weak var addPlayerView: UIView!
    
    @IBOutlet weak var playersTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addPlayerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerSearchBar: UISearchBar!
    
    private final let normalViewHeight = 130
    private let gameImpl = GameImpl()
    private var filteredPlayerList : [Player]!
    private var selectedPlayer : Player?
    private let userDefaultsHelper = UserDefaultsHelper.sharedInstance
    var currentBoard : Board?
    
    //MARK: - Configuration Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewData()
        configureView()
    }
    
    func configureViewData(){
        if let currentBoard = currentBoard{
            filteredPlayerList = gameImpl.getAllPlayerWithNoEvents(board: currentBoard) ?? [Player]()
        }
    }
    
    func configureView(){
        self.view.layoutIfNeeded()
        addPlayerView.layer.cornerRadius = 4
        addPlayerView.layer.masksToBounds = true
        configurePlayerListTV()
        
        addPlayerView.layer.masksToBounds = false
        addPlayerView.layer.shadowColor = UIColor.black.cgColor
        addPlayerView.layer.shadowOpacity = 1
        addPlayerView.layer.shadowOffset = CGSize.zero
        addPlayerView.layer.shadowRadius = 10
        
        
        
    }
    
    func configurePlayerListTV(){
        if filteredPlayerList.count == 0{
            addPlayerViewConstraint.constant = CGFloat(normalViewHeight +  44)
            playersTableHeightConstraint.constant = 44
        }else if filteredPlayerList.count >= 1 && filteredPlayerList.count <= 6{
            let newHeight = filteredPlayerList.count * 44
            addPlayerViewConstraint.constant = CGFloat(newHeight + normalViewHeight)
            playersTableHeightConstraint.constant = CGFloat(newHeight)
        }else{
            addPlayerViewConstraint.constant = CGFloat(271 + normalViewHeight)
            playersTableHeightConstraint.constant = 271
        }
    }
    
    //MARK: - Actions
    @IBAction func dismissCurrentVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPlayerDidTouch(_ sender: UIButton) {
        if selectedPlayer == nil{
            guard let playerName = playerSearchBar.text else{
                //Show message name is invalid
                return
            }
            if playerSearchBar.text == nil || playerName.characters.count <= Player.minPlayerNameLength{
                //Show message name is invalid
                return
            }
            do{
                selectedPlayer = try gameImpl.addPlayer(name: playerName)
            }catch{
                
            }
        }
        if let selectedPlayer = selectedPlayer{
            do{
                try gameImpl.createEvent(status: EventTypeEnum.onBoard, board: currentBoard!, player: selectedPlayer, winLostStreaks: (0,0), summaryText: nil)
                try gameImpl.createSeparator(currentBoard: currentBoard!)
                gameImpl.processEventsToCalculate(currentBoard: currentBoard!)
                userDefaultsHelper.incrementArrivingListCount()
                performSegue(withIdentifier: "backToMainScreenSegue", sender: nil)
            }catch ArretoExceptions.ArrivingEventAlreadyExists{
                //show message
            }catch{
                //show message
            }
        }
    }
    
    //MARK: - SearchBard Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            configureViewData()
            configurePlayerListTV()
            playersTable.reloadData()
        }else{
            filteredPlayerList = filteredPlayerList.filter({ (currentPlayer) -> Bool in
                if let currentPlayerName = currentPlayer.name{
                    return currentPlayerName.uppercased().contains(searchText.uppercased())
                }
                return false
            })
            configurePlayerListTV()
            playersTable.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //MARK: - TableView Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlayerList.count == 0 ? 1 : filteredPlayerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredPlayerList.count == 0{
            return tableView.dequeueReusableCell(withIdentifier: "playerNotFoundCell", for: IndexPath(row: 0, section: 0))
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "playerInfoCell", for: indexPath) as! PlayerNameTCV
            if let playerName = filteredPlayerList[indexPath.row].name{
                cell.playerName = playerName
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredPlayerList.count == 0{
            tableView.deselectRow(at: IndexPath(row:0, section:0), animated: false)
        }else{
            if let playerName = filteredPlayerList[indexPath.row].name{
                selectedPlayer = gameImpl.findPlayers(byName: playerName)?.first
            }
        }
    }
}
