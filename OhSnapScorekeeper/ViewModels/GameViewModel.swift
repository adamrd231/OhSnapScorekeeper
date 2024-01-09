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
    @Published var isGameRunning: Bool = true
   
    
    init() {
        addSubscibers()
    }
    
    func resetGame() {
        for index in 0..<players.count {
            players[index].rounds.removeAll()
        }
        currentRound = 0
        currentPosition = 1
    }
    
    func rewindGame() {
        // Checking if rewinding takes us back one round
        if currentPosition - 1 < 1 {

            // Checking if we are just at the beginning
            if currentRound - 1 < 0 {
                if gameState == .enteringActuals {
                    currentPosition = players.count - 1
                    gameState = .enteringGuesses
                    deleteEntry(deleting: gameState)
                }
            } else {
                // If we aren't go back a round and reset position to the end
                if gameState == .enteringGuesses {
                    currentRound -= 1
                } else {
                    gameState = .enteringGuesses
                }
                currentPosition = players.count - 1
                deleteEntry(deleting: gameState)
            }
        } else {
            currentPosition -= 1
            deleteEntry(deleting: gameState)
        }
    }
    
    func deleteEntry(deleting: GameStates) {
        switch deleting {
        case .enteringGuesses: players[currentPosition].rounds.removeLast()
        case .enteringActuals: players[currentPosition].rounds[currentRound].actualScore = nil
        }
        
    }
    
    func enterGuess(_ number: Int) {
        // Create new round for the guess
        // Only init guess, user will update with score later
        let newRound = Round(predictedScore: number)
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
                isGameRunning = false
            } else {
                currentRound += 1
            }
            
        } else {
            currentPosition += 1
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
