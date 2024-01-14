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
        ScrollView {
        HStack(spacing: 10) {
            ForEach(players, id: \.id) { player in

                VStack(spacing: 10) {
                        Text(player.name)
                            .bold()
                        ForEach(player.rounds, id: \.id) { round in
                            HStack {
                                if let guess = round.predictedScore {
                                    Text(guess, format: .number)
                                } else {
                                    Text("-")
      
                                }
                                if let actual = round.actualScore {
                                    Text(actual, format: .number)
                                } else {
                                    Text("-")
     
                                        
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                            .background(.white)
                            .cornerRadius(9)
                            .shadow(color: .gray, radius: 5)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
                
             
            }
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


// TODO: Build GeometryReader modifier to size the height
struct PlayerScoresView: View {
    let player: Player
    let isSelected: Bool
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Get first guess and actual round
                if player.position >= player.rounds.startIndex && player.position < player.rounds.count {
                    if let predictedScore = player.rounds[player.position].predictedScore {
                        Text(predictedScore, format: .number)
                    }
                    Text("|")
                    if let actualScore = player.rounds[player.position].actualScore {
                        Text(actualScore, format: .number)
                        
                    } else {
                        Text("_")
                        
                    }
                } else {
                    Text("-")
                }
            }
        }
        .frame(minWidth: 60)
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.blue.opacity(0.24))
            }
        }
    }
}
