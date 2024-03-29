import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    let gameVM = GameViewModel()

    
    private init() {

        gameVM.startingNumber = 7
        var player1 = Player(name: "Lola", position: 0)
        var player2 = Player(name: "Albus", position: 1)
        var player3 = Player(name: "Becky", position: 2)
        var player4 = Player(name: "Hudson", position: 3)
        var player5 = Player(name: "Maggie", position: 4)
        var player6 = Player(name: "Maizey", position: 5)
        var player7 = Player(name: "Tim", position: 6)

        
        gameVM.players.append(player1)
        gameVM.players.append(player2)
        gameVM.players.append(player3)
        gameVM.players.append(player4)
        gameVM.players.append(player5)
        gameVM.players.append(player6)
        gameVM.players.append(player7)
        

        for index in 0..<gameVM.players.count {
            for _ in 0..<gameVM.calculatedRoundArray.count {
                gameVM.players[index].rounds.append(Round())
            }
        }
    }
}
