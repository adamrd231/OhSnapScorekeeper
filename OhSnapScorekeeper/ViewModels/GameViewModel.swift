import Foundation
import Combine

class GameViewModel: ObservableObject {
    var ohSnapGame = OhSnapGame()
    
    @Published var players: [Player] = [Player(name: "Round", position: 0)]
    var startingNumber: Int = 7
    var calculatedRoundArray: [Int] {
        var returnedArray:[Int] = []
        for number in (0...startingNumber).reversed() {
            returnedArray.append(number)
        }
        for number in (1...startingNumber) {
            returnedArray.append(number)
        }
        return returnedArray
    }
    
    @Published var currentRound: Int = 0
    @Published var currentPosition: Int = 1
    
    private var cancellable = Set<AnyCancellable>()
    
    @Published var gameState: GameStates = .enteringGuesses
    
    init() {
        addSubscibers()
    }
    
    
    func addSubscibers() {
        $players
            .combineLatest($currentRound)
            .sink { [weak self] players, currentRound in
                var isRoundOver = false

                let removedRoundPlayer = players.filter({ $0.name != "Round" })
                
                let filtered = removedRoundPlayer.filter({ $0.rounds.count != currentRound + 1 })
                if filtered.count == 0 {
                    isRoundOver = true
                }
                print("filtered \(filtered.count)")

                if isRoundOver {
                    self?.gameState = .enteringActuals
                } else {
                    self?.gameState = .enteringGuesses
                }
                
            }
            .store(in: &cancellable)

    }
    
    var isRoundStarted: Bool {
        return players[currentPosition].rounds.count >= currentPosition
    }
    

}

enum GameStates {
    case enteringGuesses
    case enteringActuals
    
    var description: String {
        switch self {
        case .enteringGuesses: return "Guessing"
        case .enteringActuals: return "Actuals"
        }
    }
}
