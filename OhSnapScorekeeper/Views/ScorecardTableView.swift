import SwiftUI

struct ScorecardTableView: View {
    let players: [Player]
    let calculatedRoundArray: [Int]
    let currentRound: Int
    let currentPosition: Int
    
    var rows: [GridItem] = [
        GridItem(.flexible())
    ]
    
    func scrollTo(_ proxy: ScrollViewProxy, with item: UUID) {
        proxy.scrollTo(item)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(players, id: \.id) { player in
                        VStack {
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
                                    isSelected: currentRound == index && currentPosition == player.position
                                )
                                .onChange(of: players) { newValue in
                                    // Use the position to get the player id for scrolling to
                                    if let player = players.first(where: { $0.position == currentPosition }) {
                                        scrollTo(proxy, with: player.id)
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
                            .padding(.top, 5)
                        }
                        .id(player.id)
                        .padding(.trailing, player.name != "Round" ? 20 : 0)
                    }
                }
                .padding()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.gray.opacity(0.1))
        }
    }
}

struct ScorecardTableView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardTableView(
            players: dev.gameVM.players,
            calculatedRoundArray: [1, 2, 3, 4, 3, 2, 1],
            currentRound: 0,
            currentPosition: 1
        )
    }
}

struct PlayerScoresView: View {
    let player: Player
    let index: Int
    let score: Int
    let isSelected: Bool
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
            .padding(3)
            .frame(minWidth: 60)
            if isSelected {
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(height: 2, alignment: .top)
            } else if player.name != "Round" {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(height: 2, alignment: .top)
            } else {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 2, alignment: .top)
            }
        }
        .cornerRadius(5)
        .opacity(isSelected ? 1.0 : 0.8)
    }
}
