import SwiftUI

struct AddPlayersView: View {
    @Binding var currentScreen: Screens
    @ObservedObject var gameVM: GameViewModel
    @State var playerName: String = ""
    
    func delete(at offsets: IndexSet) {
        gameVM.players.remove(atOffsets: offsets)
    }
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                Button("Home") {
                    currentScreen = .home
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
                List {
                    ForEach(gameVM.players, id: \.id) { player in
                        if player.name != "Round" {
                            HStack {
                                Text(player.position, format: .number)
                                Text(":")
                                Text(player.name)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove { from, to in
                        print("Moving from \(from) to \(to)")
                        // Update position for item
                        for (index, item) in gameVM.players.enumerated() {
//                            if let playerIndex = gameVM.players.firstIndex(where: { $0.id == item.id }) {
//                                gameVM.players[playerIndex].position = index
//                            }
                        }
                    }
                }
                .listStyle(.plain)
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
                    currentScreen = .scorecardView
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
            currentScreen: .constant(.updatePlayers),
            gameVM: GameViewModel()
        )
    }
}
