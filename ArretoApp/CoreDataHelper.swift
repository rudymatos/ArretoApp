import Foundation
import CoreData
import UIKit

class CoreDataHelper{
    
    static let sharedInstance = CoreDataHelper()
    private let managedObjectContext : NSManagedObjectContext!
    
    private init(){
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    //MARK: - CoreData Methods
    func saveContext(){
        do{
            try managedObjectContext.save()
            managedObjectContext.refreshAllObjects()
        }catch let error as NSError{
            print(error)
        }
    }
    
    func createObjectContext(entityName : String) -> NSManagedObject{
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext)
    }
    
    //MARK: - Board Methods
    func createBoard() -> Board{
        let board = createObjectContext(entityName: Board.className) as! Board
        board.active = true
        board.createdOn = NSDate()
        board.published = false
        saveContext()
        return board
    }
    
    func getActiveBoard() -> Board{
        let request : NSFetchRequest<Board> = Board.fetchRequest()
        request.predicate = NSPredicate(format: "active = YES")
        request.fetchLimit = 1
        do{
            let result = try managedObjectContext.fetch(request)
            return result.first!
        }catch let error as NSError{
            print(error)
            fatalError()
        }
    }
    
    func isThereAnActiveBoard() -> Bool{
        var isThereAnActiveBoard = false
        let request : NSFetchRequest<Board> = Board.fetchRequest()
        request.predicate = NSPredicate(format: "active = YES")
        request.fetchLimit = 1
        do{
            let results = try managedObjectContext.fetch(request)
            if results.count > 0{
                isThereAnActiveBoard = true
            }
        }catch let error as NSError{
            print(error)
            return isThereAnActiveBoard
        }
        return isThereAnActiveBoard
    }
    
    func changeBoardStatusToClose(board: Board){
        board.active = false
        saveContext()
    }
    
    //MARK: Events Methods
    func switchEventActiveStatus(currentEvent: Event){
        currentEvent.active = !currentEvent.active
        saveContext()
    }
    
    func changeEventStatus(currentEvent: Event, newEventStatus : EventTypeEnum){
        currentEvent.status = newEventStatus.rawValue
//        if newEventStatus == .won{
//            currentEvent.winingStreak += 1
//        }else if newEventStatus == .lost{
//            currentEvent.losingStreak += 1
//        }
        saveContext()
    }
    
    func getNextEventNumber(activeBoard board: Board) -> Int{
        var nextNumber = 0
        let request :  NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "board.createdOn = %@", board.createdOn!)
        do{
            nextNumber = try managedObjectContext.count(for: request) + 1
        }catch{
            nextNumber += 1
        }
        return nextNumber
    }
    
    func getNextArrivingEventNumber(activeBoard board: Board) -> Int{
        var nextNumber = 0
        let request :  NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "board.createdOn = %@ and status = %@", board.createdOn!, EventTypeEnum.onBoard.rawValue)
        do{
            nextNumber = try managedObjectContext.count(for: request) + 1
        }catch{
            nextNumber += 1
        }
        return nextNumber
    }
    
    
    func doesArrivingEventWasAlreadyCreated(player : Player, activeBoard board: Board) -> Bool {
        var doesArrivingEventWasAlreadyCreated = false
        let request : NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "status = %@ and player = %@ and board = %@", EventTypeEnum.onBoard.rawValue, player, board)
        request.fetchLimit = 1
        do{
            doesArrivingEventWasAlreadyCreated = try managedObjectContext.fetch(request).count > 0
        }catch{
        }
        return doesArrivingEventWasAlreadyCreated
    }
    
    func getAllActiveEventsCountFromBoard(board: Board) -> Int{
        let request : NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "board.createdOn = %@ and active = YES", board.createdOn!)
        do{
            let results = try managedObjectContext.fetch(request)
            return results.count
        }catch{
        }
        return 0
    }
    
    func getAllEventsFromBoard(board: Board) -> [Event]{
        var results = [Event]()
        let request : NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "board.createdOn = %@", board.createdOn!)
        request.sortDescriptors = [NSSortDescriptor(key: "listOrder", ascending: true)]
        do{
            results = try managedObjectContext.fetch(request)
            return results
        }catch{
        }
        return results
    }
    
    func getAllEventsFromBoard(board:Board , byStatus: EventTypeEnum?) -> [Event]{
        var results = [Event]()
        let request : NSFetchRequest<Event> = Event.fetchRequest()
        var  predicate : NSPredicate?
        if let status = byStatus{
            predicate  = NSPredicate(format: "board.createdOn = %@ AND status = %@", board.createdOn!, status.rawValue)
        }else{
            predicate = NSPredicate(format: "board.createdOn = %@", board.createdOn!)
        }
        request.predicate = predicate
        do{
            results = try managedObjectContext.fetch(request)
        }catch{
        }
        return results
    }
    
    //MARK: Player Methods
    func doesPlayerExistsAlready(name : String) -> Bool{
        var doesPlayerExistsAlready = false
        let request : NSFetchRequest<Player> = Player.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        do{
            let results = try managedObjectContext.fetch(request)
            if results.count > 0{
                doesPlayerExistsAlready = true
            }
        }catch{
            doesPlayerExistsAlready = false
        }
        return doesPlayerExistsAlready
    }
    
    func createPlayer(name : String) -> Player{
        let player = createObjectContext(entityName: Player.className) as! Player
        player.name = name
        saveContext()
        return player
    }
    
    func getAllPlayers() -> [Player]?{
        let request : NSFetchRequest<Player> = Player.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do{
            return try managedObjectContext.fetch(request)
        }catch{
            return nil
        }
    }
    
    func findPlayersByNameLike(name : String) -> [Player]?{
        let request: NSFetchRequest<Player> = Player.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@",name)
        do{
            let results = try managedObjectContext.fetch(request)
            if results.count > 0{
                return results
            }
            return nil
        }catch{
            return nil
        }
    }
    
    func findWiningLoseStreakForPlayer(event: Event) -> (Int, Int){
        
        var streaks = (wining: 0, losing: 0)
        
        if let playerName = event.player?.name, let boardCreatedOn = event.board?.createdOn{
            
            let request : NSFetchRequest<Event> = Event.fetchRequest()
            request.predicate = NSPredicate(format: "player.name = %@ and board.createdOn = %@", playerName, boardCreatedOn)
            request.sortDescriptors = [NSSortDescriptor(key: "listOrder", ascending: true)]
            
            do{
                let results = try managedObjectContext.fetch(request)
                if results.count > 0{
                    
                    var winingStreak = 0
                    var losingStreak = 0
                    
                    for currentEvent in results{
//                        if currentEvent.status == EventTypeEnum.won.rawValue{
//                            winingStreak += 1
//                        }else if currentEvent.status == EventTypeEnum.lost.rawValue{
//                            losingStreak += 1
//                        }
                    }
                    streaks.wining = winingStreak
                    streaks.losing = losingStreak
                }
            }catch{
            }
        }
        return streaks
    }
    
    func getAllPlayerWithNoEvents(board: Board) -> [Player]?{
        let request : NSFetchRequest<Player> = Player.fetchRequest()
        request.predicate = NSPredicate(format: "SUBQUERY(events, $e, any $e.board == %@).@count <= 0", board)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do{
            let results = try managedObjectContext.fetch(request)
            return results
        }catch{
        }
        return nil
    }
}

