import Foundation

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
