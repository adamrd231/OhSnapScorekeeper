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
    @Published var dealerPosition: Int = 0
    
    private var cancellable = Set<AnyCancellable>()
    
    @Published var gameState: GameStates = .enteringGuesses
    @Published var isGameRunning: Bool = true
    
    func resetGame() {
        for index in 0..<players.count {
            for roundIndex in 0..<players[index].rounds.count {
                players[index].rounds[roundIndex].predictedScore = nil
                players[index].rounds[roundIndex].actualScore = nil
            }
        }
        currentRound = 0
        currentPosition = 0
    }
    
    func rewindGame() {
        switch gameState {
        // Currently entering guesses
        case .enteringGuesses:
            // If nothing guesses on row so far..

            if players.filter({ $0.rounds[currentRound].predictedScore != nil }).count == 0 {
                print("No entries")
                currentRound -= 1
                currentPosition = players.count - 1
                gameState = .enteringActuals
                deleteEntry()

                dealerPosition -= 1
                return
            }
            
            
            if currentPosition - 1 < 0 {
                if currentRound - 1 < 0 {
                    print("At the beginning")
                } else {
                    currentRound -= 1
                    currentPosition = players.count - 1
                    gameState = .enteringActuals
                    deleteEntry()
                }
            } else {
                currentPosition -= 1
                deleteEntry()
            }
        // Currently entering a score
        case .enteringActuals:
            print("Entering score")
            if currentPosition - 1 < 0 {
                gameState = .enteringGuesses
                currentPosition = players.count - 1
            } else {
                currentPosition -= 1
            }
            deleteEntry()
        }
        
    }
    
    func updateGameState() {
        let playersGuessing = players.filter({ $0.rounds[currentRound].predictedScore == nil })
        if playersGuessing.count == 0 {
            gameState = .enteringActuals
        } else {
            gameState = .enteringGuesses
        }
    }
    
    func deleteEntry() {
        switch gameState {
        case .enteringGuesses:
            print("Delete guess")
            players[currentPosition].rounds[currentRound].predictedScore = nil
        case .enteringActuals:
            print("Delete score")
            players[currentPosition].rounds[currentRound].actualScore = nil
        }
        
    }
    
    func enterGuess(_ guess: Int) {
        // Check if there is a guess
        if players[currentPosition].rounds[currentRound].predictedScore == nil {
           // make guess
            players[currentPosition].rounds[currentRound].predictedScore = guess
        }
        
        // Update player position
        if currentPosition + 1 >= players.count {
            currentPosition = 0
        } else {
            currentPosition += 1
        }
        updateGameState()
    }
    
    func enterActual(_ score: Int) {
        // Check if current position has a score, if not
        if players[currentPosition].rounds[currentRound].actualScore == nil {
            // Enter score
            players[currentPosition].rounds[currentRound].actualScore = score
            
            // Check if that was the last score we needed and if we should switch back to guessing
            let playersEnteringScores = players.filter({ $0.rounds[currentRound].actualScore == nil })
            
            // If no more players entering scores
            if playersEnteringScores.count == 0 {
                // Go back to guessing
                gameState = .enteringGuesses
                if currentRound + 1 >= calculatedRoundArray.count {
                    // Game Over
                    isGameRunning = false
                } else {
                    currentRound += 1
                    print("Dealer score: \(dealerPosition)")
                    // Update dealer position
                    if dealerPosition + 1 >= players.count {
                        print("Dealer position 0")
                        dealerPosition = 0
                    } else {
                        print("Add one to dealer position")
                        dealerPosition += 1
                    }
                    // Update current position with the correct starting place
                    currentPosition = dealerPosition
                }
            } else {
                // Still players entering scores
                // Update player position
                if currentPosition + 1 >= players.count {
                    currentPosition = 0
                } else {
                    currentPosition += 1
                }
            }
        }
    }
    
    func prepGameScoreCard() {
        // Each player needs as many empty Round objects as there are rounds in calculcated round array
        for playerIndex in 0..<players.count {
            for _ in 0..<calculatedRoundArray.count {
                players[playerIndex].rounds.removeAll()
            }
        }
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
