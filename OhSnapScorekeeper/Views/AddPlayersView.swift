import SwiftUI

struct AddPlayersView: View {
    @Binding var currentScreen: Int
    @ObservedObject var gameVM: GameViewModel
    @State var playerName: String = ""
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                Button("Home") {
                    currentScreen = 0
                }
                Spacer()
            }
            .padding()
            
            Spacer()
            
            
            TextField("Add player", text: $playerName)
                .multilineTextAlignment(.center)
                .padding()
                .font(.title)
            
            VStack(spacing: 5) {
                List(gameVM.players, id: \.id) { player in
                    if player.name != "Round" {
                        HStack {
                            Text(player.position, format: .number)
                            Text(":")
                            Text(player.name)
                        }
                    }
                }
            }
            
            
            VStack(spacing: 10) {
                Button("Add player") {
                    if playerName != "" {
                        let newPlayer = Player(name: playerName, position: gameVM.players.count)
                        gameVM.players.append(newPlayer)
                        playerName = ""
                    }
                }
                .buttonStyle(.bordered)
                
                Button("Start Game") {
                    currentScreen = 2
                }
                .disabled(gameVM.players.count < 3)
                .buttonStyle(.borderedProminent)

            }
            
            Spacer()
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
