import Foundation

class GameViewModel: ObservableObject {
    var ohSnapGame = OhSnapGame()
    
    var startingNumber: Int = 7
    var calculatedRoundArray: [String] {
        var returnedArray:[String] = ["Name"]
        for number in (0..<startingNumber).reversed() {
            returnedArray.append(String(number))
        }
        for number in (1..<startingNumber) {
            returnedArray.append(String(number))
        }
        return returnedArray
    }
    @Published var players: [Player] = []
    
    init() {

        
    }
}
