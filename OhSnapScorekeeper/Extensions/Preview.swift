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
        let player1 = Player(name: "Lola", position: 1)
        let player2 = Player(name: "Albus", position: 2)
        let player3 = Player(name: "Becky", position: 3)
        let player4 = Player(name: "Hudson", position: 4)
        let player5 = Player(name: "Maggie", position: 5)
        let player6 = Player(name: "Maizey", position: 6)
        let player7 = Player(name: "Tim", position: 7)
        
        
        gameVM.players.append(player1)
        gameVM.players.append(player2)
        gameVM.players.append(player3)
        gameVM.players.append(player4)
        gameVM.players.append(player5)
        gameVM.players.append(player6)
        gameVM.players.append(player7)
 
    }
    
}
