import SwiftUI

struct AddPlayersView: View {
    @Binding var currentScreen: Screens
    @ObservedObject var gameVM: GameViewModel
    @State var playerName: String = ""
    @State var startingNumber: Int = 7
    
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
        NavigationStack {
            VStack(spacing: 25) {
                Spacer()
                
                TextField("Player name", text: $playerName)
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(.title)
                    .background(Color.gray.opacity(0.15))
                
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
                .navigationTitle("Add players")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") {
                            currentScreen = .home
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
            .listStyle(.plain)
            
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
                
                VStack {
                    Text("Starting # of cards")
                        .bold()
                    Picker("Starting Number", selection: $startingNumber) {
                        ForEach(0..<8) { index in
                            Text(index, format: .number)
                        }
                    }
                    .onChange(of: startingNumber, perform: { starting in
                        gameVM.startingNumber = starting
                    })
                    .pickerStyle(.segmented)
                }
                .padding()
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
