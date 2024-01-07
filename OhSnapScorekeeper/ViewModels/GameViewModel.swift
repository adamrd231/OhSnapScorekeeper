import Foundation
import Combine
import SwiftUI

class GameViewModel: ObservableObject {
    var ohSnapGame = OhSnapGame()
    
    @Published var players: [Player] = [Player(name: "Round", position: 0)]
    var startingNumber: Int = 7
    var calculatedRoundArray: [Int] {
        var returnedArray:[Int] = []
        for number in (1...startingNumber).reversed() {
            returnedArray.append(number)
        }
        for number in (2...startingNumber) {
            returnedArray.append(number)
        }
        return returnedArray
    }
    
    @Published var currentRound: Int = 0
    @Published var currentPosition: Int = 1
    
    private var cancellable = Set<AnyCancellable>()
    
    @Published var gameState: GameStates = .enteringGuesses
    @Published var isGameOver: Bool = false
    
    init() {
        addSubscibers()
    }
    
    func scrollTo(_ proxy: ScrollViewProxy, with item: UUID) {
        proxy.scrollTo(item)
    }
    
    func enterGuess(_ number: Int) {
        // Create new round for the guess
        // Only init guess, user will update with score later
        var newRound = Round(predictedScore: number)
        // Append Round to player that made the guess
        players[currentPosition].rounds.append(newRound)
        
        // Check that there is another player to move to, otherwise reset to beginning position for entering scores
        if currentPosition + 1 >= players.count {
            currentPosition = 1
        } else {
            currentPosition += 1
        }
    }
    
    func enterActual(_ number: Int) {
        // Entering actual numbers
        players[currentPosition].rounds[currentRound].actualScore = number
        if currentPosition + 1 >= players.count {
            currentPosition = 1
            // check if game is over
            if currentRound + 1 >= calculatedRoundArray.count {
                // Game Over
                isGameOver = true
            } else {
                currentRound += 1
            }
            
        } else {
            currentPosition += 1
        }
    }
    
    func rewind() {
        // get current round and Position
        // reverse back one position
        if currentPosition - 1 < 0 {
          
        }
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
