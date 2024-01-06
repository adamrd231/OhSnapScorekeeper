import SwiftUI

struct ScorecardTableView: View {
    @ObservedObject var gameVM: GameViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 25) {
                ForEach(gameVM.players, id: \.id) { player in
                    VStack(spacing: 10) {
                        // Player
                        if player.name != "Round" {
                            Text(player.name)
                                .bold()
                        }
                        
                        // Zip round array with indices for access to arrays
                        ForEach(Array(zip(gameVM.calculatedRoundArray.indices, gameVM.calculatedRoundArray)), id: \.0) { index, item in
                            HStack {
                                if player.name == "Round" {
                                    Text("\(item)")
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
                            .font(gameVM.currentRound == index ? .title2 : .body)
                            .opacity(gameVM.currentRound == index ? 1.0 : 0.8)
                        }
                        if player.name != "Round" {
                            VStack {
                                Text("Total")
                                    .bold()
                                Text(player.totalScore, format: .number)
                            }
                            .padding(.top)
                        }
                    }
                }
            }
            .padding()
            .background(.gray.opacity(0.3))
        }
    }
}

struct ScorecardTableView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardTableView(gameVM: dev.gameVM)
    }
}
