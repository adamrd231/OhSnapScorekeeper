import SwiftUI

struct AddPlayersView: View {
    @Binding var currentScreen: Screens
    @ObservedObject var gameVM: GameViewModel
    @State var playerName: String = ""
    
    func delete(at offsets: IndexSet) {
        gameVM.players.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        gameVM.players.move(fromOffsets: source, toOffset: destination)
        for index in 0..<gameVM.players.count {
            gameVM.players[index].position = index
        }
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
                NavigationStack {
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
                        .onMove(perform: move)
                    }
                    .toolbar {
                        EditButton()
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
