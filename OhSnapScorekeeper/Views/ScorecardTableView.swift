import SwiftUI

struct ScorecardTableView: View {
    @ObservedObject var gameVM: GameViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 25) {
                    ForEach(gameVM.players, id: \.id) { player in
                        VStack(spacing: 10) {
                            // Player
                            Text(player.name)
                            
                            // Zip round array with indices for access to arrays
                            ForEach(Array(zip(gameVM.calculatedRoundArray.indices, gameVM.calculatedRoundArray)), id: \.0) { index, score in
                                // Player Scores
                                PlayerScoresView(
                                    player: player,
                                    index: index,
                                    score: score,
                                    isSelected: gameVM.currentRound == index
                                )
                                .onChange(of: gameVM.players) { newValue in
                                    if let lastPlayer = gameVM.players.last {
                                        gameVM.scrollTo(proxy, with: lastPlayer.id)
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
                            .padding(.top)
                        }
                        .id(player.id)
                    }
                }
                .padding()
                .background(.gray.opacity(0.2))
            }
        }
    }
}

struct ScorecardTableView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardTableView(gameVM: dev.gameVM)
    }
}

struct PlayerScoresView: View {
    let player: Player
    let index: Int
    let score: Int
    let isSelected: Bool
    var body: some View {
        HStack {
            if player.name == "Round" {
                Text("\(score)")
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
                    Text("_")
                }
            }
        }
        .font(isSelected ? .title2 : .body)
        .opacity(isSelected ? 1.0 : 0.8)
    }
}
