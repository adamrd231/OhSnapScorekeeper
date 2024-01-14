import Foundation
import Combine
import SwiftUI

class GameViewModel: ObservableObject {
    var ohSnapGame = OhSnapGame()
    
    @Published var players: [Player] = []
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
    @Published var currentPosition: Int = 0
    
    private var cancellable = Set<AnyCancellable>()
    
    @Published var gameState: GameStates = .enteringGuesses
    @Published var isGameRunning: Bool = true
    
    func resetGame() {
        for index in 0..<players.count {
            players[index].rounds.removeAll()
        }
        currentRound = 0
        currentPosition = 0
    }
    
    func rewindGame() {
        // Checking if rewinding takes us back one round
        if currentPosition - 1 < 0 {

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
    
    func enterGuess(_ guess: Int) {
        // Check if there is a guess
        if players[currentPosition].rounds[currentRound].predictedScore == nil {
           // make guess
            players[currentPosition].rounds[currentRound].predictedScore = guess
        
            if currentPosition + 1 >= players.count {
                currentPosition = 0
                gameState = .enteringActuals
            } else {
                currentPosition += 1
          
            }
        }
    }
    
    func enterActual(_ score: Int) {
        // Entering actual numbers
        if players[currentPosition].rounds[currentRound].actualScore == nil {
            players[currentPosition].rounds[currentRound].actualScore = score
            
            if currentPosition + 1 >= players.count {
                currentPosition = 0
                gameState = .enteringGuesses
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
    }
    
    func prepGameScoreCard() {
        // Each player needs as many empty Round objects as there are rounds in calculcated round array
        for playerIndex in 0..<players.count {
            for _ in 0..<calculatedRoundArray.count {
                players[playerIndex].rounds.append(Round())
            }
        }

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
