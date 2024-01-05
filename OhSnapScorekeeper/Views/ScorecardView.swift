import SwiftUI

struct ScorecardView: View {
    @Binding var currentScreen: Int
    @ObservedObject var gameVM: GameViewModel
    @State var currentPosition: Int = 0
    @State var currentGuess: Int = 0
    
    var body: some View {
        VStack {
            
            Button("All done!") { currentScreen = 0 }
            HStack(alignment: .top) {
                VStack {
                    
                    ForEach(gameVM.calculatedRoundArray, id: \.self) { index in
                        Text(index)
                    }
                }
                HStack(spacing: 25) {
                    ForEach(gameVM.players, id: \.id) { player in
                        VStack {
                            Text(player.name)
                                .bold()
                            HStack {
                                Text("guess")
                                Text("|")
                                Text("got")
                            }
                            .font(.caption)
                            if player.rounds.count == 0 {
                                HStack {
                                    Text("X")
                                    Text("|")
                                    Text("X")
                                }
                            } else {
                 
                                ForEach(player.rounds, id: \.id) { round in
                                    HStack {
                                        if round.predictedScore != nil {
                                            if let prediction = round.predictedScore {
                                                Text(prediction, format: .number)
                                            } else {
                                                Text("X")
                                            }
                                        
                                        } else {
                                            Text("x")
                                        }
                                        Text("|")
                                        if let actual = round.actualScore {
                                            Text(actual, format: .number)
                                            Text("Whyyyy")
                                        } else {
                                            Text("x")
                                        }
                                    }
                                }
                            }
                            Spacer()
                            Text("Total Score")
                                .bold()
                            Text(player.totalScore, format: .number)
                        }
                    }
                }
            }
            .padding()
            // Entering input section
            // 1 enter predictions for all players
            // 2 play round
            // 3 enter actual scores for all players
            // 4 end round and start new round
            
            if gameVM.players.count > 0 {
                Button("Enter guess for \(gameVM.players[currentPosition].name)") {
                    // Update current player with the guess
                    var newRound = Round(predictedScore: currentGuess)
                    gameVM.players[currentPosition].rounds.append(newRound)
                    if currentPosition + 1 >= gameVM.players.count {
                        currentPosition = 0
                    } else {
                        currentPosition += 1
                    }
                }
                TextField("Guess", value: $currentGuess, formatter: NumberFormatter())
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct ScorecardView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardView(
            currentScreen: .constant(2),
            gameVM: dev.gameVM
        )
        .preferredColorScheme(.light)
    }
}
