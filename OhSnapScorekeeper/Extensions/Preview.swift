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
        let player1 = Player(name: "Lola", position: 0)
        let player2 = Player(name: "Albus", position: 1)
        
        gameVM.players.append(player1)
        gameVM.players.append(player2)
    }
    
}
