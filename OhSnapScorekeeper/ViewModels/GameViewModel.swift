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
    
    @Published var currentRound: Int = 0 {
        willSet {
            lastRound = currentRound
        }
    }
    var lastRound = 0
    @Published var currentPosition: Int = 0 {
        willSet {
            lastPosition = currentPosition
        }
    }
    var lastPosition = 0
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
            // if not all the guesses have been deleted, just cycle back one position
            print(players.filter({ $0.rounds[currentRound].predictedScore != nil }).count)
            if players.filter({ $0.rounds[currentRound].predictedScore != nil }).count > 0 {
                print("Guesses remaining")
                if currentPosition - 1 < 0 {
                    currentPosition = players.count - 1
                    deleteEntry()
                    
                } else {
                    currentPosition -= 1
                    deleteEntry()
                }
                
            } else {
                print("No guesses left")
                guard currentRound > 0 else { return }
                currentRound -= 1
                currentPosition = lastPosition
                gameState = .enteringActuals
                deleteEntry()

               
                if dealerPosition - 1 < 0 {
                    dealerPosition = players.count - 1
                } else {
                    dealerPosition -= 1
                }
            }
            
            
            
        // Currently entering a score
        case .enteringActuals:
            // Check if deleting this score is the last score in the round
            print("actual score count: \(players.filter({ $0.rounds[currentRound].actualScore != nil }).count)")
            print("Player count \(players.count)")
            if players.filter({ $0.rounds[currentRound].actualScore != nil}).count > 0 {
                print("Scores remaining")
                if currentPosition - 1 < 0 {
                    currentPosition = players.count - 1
                } else {
                    currentPosition -= 1
                }
                deleteEntry()
               
   
            } else {
                print("No scores remaining")
                // switch back to guessing
                gameState = .enteringGuesses
                // go back one position
                if currentPosition - 1 < 0 {
                    currentPosition = players.count - 1
 
                } else {
                    currentPosition -= 1
                }
                // delete guess
                deleteEntry()
            }
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
            players[currentPosition].rounds[currentRound].predictedScore = nil
        case .enteringActuals:
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
                    // Update dealer position
                    if dealerPosition + 1 >= players.count {
                        dealerPosition = 0
                    } else {
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
        updateGameState()
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
