import SwiftUI

struct ScorecardTableView: View {
    let players: [Player]
    let calculatedRoundArray: [Int]
    let currentRound: Int
    let currentPosition: Int
    
    var body: some View {
        VStack {
            PlayerNameRowView(
                players: players,
                currentPosition: currentPosition
            )
            ScrollView {
                HStack(spacing: 10) {
                    VStack(spacing: 10) {
                        ForEach(Array(zip(calculatedRoundArray.indices, calculatedRoundArray)), id: \.0) { index, round in
                            RoundNumberView(
                                roundNumber: round,
                                isSelected: currentRound == index
                            )
                        }
                    }
                    HStack(spacing: 10) {
                        ForEach(players, id: \.id) { player in
                            VStack(spacing: 10) {
                                ForEach(player.rounds, id: \.id) { round in
                                    HStack {
                                        IndividualRoundScore(score: round.predictedScore)
                                        IndividualRoundScore(score: round.actualScore)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .shadow(color: .gray.opacity(0.5), radius: 3)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            TotalScoreRowView(players: players)
        }
        .padding()
    }
}


struct PlayerNameRowView: View {
    let players: [Player]
    let currentPosition: Int
    
    var body: some View {
        HStack {
            ForEach(players, id: \.id) { player in
                PlayerNameView(
                    playerName: player.name,
                    isSelected: player.name == players[currentPosition].name
                )
            }
        }
        .padding(.leading, 20)
    }
}
struct TotalScoreRowView: View {
    let players: [Player]
    var body: some View {
        HStack {
            ForEach(players, id: \.id) { player in
                TotalScoreView(score: player.totalScore)
            }
  
        }
        .padding(.leading, 20)
    }
}

struct TotalScoreView: View {
    let score: Int
    var body: some View {
        Text(score, format: .number)
            .frame(minWidth: 0, maxWidth: .infinity)
            .font(.caption)
            .fontWeight(.bold)
    }
}

struct ScorecardTableView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardTableView(
            players: dev.gameVM.players,
            calculatedRoundArray: dev.gameVM.calculatedRoundArray,
            currentRound: 0,
            currentPosition: 0
        )
    }
}



