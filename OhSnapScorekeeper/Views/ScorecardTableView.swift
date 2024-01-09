import SwiftUI

struct ScorecardTableView: View {
    let players: [Player]
    let calculatedRoundArray: [Int]
    let currentRound: Int
    let currentPosition: Int
    let tableHeight: Double
    
    func scrollTo(_ proxy: ScrollViewProxy, with item: UUID) {
        proxy.scrollTo(item, anchor: .center)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(players, id: \.id) { player in
                        VStack(spacing: 0) {
                            // Player
                            if player.name == "Round" {
                                Text(player.name)
                                    .fontWeight(.light)
                            } else {
                                Text(player.name)
                            }
                            
                            // Zip round array with indices for access to arrays
                            ForEach(Array(zip(calculatedRoundArray.indices, calculatedRoundArray)), id: \.0) { index, score in
                                // Player Scores
                                PlayerScoresView(
                                    player: player,
                                    index: index,
                                    score: score,
                                    isSelected: currentRound == index && currentPosition == player.position,
                                    tableHeight: tableHeight,
                                    roundCount: calculatedRoundArray.count
                                )
                                .id(player.id)
                                .onChange(of: players) { newValue in
                                    // Use the position to get the player id for scrolling to
                                    print("Update position")
                                    if let player = players.first(where: { $0.position == currentPosition + 1 }) {
                                        scrollTo(proxy, with: player.id)
                                        print("Update position 2")
                                    } else if let playerID = players.first {
                                        scrollTo(proxy, with: playerID.id)
                                    }
                            
                                }
                            }
                           
                            VStack {
                                if player.name != "Round" {
                                    Text(player.totalScore, format: .number)
                                } else {
                                    Text("Total")
                                }
                            }
                            .bold()
                        }
                       
                        .padding(.trailing, player.name != "Round" ? 20 : 0)
                    }
                }
            }
            .padding(5)
        }
    }
}

struct ScorecardTableView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardTableView(
            players: dev.gameVM.players,
            calculatedRoundArray: [7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7],
            currentRound: 0,
            currentPosition: 1,
            tableHeight: 200
        )
    }
}

struct PlayerScoresView: View {
    let player: Player
    let index: Int
    let score: Int
    let isSelected: Bool
    let tableHeight: Double
    let roundCount: Int
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if player.name == "Round" {
                    Text("\(score)")
                        .fontWeight(.light)
                }
                
                if player.name != "Round" {
                    // Get first guess and actual round
                    if index >= player.rounds.startIndex && index < player.rounds.count {
                        if let predictedScore = player.rounds[index].predictedScore {
                            Text(predictedScore, format: .number)
                        }
                        Text("|")
                        if let actualScore = player.rounds[index].actualScore {
                            Text(actualScore, format: .number)
                            
                        } else {
                            Text("_")
                            
                        }
                    } else {
                        Text("-")
                    }
                }
            }
            .frame(height: tableHeight / (Double(roundCount) + 2))
            .frame(minWidth: 60)
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.blue.opacity(0.24))
                }
            }
        }
        .cornerRadius(5)
        .opacity(isSelected ? 1.0 : 0.8)
    }
}
