import SwiftUI

struct AddPlayersView: View {
    @Binding var currentScreen: Int
    @ObservedObject var gameVM: GameViewModel
    @State var playerName: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button("Home") {
                    currentScreen = 0
                }
                Spacer()
                Button("Ready") {
                    currentScreen = 2
                }
            }
            Text("Add Players")
                .font(.title)
            
            ForEach(gameVM.players, id: \.id) { player in
                HStack {
                    Text(player.position + 1, format: .number)
                    Text(player.name)
                }
            }
            
            TextField("Add player", text: $playerName)
            
            Button("Add player") {
                if playerName != "" {
                    let newPlayer = Player(name: playerName, position: gameVM.players.count)
                    gameVM.players.append(newPlayer)
                    playerName = ""
                }
            }
         }
    }
}

struct AddPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlayersView(
            currentScreen: .constant((1)),
            gameVM: GameViewModel()
        )
    }
}
